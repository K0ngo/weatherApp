//
//  City+CoreDataProperties.h
//  
//
//  Created by Alexander Bakuta on 05/10/2017.
//
//

#import "City+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface City (CoreDataProperties)

+ (NSFetchRequest<City *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *country;
@property (nonatomic) int16_t identifier;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSObject *location;

@end

NS_ASSUME_NONNULL_END
