//
//  GMDogFoodDataBase.h
//  DogFood
//
//  Created by  on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FoodProducts.h"

@interface GMDogFoodDataBase : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (NSURL *)applicationDocumentsDirectory;
- (void)importCoreDataDefaultFoodProducts;
- (void) deleteAllDataFromDataBase;

@end
