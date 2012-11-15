//
//  AppDelegate.h
//  DogFood
//
//  Created by Jose Antonio Gabriel Massana on 01/10/12.
//  Copyright (c) 2012 Jose Antonio Gabriel Massana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "FoodProducts.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

@end
