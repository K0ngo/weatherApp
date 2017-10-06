//
//  City+CoreDataClass.m
//  
//
//  Created by Alexander Bakuta on 05/10/2017.
//
//

#import "City+CoreDataClass.h"
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

NSString* const kCDCityEntityProperyID             = @"id";
NSString* const kCDCityEntityProperyName           = @"name";
NSString* const kCDCityEntityProperyCountry        = @"country";
NSString* const kCDCityEntityProperyLocation       = @"coord";
NSString* const kCDCityEntityProperyLocationLon    = @"lon";
NSString* const kCDCityEntityProperyLocationLat    = @"lat";

@implementation City

+ (NSString *)entityName {
    return @"City";
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {

    if (nil == dictionary) return;
    
    if (nil != dictionary[kCDCityEntityProperyID]) {
        self.identifier = [dictionary[kCDCityEntityProperyID] intValue];
    }
    
    if (nil != dictionary[kCDCityEntityProperyName]
        && [dictionary[kCDCityEntityProperyName] isKindOfClass:[NSString class]]) {
        self.name = dictionary[kCDCityEntityProperyName];
    }
    
    if (nil != dictionary[kCDCityEntityProperyCountry]
        && [dictionary[kCDCityEntityProperyCountry] isKindOfClass:[NSString class]]) {
        self.country = dictionary[kCDCityEntityProperyCountry];
    }
    
    if (nil != dictionary[kCDCityEntityProperyLocation]
        && [dictionary[kCDCityEntityProperyLocation] isKindOfClass:[NSDictionary class]]) {
        double lon, lat;
        NSDictionary * coordinatesDict = dictionary[kCDCityEntityProperyLocation];
    
        lon = [coordinatesDict[kCDCityEntityProperyLocationLon] doubleValue];
        lat = [coordinatesDict[kCDCityEntityProperyLocationLat] doubleValue];
     
        self.location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    }
}

@end
