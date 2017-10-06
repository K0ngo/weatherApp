//
//  NetworkManager.m
//  weatherApp
//
//  Created by Alexander Bakuta on 06/10/2017.
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "CityModel.h"

static NSString* kWeatherApiKey    = @"f0e84a19ba2624ed79d67322372ee688";

static NSString* _findUrl    = @"http://api.openweathermap.org/data/2.5/find";
static NSString* _historyUrl = @"http://api.openweathermap.org/data/2.5/forecast";

@interface NetworkManager ()

@property AFHTTPSessionManager* sessionManager;

@end

@implementation NetworkManager

+ (instancetype)shared {
    static NetworkManager * shared = nil;
    if (!shared) {
        shared = [NetworkManager new];
    }
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sessionManager = [AFHTTPSessionManager manager];
        self.sessionManager.requestSerializer  = [AFJSONRequestSerializer  serializer];
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSMutableSet* responseTypes = [NSMutableSet setWithSet:self.sessionManager.responseSerializer.acceptableContentTypes];
        [responseTypes addObject:@"application/json"];
        [responseTypes addObject:@"text/html"];
        
        self.sessionManager.responseSerializer.acceptableContentTypes = responseTypes;
        ((AFJSONResponseSerializer *)self.sessionManager.responseSerializer).readingOptions = NSJSONReadingMutableContainers | NSJSONReadingAllowFragments;
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

- (void)getCityWithCoordinateLat:(double)lat lon:(double)lon completionHadnler:(RequestCallbackBlock)block {
    
    NSDictionary *params = [[NSDictionary alloc]
                                 initWithObjectsAndKeys:[NSNumber numberWithDouble:lat], @"lat",
                                 [NSNumber numberWithDouble:lon], @"lon",
                                 [NSNumber numberWithInteger:1], @"cnt",
                                 kWeatherApiKey, @"APPID",
                                 nil];
    [_sessionManager GET:_findUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        CityModel* city = [[CityModel alloc] initWithResponseCity:responseObject];
       
        block (city, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error");
    }];
}

- (void)getHistoryFiveDaysBycityID:(NSInteger)identifier completionHadnler:(RequestCallbackBlock)block {
    
    NSDictionary *params = [[NSDictionary alloc]
                            initWithObjectsAndKeys:[NSNumber numberWithInteger:identifier], @"id",
                            kWeatherApiKey, @"APPID",
                            nil];
    [_sessionManager GET:_historyUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        CityModel* city = [[CityModel alloc] initWithHistoryResponseCity:responseObject];

        block (city, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error");
    }];
}
@end
