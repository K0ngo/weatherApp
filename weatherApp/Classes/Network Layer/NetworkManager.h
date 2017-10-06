//
//  NetworkManager.h
//  weatherApp
//
//  Created by Alexander Bakuta on 06/10/2017.
//

#import <Foundation/Foundation.h>

typedef void (^RequestCallbackBlock)(id responseObject, NSError *error);

@interface NetworkManager : NSObject

+ (instancetype)shared;

- (void)getCityWithCoordinateLat:(double)lat lon:(double)lon completionHadnler:(RequestCallbackBlock)block;
- (void)getHistoryFiveDaysBycityID:(NSInteger)identifier completionHadnler:(RequestCallbackBlock)block;

@end
