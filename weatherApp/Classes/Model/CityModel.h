//
//  CityModel.h
//  weatherApp
//
//  Created by Alexander Bakuta on 06/10/2017.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CityModel : NSObject

@property (nonatomic) NSInteger identifier;
@property (nonatomic) NSString* name;
@property (nonatomic) CLLocationCoordinate2D coord;
@property (nonatomic) NSArray* weather;
@property (nonatomic) NSInteger temp;
@property (nonatomic) double temp_max;
@property (nonatomic) double temp_min;

- (instancetype)initWithResponseCity:(id)responseObject;
- (instancetype)initWithHistoryResponseCity:(id)responseObject;

@end
