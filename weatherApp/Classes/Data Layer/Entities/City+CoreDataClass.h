//
//  City+CoreDataClass.h
//  
//
//  Created by Alexander Bakuta on 05/10/2017.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSObject;

NS_ASSUME_NONNULL_BEGIN

extern NSString* const kCDCityEntityProperyID;
extern NSString* const kCDCityEntityProperyName;
extern NSString* const kCDCityEntityProperyCountry;
extern NSString* const kCDCityEntityProperyLocation;
extern NSString* const kCDCityEntityProperyLocationLon;
extern NSString* const kCDCityEntityProperyLocationLat;

@interface City : NSManagedObject

+ (NSString *)entityName;
- (void)updateWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END

#import "City+CoreDataProperties.h"
