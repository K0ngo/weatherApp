//
//  MigrationViewController.m
//  weatherApp
//
//  Created by Alexander Bakuta on 05/10/2017.
//

#import "MigrationViewController.h"
#import "CoreDataController.h"
#import "City+CoreDataClass.h"

typedef void (^MigrationProgressBlock)(float progress, BOOL complete);
typedef void (^MigrationCompleteBlock)(NSError * error);

@interface MigrationViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView*  progressView;

@end

@implementation MigrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self shouldLoadCities]) {
        
        __weak typeof(_progressView) weakProgressView = _progressView;
        
        [self loadRemoteCitiesWithProgressBlock:^(float progress, BOOL complete) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                __strong typeof(weakProgressView) strongProgressView = weakProgressView;
                
                if (!complete) {
                    [strongProgressView setProgress:progress animated:NO];
                } else {
                    [strongProgressView removeFromSuperview];
                }
            });
        } completionBlock:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                  
                if (nil != error) {
                    NSLog(@"Failure to save context: %@\n%@", [error localizedDescription], [error userInfo]);
                    return;
                }
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                UINavigationController * vc = [storyboard instantiateViewControllerWithIdentifier:@"NavStackID"];
                [self presentViewController:vc animated:YES completion:nil];
            });
        }];
    }
}

- (BOOL)shouldLoadCities {
    return YES;
}

- (void)loadRemoteCitiesWithProgressBlock:(MigrationProgressBlock)progressBlock
                          completionBlock:(MigrationCompleteBlock)completionBlock {
    NSPersistentContainer * container = [CoreDataController shared].persistentContainer;
    [container performBackgroundTask:^(NSManagedObjectContext * context) {
        [context setUndoManager:nil];
        
        MigrationProgressBlock wProgress   = [progressBlock copy];
        MigrationCompleteBlock wCompletion = [completionBlock copy];
        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"city_list" ofType:@"json"];
        NSData   * data = [NSData dataWithContentsOfFile:filePath];
        NSArray  * jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSInteger idx = 1;
        
        @autoreleasepool {
            for (NSDictionary * jsonObject in jsonArray) {
                
                City * cityEntity = [[City alloc] initWithContext:context];
                [cityEntity updateWithDictionary:jsonObject];
                idx++;
                
                if (idx % 100 == 0 || idx == jsonArray.count) {
                    if (nil != wProgress) {
                        wProgress((idx * 100 / jsonArray.count) * 0.01, false);
                    }
                    [context save:nil];
                    [context reset];
                }
            }
            data        = nil;
            jsonArray   = nil;
            filePath    = nil;
        }
        wProgress = nil;
        [context reset];
        context   = nil;
        
        if (nil != wCompletion) wCompletion (nil);
        wCompletion = nil;
    }];
}

@end
