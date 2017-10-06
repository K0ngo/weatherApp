//
//  CoreDataController.h
//  weatherApp
//
//  Created by Alexander Bakuta on 05/10/2017.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataController : NSObject

+ (instancetype)shared;
- (void)saveContext;

@property (strong, nonatomic, readonly) NSPersistentContainer* persistentContainer;

@end
