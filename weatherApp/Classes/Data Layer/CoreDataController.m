//
//  CoreDataController.m
//  weatherApp
//
//  Created by Alexander Bakuta on 05/10/2017.
//

#import "CoreDataController.h"

@interface CoreDataController ()

@property (strong, nonatomic, readwrite) NSPersistentContainer* persistentContainer;

@end

@implementation CoreDataController

+ (instancetype)shared {
    static CoreDataController* shared = nil;
    if (!shared) {
        shared = [CoreDataController new];
    }
    return shared;
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self.persistentContainer = [[NSPersistentContainer alloc] initWithName:@"weatherApp"];
    [self.persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *description, NSError *error) {
        if (error != nil) {
            NSLog(@"Failed to load Core Data stack: %@", error);
            abort();
        }
    }];
    
    return self;
}

#pragma mark -
#pragma mark Core Data Handle Methods

- (void)saveContext {
    NSManagedObjectContext * context = self.persistentContainer.viewContext;
    NSError * error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
