//
//  City+CoreDataProperties.m
//  
//
//  Created by Alexander Bakuta on 05/10/2017.
//
//

#import "City+CoreDataProperties.h"

@implementation City (CoreDataProperties)

+ (NSFetchRequest<City *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"City"];
}

@dynamic country;
@dynamic identifier;
@dynamic name;
@dynamic location;

@end
