//
//  CityModel.m
//  weatherApp
//
//  Created by Alexander Bakuta on 06/10/2017.
//

#import "CityModel.h"

NSString* const kModelCityResponseProperyList           = @"list";
NSString* const kModelCityResponseProperyCity           = @"city";
NSString* const kModelCityResponseProperyCityId         = @"id";
NSString* const kModelCityResponseProperyCityName       = @"name";
NSString* const kModelCityResponseProperyCoord          = @"coord";
NSString* const kModelCityResponseProperyCoordLat       = @"lat";
NSString* const kModelCityResponseProperyCoordLon       = @"lon";
NSString* const kModelCityResponseProperyWeather        = @"weather";
NSString* const kModelCityResponseProperyMain           = @"main";
NSString* const kModelCityResponseProperyMainTemp       = @"temp";
NSString* const kModelCityResponseProperyMainTempMax    = @"temp_max";
NSString* const kModelCityResponseProperyMainTempMin    = @"temp_min";

@implementation CityModel

- (instancetype)initWithResponseCity:(id)responseObject {
    self = [super init];
    
    if (self) {
        
        NSArray* list = [[NSArray alloc] initWithArray:responseObject[kModelCityResponseProperyList]];
        NSDictionary* dictCity = [[NSDictionary alloc] initWithDictionary:list.firstObject];
        
        self.identifier = [dictCity[kModelCityResponseProperyCityId] integerValue];
        self.name = dictCity[kModelCityResponseProperyCityName];
        
        NSDictionary* coord = [[NSDictionary alloc] initWithDictionary:dictCity[kModelCityResponseProperyCoord]];
        double lat = [coord[kModelCityResponseProperyCoordLat] doubleValue];
        double lon = [coord[kModelCityResponseProperyCoordLon] doubleValue];
        CLLocationDegrees latDegrees = lat;
        CLLocationDegrees lonDegrees = lon;
        self.coord = CLLocationCoordinate2DMake(latDegrees, lonDegrees);
    
        self.weather = dictCity[kModelCityResponseProperyWeather];
        
        NSDictionary* dictMain = [[NSDictionary alloc] initWithDictionary:dictCity[kModelCityResponseProperyMain]];
        self.temp = [dictMain[kModelCityResponseProperyMainTemp] integerValue] - 273;
    }
    return self;
}

- (instancetype)initWithHistoryResponseCity:(id)responseObject {
    self = [super init];
    
    if (self) {

        NSDictionary* cityDict = [[NSDictionary alloc] initWithDictionary:responseObject[kModelCityResponseProperyCity]];
        self.name = cityDict[kModelCityResponseProperyCityName];
        self.identifier = [cityDict[kModelCityResponseProperyCityId] integerValue];

        NSArray* list = [[NSArray alloc] initWithArray:responseObject[kModelCityResponseProperyList]];

        double maxT = 0;
        double minT = 400;

        for (NSInteger i = 0; i < list.count; i++) {
            
            NSDictionary* dictList = [[NSDictionary alloc] initWithDictionary:list[i]];
            NSDictionary* dictMain = [[NSDictionary alloc] initWithDictionary:dictList[kModelCityResponseProperyMain]];
            double temp_min = [dictMain[kModelCityResponseProperyMainTempMin] doubleValue];
            double temp_max = [dictMain[kModelCityResponseProperyMainTempMax] doubleValue];
            maxT = (maxT >= temp_max) ? maxT : temp_max;
            minT = (minT <= temp_min) ? minT : temp_min;
        }
        self.temp_max = maxT - 273;
        self.temp_min = minT - 273;
    }
    return self;
}

@end
