//
//  GMDogFoodDataBase.m
//  DogFood
//
//  Created by  on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GMDogFoodDataBase.h"
#import "AppDelegate.h"

@implementation GMDogFoodDataBase

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize fetchedResultsController = __fetchedResultsController;

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DogFood.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
							 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }    
    
    return __persistentStoreCoordinator;
}



#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Add data to DataBase

- (void)insertFoodProductWithDogAge:(NSString *)fPDogAge withDogSize: (NSString *)fPDogSize withFoodBrand: (NSString *)fPFoodBrand withSelectOne: (NSString *) fPSelectOne withFoodName: (NSString *) fPFoodName withImage: (NSString *) fPImage withWebPage: (NSString *) fPWebPage withFoodDescription: (NSString *) fPFoodDescription
{        
    FoodProducts *foodProducts = [NSEntityDescription insertNewObjectForEntityForName:@"FoodProducts" inManagedObjectContext:self.managedObjectContext];
    
    foodProducts.dogAge = fPDogAge;     
    foodProducts.dogSize = fPDogSize;
    foodProducts.foodBrand = fPFoodBrand;
    foodProducts.selectOne = fPSelectOne;
    foodProducts.foodName = fPFoodName;
    foodProducts.image = fPImage;
    foodProducts.foodDescription = fPFoodDescription;
    foodProducts.webPage = fPWebPage;
    
    [self.managedObjectContext save:nil];
}

#pragma mark - Delete DataBase 

- (void) deleteAllDataFromDataBase
{
    NSLog(@"Deleting DataBase ------------------------------------------------------------------------------------------");

    // Allows to delete the database in a new release.

    NSError * error = nil;
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    
    // 1 - Decide what Entity you want
    NSString *entityName = @"FoodProducts"; 
    
    // 2 - Request that Entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 4 - Sort
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"foodBrand"
                                                                                     ascending:YES
                                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    NSArray *data = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (NSManagedObject *dat in data)
    {
        [self.managedObjectContext deleteObject:dat];
    }
                     
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError]; 
}

#pragma mark - Importing Core Data Default Values

- (void)importCoreDataDefaultFoodProducts 
{
    NSLog(@"Importing Core Data Default Values ...");
    
  
 #pragma mark - Royal Canin Breed Health Nutrition
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months"
                          withDogSize:@"Medium, "
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Boxer, Puppy, "
                         withFoodName:@"Boxer 30 Junior"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/boxer-30-junior"
                  withFoodDescription:@"Complete feed for dogs Specially for Boxer puppies - Up to 15 months old.\r\n\r\nOPTIMAL MUSCLE DEVELOPMENT\r\nHelps support muscle mass development thanks to an optimal protein content and a high level of L-carnitine.\r\n\r\nDIGESTIVE HEALTH\r\nHelps promote a balance in the intestinal flora.\r\n\r\nNATURAL DEFENCES\r\nHelps support the Boxer puppy’s natural defences.\r\n\r\nSPECIAL BRACHYCEPHALIC JAW\r\nA kibble exclusively designed to make it easier for your Boxer puppy to pick up and to encourage him to chew.\r\n"];
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Medium, "
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Boxer, "
                         withFoodName:@"Boxer 26 Adult"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/boxer-26-adult"
                  withFoodDescription:@"Complete dog feed for adult and mature Boxers - Over 15 months old.\r\n\r\nMUSCLE DYNAMISM\r\nHelps maintain muscle mass thanks to an optimal protein content (26%). L-carnitine helps promote energy production in muscles.\r\n\r\nCARDIAC TONE\r\nContributes to maintaining health of the cardiac muscle thanks to an optimal content of EPA & DHA, taurine and L-carnitine.\r\n\r\nANTIOXIDANT COCKTAIL\r\nThe added patented antioxidant complex helps neutralise free radicals in ageing Boxers.\r\n\r\nSPECIAL BRACHYCEPHALIC JAW\r\nA kibble exclusively designed to make it easier for your Boxer to pick up and to encourage him to chew.\r\n"];
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"Medium"
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Bulldog, Puppy, "
                         withFoodName:@"Bulldog 30 Junior"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/bulldog-30-junior"
                  withFoodDescription:@"Complete feed for Bulldog puppies Up to 12 months old.\r\n\r\nDIGESTIVE SECURITY\r\nPromotes a balance in the intestinal flora and ensures optimal digestive tolerance for your Bulldog puppy thanks to L.I.P. proteins selected for their high digestibility.\r\n\r\nBONE & JOINT DEVELOPMENT SUPPORT\r\nHelps reduce the risk of excess weight gain and contributes to support the Bulldog puppy’s bone and joint development.\r\n\r\nNATURAL DEFENCES\r\nHelps support the Bulldog puppy’s natural defences.\r\n\r\nSPECIAL BRACHYCEPHALIC JAW\r\nA kibble exclusively designed to make it easier for your Bulldog puppy to pick up and to encourage him to chew.\r\n"];
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Medium"
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Bulldog"
                         withFoodName:@"Bulldog 24 Adult"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/bulldog-24-adult"
                  withFoodDescription:@"Complete dog feed for adult and mature Bulldogs - Over 12 months old.\r\n\r\nODOUR RECUCTION\r\nHelps reduce faecal smells and flatulence, and promotes good digestion thanks to highly digestible L.I.P. proteins, an appropriate fibre content and very high quality carbohydrate sources.\r\n\r\nSENSITIVE SKIN CONDITION\r\nHelps support the skin’s “barrier” role (patented complex) and maintain the natural beauty of the Bulldog’s coat.\r\n\r\nBONE & JOINT SUPPORT\r\nEnriched with EPA and DHA. Specific formula to help support healthy bones and joints.\r\n\r\nSPECIAL BRACHYCEPHALIC JAW\r\nA kibble exclusively designed to make it easier for your Bulldog to pick up and to encourage him to chew.\r\n"];
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Mini, "
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Cavalier King Charles, "
                         withFoodName:@"Cavalier King Charles Adult"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/cavalier-king-charles-adult"
                  withFoodDescription:@"Complete dog feed for adult and mature Cavalier King Charles Spaniels - Over 10 months old.\r\n\r\nCARDIAC TONE\r\nCAVALIER KING CHARLES ADULT contains the nutrients necessary to help support good cardiac function: adapted content of minerals, EPA & DHA, taurine, L-carnitine and antioxidants.\r\n\r\nIDEAL WEIGHT\r\nThis formula helps maintain the Cavalier King Charles Spaniel's ideal weight.\r\n\r\nCOAT HEALTH\r\nThis formula contains nutrients which help support a healthy skin and coat. Enriched with EPA & DHA and borage oil.\r\n\r\nEXCLUSIVE KIBBLE: SPECIAL BRACHYCEPHALIC JAW\r\nA kibble exclusively designed to make it easier for the Cavalier King Charles Spaniel to pick up and to encourage him to chew.\r\n"];
    
    
    [self insertFoodProductWithDogAge:@"0-12 months"
                          withDogSize:@"Mini, X-Small, "
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Puppy, Chihuahua, "
                         withFoodName:@"Chihuahua Junior"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/chihuahua-junior"
                  withFoodDescription:@"Complete feed for dogs - Specially for Chihuahua puppies - Up to 8 months old.\r\n\r\nHIGH PALATABILITY\r\nCHIHUAHUA JUNIOR satisfies the Chihuahua's appetite thanks to the combination of three factors: an adapted kibble size and shape, an exclusive formulation and selected flavours.\r\n\r\nSTOOL AND ODOUR REDUCTION\r\nThis formula helps reduce faecal smell and volume.\r\n\r\nNATURAL DEFENCES\r\nThis formula helps support the Chihuahua puppy's natural defences.\r\n\r\nEXCLUSIVE KIBBLE: SPECIAL MINIATURE JAW\r\nExclusive kibble which is adapted to the Chihuahua puppy's small jaw.\r\n"];
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Mini, X-Small, "
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Chihuahua"
                         withFoodName:@"Chihuahua Adult"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/chihuahua-adult"
                  withFoodDescription:@"Complete feed for dogs - Specially for adult and mature Chihuahuas - Over 8 months old.\r\n\r\nHIGH PALATABILITY\r\nCHIHUAHUA ADULT satifies the Chihuahua's appetite thanks to the combination of three factors: an adapted kibble size and shape, an exclusive formulation and selected flavours.\r\n\r\nSTOOL & ODOUR REDUCTION\r\nThis formula helps reduce faecal smell and volume.\r\n\r\nDENTAL HEALTH\r\nThis formula helps reduce tartar formation thanks to calcium chelators.\r\n\r\nEXCLUSIVE KIBBLE: SPECIAL MINIATURE JAW\r\nExclusive kibble which is adapted to the Chihuahua's small jaw.\r\n"];
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 year"
                          withDogSize:@"Medium, "
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Cocker Spaniel, English Springer Spaniels and American Cocker Spaniels"
                         withFoodName:@"Cocker Adult"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/cocker-adult"
                  withFoodDescription:@"Complete feed for dogs - Specially for adult and mature, English or American Cocker Spaniels - Over 12 months old.\r\n\r\nHEALTHY SKIN & COAT\r\nCOCKER ADULT helps support the skin's 'barrier' role (exclusive complex), maintain skin health (EPA & DHA, vitamin A) and nourish the coat. Enriched with borage oil.\r\n\r\nIDEAL WEIGHT\r\nThis formula helps maintain the Cocker Spaniel's ideal weight.\r\n\r\nCARDIAC TONE\r\nThis formula contributes to maintaining health of the cardiac muscle.\r\n\r\nEXCLUSIVE KIBBLE: DENTAL HEALTH\r\nThis formula helps reduce tartar formation thanks to calcium chelators.\r\n"];
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"Mini"
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Dachshund, Puppy"
                         withFoodName:@"Dachshund Junior"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/dachshund-junior"
                  withFoodDescription:@"Complete feed for dogs - Specially for Dachshund puppies - Up to 10 months old.\r\n\r\nJOINT & BONE SUPPORT\r\nDACHSHUND JUNIOR contributes to supporting the Dachshund puppy’s bones and joints thanks to adapted calcium and phosphorus content. This exclusive formula also helps maintain ideal weight.\r\n\r\nDIGESTIVE HEALTH\r\nThis formula contributes to supporting digestive health and promoting a balance in the intestinal flora.\r\n\r\nNATURAL DEFENCES\r\nThis formula helps support the Dachshund puppy’s natural defences.\r\n\r\nEXCLUSIVE KIBBLE : DENTAL HEALTH\r\nThis formula helps reduce tartar formation thanks to calcium chelators.\r\n"];
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Mini"
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Dachshund"
                         withFoodName:@"Dachshund Adult"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/dachshund-adult"
                  withFoodDescription:@"Complete feed for dogs - Specially for adult and mature Dachshunds - Over 10 months old.\r\n\r\nJOINT & BONE SUPPORT\r\nDACHSHUND ADULT contributes to supporting the Dachshund's bones and joints thanks to adapted calcium and phosphorus content. This exclusive formula also helps maintain ideal weight.\r\n\r\nMUSCLE TONE\r\nThis formula helps maintain the Dachshund's muscle tone.\r\n\r\nSTOOL AND ODOUR REDUCTION\r\nThis formula helps reduce faecal smell and volume.\r\n\r\nEXCLUSIVE KIBBLE : DENTAL HEALTH\r\nThis formula helps reduce tartar formation thanks to calcium chelators.\r\n"];
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Medium, Large, "
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Dalmatian, "
                         withFoodName:@"Dalmatian 22 Adult"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/dalmatian-22-adult"
                  withFoodDescription:@"Complete feed for dogs - Specially for adult and mature Dalmatians - Over 15 months old.\r\n\r\nURINARY TRACT MAINTENANCE\r\nDalmatian dogs are prone to developing stones. DALMATIAN 22 contributes to helping maintain a healthy urinary system thanks to carefully selected protein sources.\r\n\r\nSENSITIVE SKIN CONDITION\r\nHelps support the skin’s “barrier” role (patented complex).\r\n\r\nCARDIAC TONE\r\nContributes to maintaining health of the cardiac muscle.\r\n\r\nINTENSE COLOUR SPOTS\r\nContributes to intensifying the Dalmatian dog’s spot colour.\r\n"];
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"Medium, Mini, "
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"French Bulldog, Puppy"
                         withFoodName:@"French Bulldog Junior"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/french-bulldog-junior"
                  withFoodDescription:@"Complete feed for dogs - Specially for French Bulldog puppies - Up to 12 months old.\r\n\r\nDIGESTIVE HEALTH\r\nFRENCH BULLDOG JUNIOR helps promote a balance in the intestinal flora and optimal digestive tolerance thanks to L.I.P. proteins selected for their high digestibility.\r\n\r\nHEALTHY SKIN\r\nThis formula helps support the skin’s 'barrier' role (exclusive complex) and maintain skin health.\r\n\r\nNATURAL DEFENCES\r\nThis formula helps support the French Bulldog puppy’s natural defences.\r\n\r\nEXCLUSIVE KIBBLE: SPECIAL BRACHYCEPHALIC JAW\r\nA kibble exclusively designed to make it easier for the French Bulldog puppy to pick up and to encourage him to chew.\r\n"];
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Medium, Mini, "
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"French Bulldog, "
                         withFoodName:@"French Bulldog Adult"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/french-bulldog-adult"
                  withFoodDescription:@"Complete feed for dogs - Specially for adult and mature French Bulldogs - Over 12 months old.\r\n\r\nIDEAL MUSCLE MASS\r\nFRENCH BULLDOG ADULT contributes to maintaining muscle mass thanks to an optimal protein content (26%). This formula also contains L-carnitine.\r\n\r\nHEALTHY SKIN\r\nThis formula helps support the skin’s 'barrier' role (exclusive complex) and maintain skin health (EPA & DHA).\r\n\r\nODOUR REDUCTION\r\nThis formula contributes to reducing intestinal fermentation which may cause digestive disorders, flatulence and bad stool odour.\r\n\r\nEXCLUSIVE KIBBLE: SPECIAL BRACHYCEPHALIC JAW\r\nA kibble exclusively designed to make it easier for the French Bulldog to pick up and to encourage him to chew.\r\n"];
    
        
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months,  "
                          withDogSize:@"Large, "
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"German Shepherd, Puppy, "
                         withFoodName:@"German Shepherd 30 Junior"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/german-shepherd-30-junior"
                  withFoodDescription:@"Complete feed for dogs - Specially for German Shepherd puppies - Up to 15 months old.\r\n\r\nDIGESTIVE SECURITY\r\nAn exclusive combination of nutrients to support optimal digestive security (L.I.P. proteins) and a balanced intestinal flora (prebiotics: FOS, MOS) which also contribute to good stool quality. Takes into account the German Shepherd puppy’s digestive sensitivity. The concentrated energy level of GERMAN SHEPHERD 30 is aimed at limiting the risk of overloading the stomach.\r\n\r\nBONE & JOINT SUPPORT\r\nHelps promote harmonious growth and contribute to good bone mineralisation thanks to a balanced level of calcium and phosphorus.\r\n\r\nSENSITIVE SKIN CONDITION\r\nHelps support the skin’s “barrier” role and maintain the natural beauty of the German Shepherd puppy’s coat.\r\n\r\nNATURAL DEFENCES\r\nHelps support the German Shepherd puppy’s natural defences.\r\n"];
    
    
        
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, "
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"German Shepherd, "
                         withFoodName:@"German Shepherd 24 Adult"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/german-shepherd-24-adult"
                  withFoodDescription:@"Complete dog feed for adult and mature German Shepherds - Over 15 months old.\r\n\r\nTARGETED DIGESTIVE PERFORMANCE\r\nEnsures optimal digestive security, taking into account the German Shepherd’s digestive sensitivity, thanks to highly digestible L.I.P. proteins and a selection of fibres which specifically limit intestinal fermentation while maintaining intestinal flora.\r\n\r\nSENSITIVE SKIN CONDITION\r\nHelps support the skin’s “barrier” role and maintains the natural beauty of the German Shepherd’s coat.\r\n\r\nNATURAL DEFENCES\r\nHelps support the natural defences of the active dog and helps older dogs maintain skin health.\r\n\r\nBONE & JOINT SUPPORT\r\nHelps support the German Shepherd’s bones and joints placed under stress.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, "
                          withDogSize:@"Large, "
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Golden Retriever, Puppy"
                         withFoodName:@"Golden Retriever 29 Junior"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/golden-retriever-29-junior"
                  withFoodDescription:@"Complete feed for dogs - Specially for Golden Retriever puppies up to 15 months old.\r\n\r\nSKIN & COAT DEFENCE\r\nGOLDEN RETRIEVER 29 helps support skin and coat, which are the puppy’s first natural defences, thanks to a patented complex and borage oil.\r\n\r\nDIGESTIVE SECURITY\r\nEnsures optimal digestive security and a balanced intestinal flora for the Golden Retriever puppy.\r\n\r\nBONE & JOINT SUPPORT\r\nHelps promote harmonious growth and contribute to good bone mineralisation thanks to a balanced level of calcium and phosphorus.\r\n\r\nNATURAL DEFENCES\r\nHelps support the Golden Retriever puppy’s natural defences.\r\n"];
    
        
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, "
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Golden Retriever, "
                         withFoodName:@"Golden Retriever 25 Adult"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/golden-retriever-25-adult"
                  withFoodDescription:@"Complete dog feed for adult and mature Golden Retrievers - Over 15 months old.\r\n\r\nBEAUTIFUL COAT\r\nOptimises quality and beauty of the Golden Retriever’s coat thanks to borage oil, biotin and sulphur amino acids.\r\n\r\nWEIGHT MANAGEMENT\r\nHelps maintain the ideal weight of the Golden Retriever.\r\n\r\nCARDIAC TONE\r\nContributes to maintaining health of the cardiac muscle.\r\n\r\nSUPPORTED CELLULAR FUNCTION\r\nThe added patented antioxidant complex helps neutralise free radicals.\r\n"];
    
        
    
    [self insertFoodProductWithDogAge:@"2-6 years, +6 years"
                          withDogSize:@"Giant"
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Great Dane, "
                         withFoodName:@"Great Dane 23"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/great-dane-23"
                  withFoodDescription:@"Complete dog feed for adult and mature Great Danes - Over 24 months old.\r\n\r\nCONCENTRATED ENERGY\r\nExclusive energy-giving kibbles which meet the needs of Great Danes without overfilling their stomach. Their shape, size and texture help limit the food intake rate, encouraging chewing and promoting oral hygiene. It is important to divide the daily ration into at least 2 meals in order to limit the risk of gastric dilatation-volvulus.\r\n\r\nTARGETED DIGESTIVE PERFORMANCE\r\nPromotes optimal digestive security, taking into account the Great Dane’s digestive sensitivity.\r\n\r\nBONE & JOINT SUPPORT\r\nEnriched with EPA and DHA. Specific formula to help support healthy bones and joints.\r\n\r\nANTIOXIDANT COCKTAIL\r\nThe added patented antioxidant complex helps neutralise free radicals in ageing Great Danes.\r\n"];
    
        
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, "
                          withDogSize:@"Large, "
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Labrador Retriever, Puppy, "
                         withFoodName:@"Labrador Retriever 33 Junior"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/labrador-retriever-33-junior"
                  withFoodDescription:@"Complete feed for dogs. Specially for Labrador Retriever puppies. Up to 15 months old.\r\n\r\nHEALTHY GROWTH & WEIGHT\r\nContributes to the healthy development of the growing Labrador’s bone structure and promotes harmonious weight gain thanks to an adapted intake of energy, protein, calcium and phosphorus.\r\n\r\nDIGESTIVE HEALTH\r\nPromotes a balance in the intestinal flora thanks to prebiotics and contributes to optimal stool quality thanks to L.I.P. proteins selected for their very high digestibility.\r\n\r\nNATURAL DEFENCES\r\nHelps support the Labrador puppy’s natural defences, thanks particularly to a patented antioxidant complex and manno-oligo-saccharides.\r\n\r\nHEALTHY SKIN & BEAUTIFUL COAT\r\nAn optimal level of fatty acids for a healthy skin and a shiny coat. Helps support the skin’s “barrier” role (patented complex).\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, "
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Labrador Retriever, "
                         withFoodName:@"Labrador Retriever 30 Adult"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/labrador-retriever-30-adult"
                  withFoodDescription:@"Complete feed for dogs - Specially for Labrador Retrievers over 15 months old.\r\n\r\nIDEAL WEIGHT FORMULA\r\nHelps maintain the adult Labrador’s ideal weight thanks to an adapted calorie content without reducing palatability.The kibble’s exclusive shape helps slow the rate of food intake.\r\n\r\nBONE & JOINT SUPPORT\r\nHelps support the Labrador’s bones and joints which can be placed under stress.\r\n\r\nHEALTHY SKIN & BEAUTIFUL COAT\r\nAn optimal level of fatty acids for a healthy skin and a shiny coat. Helps support the skin’s “barrier” role (patented complex).\r\n\r\nANTIOXIDANT COMPLEX\r\nThe patented antioxidant complex helps support cells during the ageing process in Labradors.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, "
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Maltese, "
                         withFoodName:@"Maltese Adult"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/maltese-adult"
                  withFoodDescription:@"Complete feed for dogs - Specially for adult and mature Malteses - Over 10 months old.\r\n\r\nCOAT HEALTH\r\nThis exclusive formula contributes to maintaining health of the Maltese's long coat. Enriched with adapted content of Omega 3 fatty acids (EPA & DHA),  Omega 6 fatty acids, borage oil and biotin.\r\n\r\nSTOOL AND ODOUR REDUCTION\r\nThis formula helps reduce faecal smell and volume.\r\n\r\nSATISFIES FUSSY APPETITES\r\nThis formula satisfies the fussiest of appetites thanks to a combination of exceptional flavours.\r\n\r\nEXCLUSIVE KIBBLE : DENTAL HEALTH\r\nThis formula helps reduce tartar formation thanks to calcium chelators.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Mini, "
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Miniature Schnauzer"
                         withFoodName:@"Miniature Schnauzer Adult"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/miniature-schnauzer-adult"
                  withFoodDescription:@"Complete feed for dogs - Specially for adult and mature Miniature Schnauzers - Over 10 months old.\r\n\r\nURINARY TRACT HEALTH\r\nThe Miniature Schnauzer is particularly proneto developing uroliths. MINIATURE SCHNAUZER ADULT helps maintain a healthy urinary system. Also encourage your dog to drink in order to promote urine dilution.\r\n\r\nINTENSE COAT COLOUR\r\nThis formula contains optimal levels of specific amino acids to help maintain the coat’s natural colour.\r\n\r\nIDEAL WEIGHT\r\nThis formula helps maintain the Miniature Schnauzer's ideal weight.\r\n\r\nEXCLUSIVE KIBBLE: DENTAL HEALTH\r\nThis formula helps reduce tartar formation thanks to calcium chelators.\r\n"];
    
    
        
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Medium, Mini, "
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Poodle, "
                         withFoodName:@"Poodle Adult"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/poodle-adult"
                  withFoodDescription:@"Complete feed for dogs - Specially for adult and mature Poodles - Over 10 months old.\r\n\r\nCOAT HEALTH\r\nThis formula contains nutrients which help maintain health of the Poodle’s woolly coat. Enriched with Omega 3 fatty acids (EPA & DHA) and borage oil. The adapted protein content helps support continuous hair growth.\r\n\r\nHEALTHY AGEING SUPPORT\r\nThis formula supplies a selection of nutrients to help maintain health in mature dogs.\r\n\r\nMUSCLE TONE\r\nThis formula helps maintain the Poodle’s muscle tone.\r\n\r\nEXCLUSIVE KIBBLE: DENTAL HEALTH\r\nThis formula helps reduce tartar formation thanks to calcium chelators.\r\n"];

    
        
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Mini"
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Pug, "
                         withFoodName:@"Pug Adult"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/pug-adult"
                  withFoodDescription:@"Complete feed for dogs - Specially for adult and mature Pugs - Over 10 months old.\r\n\r\nHEALTHY SKIN\r\nThis formula helps support the skin’s 'barrier' role (exclusive complex) and maintain skin health (EPA & DHA).\r\n\r\nMUSCLE TONE\r\nThis formula helps maintain the Pug’s muscle tone.\r\n\r\nIDEAL WEIGHT\r\nThis formula helps maintain the Pug's ideal weight.\r\n\r\nEXCLUSIVE KIBBLE: SPECIAL BRACHYCEPHALIC JAW\r\nA kibble exclusively designed to make it easier for the Pug to pick up and to encourage him to chew.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, Giant"
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Rottweiler"
                         withFoodName:@"Rottweiler 26"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/rottweiler-26"
                  withFoodDescription:@"Complete feed for dogs Specially for adult Rottweilers - Over 18 months old.\r\n\r\nCARDIAC TONE\r\nContributes to maintaining health of the cardiac muscle of this athletic dog thanks to an optimal content of EPA & DHA, taurine and L-carnitine.\r\n\r\nMUSCLE DYNAMISM\r\nIncreased L-carnitine content and adapted protein content, the essential component of muscle.\r\n\r\nBONE & JOINT SUPPORT\r\nEnriched with EPA and DHA. Specific formula to help support healthy bones and joints.\r\n\r\nSPECIAL MOLOSSOID JAW\r\nKibble exclusively adapted to the Rottweiler’s jaw, to encourage it to chew\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"Mini"
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Shih Tzu, Puppy, "
                         withFoodName:@"Shih Tzu Junior"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/shih-tzu-junior"
                  withFoodDescription:@"Complete dog feed for Shih Tzu puppies Up to 10 months old.\r\n\r\nHEALTHY SKIN & COAT\r\nSHIH TZU JUNIOR helps support the skin’s “barrier” role (exclusive complex), maintain skin health (EPA & DHA, vitamin A) and nourish the coat. Enriched with borage oil.\r\n\r\nDIGESTIVE HEALTH\r\nThis formula contributes to supporting digestive health and promoting a balance in the intestinal flora.\r\n\r\nNATURAL DEFENCES\r\nThis formula helps support the Shih Tzu puppy’s natural defences.\r\n\r\nEXCLUSIVE KIBBLE: SPECIAL BRACHYCEPHALIC JAW\r\nA kibble exclusively designed to make it easier for the Shih Tzu puppy to pick up and to encourage him to chew.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Mini"
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"West Highland White Terrier"
                         withFoodName:@"West Highland White Terrier Adult"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/west-highland-white-terrier-adult"
                  withFoodDescription:@"Complete feed for dogs - Specially adult and mature West Highland White Terriers - Over 10 months old.\r\n\r\nCOAT HEALTH\r\nCompared to other dog breeds, the West Highland White Terrier has a rough coat and delicate skin. This formula contains specific amino acids for hair growth and fatty acids from borage oil and flax seeds for skin health.\r\n\r\nHEALTHY SKIN\r\nThis formula helps support the skin’s 'barrier' role (exclusive complex) and maintain skin health (EPA & DHA).\r\n\r\nSATISFIES FUSSY APPETITES\r\nThis formula satisfies the fussiest of appetites thanks to a combination of exceptional flavours.\r\n\r\nEXCLUSIVE KIBBLE: DENTAL HEALTH\r\nThis formula helps reduce tartar formation thanks to calcium chelators.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Mini, "
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Shih Tzu"
                         withFoodName:@"Shih Tzu Adult"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/shih-tzu-adult"
                  withFoodDescription:@"Complete feed for dogs - Specially for adult and mature Shih Tzus - Over 10 months old.\r\n\r\nHEALTHY SKIN & COAT\r\nSHIH TZU ADULT helps support the skin’s “barrier” role (exclusive complex), maintain skin health (EPA & DHA, vitamin A) and nourish the coat. Enriched with borage oil.\r\n\r\nDENTAL HEALTH\r\nThis formula helps reduce tartar formation thanks to calcium chelators.\r\n\r\nSTOOL AND ODOUR REDUCTION\r\nThis formula helps reduce faecal smell and volume.\r\n\r\nEXCLUSIVE KIBBLE: SPECIAL BRACHYCEPHALIC JAW\r\nA kibble exclusively designed to make it easier for the Shih Tzu to pick up and to encourage him to chew.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"X-Small, Mini"
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Yorkshire Terrier, Puppy, "
                         withFoodName:@"Yorkshire Terrier Junior"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/yorkshire-terrier-junior"
                  withFoodDescription:@"Complete feed for dogs - Specially for Yorkshire Terrier puppies - Up to 10 months old.\r\n\r\nCOAT HEALTH\r\nThis exclusive formula contributes to maintaining health of the Yorkshire’s long coat. Enriched with adapted content of Omega 3 fatty acids (EPA & DHA), Omega 6 fatty acids, borage oil and biotin.\r\n\r\nDIGESTIVE HEALTH\r\nThis formula contributes to supporting digestive health and promoting a balance in the intestinal flora.\r\n\r\nNATURAL DEFENCES\r\nThis formula helps support the Yorkshire puppy’s natural defences.\r\n\r\nEXCLUSIVE KIBBLE: DENTAL HEALTH\r\nThis formula helps reduce tartar formation thanks to calcium chelators.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini"
                        withFoodBrand:@"Royal Canin Breed Health Nutrition"
                        withSelectOne:@"Yorkshire Terrier"
                         withFoodName:@"Yorkshire Terrier Adult"
                            withImage:@"royalCaninBreedHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/breed-health-nutrition/yorkshire-terrier-adult"
                  withFoodDescription:@"Complete feed for dogs - Specially for adult and mature Yorkshire Terriers - Over 10 months old.\r\n\r\nCOAT HEALTH\r\nThis exclusive formula contributes to maintaining health of the Yorkshire’s long coat. Enriched with adapted content of Omega 3 fatty acids (EPA & DHA), Omega 6 fatty acids, borage oil and biotin.\r\n\r\nSATISFIES FUSSY APPETITES\r\nThis formula satisfies the fussiest of appetites thanks to a combination of exceptional flavours.\r\n\r\nHEALTHY AGEING SUPPORT\r\nThis formula supplies a selection of nutrients to help maintain health in mature dogs.\r\n\r\nEXCLUSIVE KIBBLE: DENTAL HEALTH\r\nThis formula helps reduce tartar formation thanks to calcium chelators.\r\n"];
    
    
    
    #pragma mark - Royal Canin Size Health Nutrition
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Puppy, "
                         withFoodName:@"Babydog milk"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/x-small-dogs-up-to-4kg/babydog-milk"
                  withFoodDescription:@"Complete milk replacer feed for dogs - puppies from birth to weaning (0-2 months).\r\n\r\nHARMONIOUS GROWTH\r\nFor steady, harmonious growth, the composition of Babydog milk is as close as possible to bitch’s milk, with high energy and protein levels.\r\n\r\nDIGESTIVE SAFETY\r\nBabydog milk contains carefully selected ultra-digestible proteins, and has a lactose content very close to that of maternal milk.  It is particularly suitable for the puppy’s digestive system, because it does not contain starch, (puppies don’t secrete enough amylase to digest starch).  Finally, the addition of Fructo-Oligo-Saccharides (FOS) helps maintain a healthy balance of digestive flora.\r\n\r\nEASY TO PREPARE\r\nThanks to its exclusive formula, Babydog milk dissolves instantly and completely, with no sediment, creating a totally homogenous formula.\r\n\r\nENRICHED WITH DHA\r\nThe puppy’s nervous system continues to develop after birth. DHA naturally present in maternal milk helps develop cognitive function, and so Babydog milk is enriched with DHA.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Puppy, Pregnant or Nursing Dog, "
                         withFoodName:@"Starter Mousse"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/starter-mousse"
                  withFoodDescription:@"Complete dog feed for the bitch (gestation and lactation) and her puppies (from weaning up to 2 months old).\r\n\r\nBIRTH PROGRAMME\r\nInspired by professional research, BIRTH PROGRAMME is a unique nutritional solution which meets the needs of the bitch and her puppies during the first five stages of life cycle: gestation, birth, lactation, weaning and growth up to two months.\r\n\r\nULTRA SOFT MOUSSE\r\nThe unique mousse texture, perfectly adapted for 1st age puppies.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"X-Small, Mini"
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Puppy, "
                         withFoodName:@"X-Small Junior"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/x-small-dogs-up-to-4kg/x-small-junior"
                  withFoodDescription:@"Complete feed for dogs - For very small breed puppies (adult weight up to 4 kg).\r\n\r\nHEALTHY DIGESTION & TRANSIT\r\nAn exclusive combination of nutrients to support digestive health (L.I.P. proteins) and a balanced intestinal flora (prebiotics). Very small breed puppies are prone to constipation. A balanced intake of fibres (including psyllium) helps facilitate intestinal transit and contributes to good stool quality.\r\n\r\nINTENSIFIED ENERGY CONTENT\r\nMeets the very high energy needs of very small breed puppies during the growth period, and satisfies fussy appetites.\r\n\r\nDENTAL HEALTH\r\nHelps reduce tartar formation thanks to the chelation agents in calcium.\r\n\r\nNATURAL DEFENCES\r\nHelps support the puppy’s natural defences, thanks particularly to a patented antioxidant complex and prebiotics. This small-sized kibble has been developed to be perfectly adapted to the miniature jaw of dogs under 4 kg. Its exclusive formula also helps stimulate fussy appetites in very small breed dogs.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini"
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@""
                         withFoodName:@"X-Small Adult"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/x-small-dogs-up-to-4kg/x-small-adult"
                  withFoodDescription:@"Complete feed for adult dogs - For very small breed dogs (weight up to 4 kg).Over 10 months old.\r\n\r\nHEALTHY TRANSIT\r\nVery small breed dogs are prone to constipation. A balanced intake of fibres (including psyllium) helps facilitate intestinal transit and contributes to good stool quality thanks to highly digestible L.I.P. proteins.\r\n\r\nCOAT CONDITION\r\nThis formula contains nutrients that help support a healthy skin and coat. Enriched with EPA-DHA.\r\n\r\nURINARY TRACT HEALTH\r\nHelps support a healthy urinary system in very small breed dogs.\r\n\r\nDENTAL HEALTH\r\nHelps reduce tartar formation thanks to the chelation agents in calcium. This small-sized kibble has been developed to be perfectly adapted to the miniature jaw of dogs under 4 kg. Its exclusive formula also helps stimulate fussy appetites in very small breed dogs.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"+6 years"
                          withDogSize:@"X-Small, Mini"
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@""
                         withFoodName:@"X-Small Mature +8"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/x-small-dogs-up-to-4kg/x-small-mature-8"
                  withFoodDescription:@"Complete feed for dogs - For mature, very small breed dogs (weight up to 4 kg). Over 8 years old.\r\n\r\nVITALITY MANAGEMENT\r\nThe content of nutrients in this formula helps maintain vitality in very small breed dogs facing the first signs of ageing (cardiac and renal functions in particular). X-SMALL MATURE +8 contains a patented complex of antioxidants.\r\n\r\nHEALTHY TRANSIT\r\nVery small breed dogs are prone to constipation. A balanced intake of fibres (including psyllium) helps facilitate intestinal transit and contributes to good stool quality thanks to highly digestible L.I.P. proteins.\r\n\r\nURINARY TRACT HEALTH\r\nHelps support a healthy urinary system in very small breed dogs.\r\n\r\nDENTAL HEALTH\r\nHelps reduce tartar formation thanks to the chelation agents in calcium. This small-sized kibble has been developed to be perfectly adapted to the miniature jaw of dogs under 4 kg. Its exclusive formula also helps stimulate fussy appetites in very small breed dogs.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"+6 years"
                          withDogSize:@"X-Small, Mini"
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Longevity"
                         withFoodName:@"X-Small Ageing +12"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/x-small-dogs-up-to-4kg/x-small-ageing-12"
                  withFoodDescription:@"Complete feed for senior dogs - For very small breed dogs (weight up to 4 kg). Over 12 years old.\r\n\r\nHEALTHY AGEING MANAGEMENT\r\nFormula which supplies a selection of nutrients to support ageing in healthy dogs. Contains EPA-DHA and a patented complex of antioxidants. Renal function can decrease with age. X-SMALL AGEING +12 has been formulated with an adapted phosphorus content.\r\n\r\nHEALTHY TRANSIT\r\nVery small breed dogs are prone to constipation. A balanced intake of fibres (including psyllium) helps facilitate intestinal transit and contributes to good stool quality thanks to highly digestible L.I.P. proteins.\r\n\r\nCARDIAC HEALTH\r\nThe formula contains the nutrients necessary to help support good cardiac function in ageing dogs.\r\n\r\nDENTAL HEALTH\r\nHelps reduce tartar formation thanks to the chelation agents in calcium. Thanks to its exclusive formula, the X-SMALL AGEING +12 kibble easily rehydrates to help ageing dogs eat with appetite.\r\n"];
    
    // Mini
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Mini, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@""
                         withFoodName:@"Mini Adult"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/mini-dogs-up-to-10kg/mini-adult"
                  withFoodDescription:@"Complete feed for adult dogs - For small breed dogs (adult weight up to 10 kg) - Over 10 months old.\r\n\r\nMAINTAINS IDEAL WEIGHT\r\nHelps maintain ideal weight in small breed dogs by perfectly meeting their high energy needs and promoting fat metabolism by L-carnitine.\r\n\r\nENHANCED PALATABILITY\r\nSatisfies the fussy appetite of small breed dogs by means of its formulation and a selection of exclusive flavourings.\r\n\r\nCOAT CONDITION\r\nThis formula contains nutrients that help support a healthy skin and coat. Enriched with EPA-DHA.\r\n\r\nDENTAL HEALTH\r\nHelps reduce tartar formation thanks to the chelation agents in calcium.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"Mini, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Puppy, Pregnant or Nursing Dog, Weaning"
                         withFoodName:@"Mini Starter"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/mini-dogs-up-to-10kg/mini-starter"
                  withFoodDescription:@"Complete dog feed for the small breed bitch (from 1 to 10 kg) and her puppies: bitch at the end of gestation and during lactation - Weaning puppies up to 2 months old.\r\n\r\nInspired by Professional research, BIRTH PROGRAMME is a unique nutritional solution which meets the needs of the bitch and her puppies during the first five stages of life cycle: gestation, birth, lactation, weaning, and growth up to 2 months old.\r\n\r\nThe fruit of ongoing science from Royal Canin, START COMPLEX is an exclusive combination of nutritional elements which are present in mother’s milk, reinforced with specific nutrients which actively contribute to promoting digestive security and strengthening the puppy’s natural defences.\r\n\r\nGESTATION/LACTATION SUPPORT\r\nNutritional profile which is adapted to the bitch’s high energy needs at end of gestation and during lactation.\r\n\r\nIDEAL FOR TRANSITION FROM MILK\r\nNutritional response which facilitates the transition from mother’s milk to solid food (energy value, quality protein, fats).\r\n\r\nEASY REHYDRATION\r\nThe kibbles easily rehydrate to a porridge-like consistency which is very palatable for the bitch and her weaning puppies.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"Mini, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Puppy, "
                         withFoodName:@"Mini Junior"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/mini-dogs-up-to-10kg/mini-junior"
                  withFoodDescription:@"Complete feed for dogs - For small breed puppies (adult weight up to 10 kg) - Up to 10 months old.\r\n\r\nDIGESTIVE HEALTH\r\nAn exclusive combination of nutrients to support digestive health (L.I.P. proteins) and a balanced intestinal flora (prebiotics) which contributes to good stool quality.\r\n\r\nINTENSE ENERGY CONTENT\r\nMeets the high energy needs of small breed puppies during the growth period, and satisfies fussy appetites.\r\n\r\nDENTAL HEALTH\r\nHelps reduce tartar formation thanks to the chelation agents in calcium.\r\n\r\nNATURAL DEFENCES\r\nHelps support the puppy’s natural defences, thanks particularly to a patented antioxidant complex and prebiotics.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"+6 years"
                          withDogSize:@"Mini, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@""
                         withFoodName:@"Mini Mature +8"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/mini-dogs-up-to-10kg/mini-mature-8"
                  withFoodDescription:@"Complete feed for mature dogs - For small breed dogs (adult weight up to 10 kg).Over 8 years old.\r\n\r\nVITALITY SUPPORT\r\nThe content of nutrients in this formula helps maintain vitality in small breed dogs facing the first signs of ageing. Contains a patented complex of antioxidants.\r\n\r\nENHANCED PALATABILITY\r\nSatisfies the fussy appetite of small breed dogs by means of its formulation and a selection of exclusive flavourings.\r\n\r\nMAINTAINS IDEAL WEIGHT\r\nHelps maintain ideal weight in small breed dogs through promoting fat metabolism by L-carnitine.\r\n\r\nDENTAL HEALTH\r\nHelps reduce tartar formation thanks to the chelation agents in calcium.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"+6 years"
                          withDogSize:@"Mini, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Longevity, "
                         withFoodName:@"Mini Ageing +12"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/mini-dogs-up-to-10kg/mini-ageing-12"
                  withFoodDescription:@"Complete feed for dogs - For senior small breed dogs (adult weight up to 10 kg). Over 12 years old.\r\n\r\nHEALTHY AGEING SUPPORT\r\nFormula which supplies a selection of nutrients to support healthy ageing. Contains EPA-DHA and a patented complex of antioxidants.\r\n\r\nRENAL HEALTH\r\nHelps support a healthy renal system in ageing small breed dogs thanks to an adapted phosphorus content.\r\n\r\nCOAT CONDITION\r\nThis formula contains nutrients that help support a healthy skin and coat. Enriched with EPA-DHA.\r\n\r\nDENTAL HEALTH\r\nHelps reduce tartar formation thanks to the chelation agents in calcium.\r\n\r\nHIGH PALATABILITY & HIGH REHYDRATION\r\nThanks to its exclusive formula, the MINI AGEING +12 kibble easily rehydrates to help ageing dogs eat with appetite.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Mini, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Overweight, "
                         withFoodName:@"Mini Light"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/mini-dogs-up-to-10kg/mini-light"
                  withFoodDescription:@"Complete feed for dogs - For adult and mature small breed dogs (adult weight up to 10 kg) with a tendency to gain weight - Over 10 months old.\r\n\r\nWEIGHT MANAGEMENT\r\nHelps reduce your dog’s energy intake by 18%* while giving the same quantity of food. Helps achieve ideal weight by combining a high protein level (30%) with a low fat content (11%) and L-carnitine to aid the metabolism of fats while maintaining muscle mass. *compared to a maintenance feed.\r\n\r\nAPPETITE SATISFACTION\r\nEnriched formula with fibres which contributes to reducing the feeling of hunger between meals while satisfying the dog’s appetite.\r\n\r\nDENTAL HEALTH\r\nHelps reduce tartar formation thanks to the chelation agents in calcium.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Mini, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Hair and Skin"
                         withFoodName:@"Mini Dermacomfort"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/mini-dogs-up-to-10kg/mini-dermacomfort"
                  withFoodDescription:@"Complete feed for dogs - For adult and mature small breed dogs (adult weight up to 10 kg) - Dogs prone to skin irritation and itching - Over 10 months old.\r\n\r\nREDUCED ALLERGEN FORMULA\r\nSpecific formula with selected protein sources of very high quality. DERMACOMFORT is particularly suited to dogs prone to skin irritation and itching.\r\n\r\nHEALTHY SKIN COCKTAIL\r\n“Healthy Skin Cocktail”: a unique combination of nutrients containing a patented complex to help support the skin’s barrier role, combined with Omega 6 fatty acids (including gamma-linolenic acid) and Omega 3 fatty acids (including EPA and DHA) known for their beneficial effects on skin.\r\n\r\nDENTAL HEALTH\r\nHelps reduce tartar formation thanks to the chelation agents in calcium.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Mini, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Stomach, "
                         withFoodName:@"Mini Sensible"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/mini-dogs-up-to-10kg/mini-sensible"
                  withFoodDescription:@"Complete feed for dogs - For adult and mature small breed dogs (adult weight up to 10 kg) - Digestive sensitivity - Over 10 months old.\r\n\r\nDIGESTIVE HEALTH\r\nAn exclusive combination of nutrients to support digestive health (L.I.P. proteins) and a balanced intestinal flora (prebiotics) which contributes to good stool quality.\r\n\r\nENHANCED PALATABILITY\r\nSatisfies the fussy appetite of small breed dogs by means of its formulation and a selection of exclusive flavourings.\r\n\r\nDENTAL HEALTH\r\nHelps reduce tartar formation thanks to the chelation agents in calcium.\r\n"];
    
    
    // Medium
    
       
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Medium, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@""
                         withFoodName:@"Medium Adult"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/medium-dogs-11-25kg/medium-adult"
                  withFoodDescription:@"Complete feed for adult medium breed dogs (from 11 to 25 kg). Over 12 months.\r\n\r\nNATURAL DEFENCES\r\nHelps support the dog’s natural defences, thanks particularly to an antioxidant complex and manno-oligo-saccharides.\r\n\r\nHIGH DIGESTIBILITY\r\nHelps promote optimal digestibility thanks to an exclusive formula including very high quality proteins and a balanced supply of dietary fibre.\r\n\r\nOMEGA 3: EPA - DHA\r\nEnriched formula with Omega 3 fatty acids (EPA-DHA) to help maintain a healthy skin.\r\n\r\nHIGH PALATABILITY\r\nSatisfies the appetite of medium breed dogs thanks to carefully selected flavourings.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"Medium, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Puppy, Pregnant or Nursing Dog, Weaning"
                         withFoodName:@"Medium Starter"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/medium-dogs-11-25kg/medium-starter"
                  withFoodDescription:@"Complete dog feed for the medium breed bitch (from 11 to 25 kg) and her puppies: bitch at the end of gestation and during lactation - Weaning puppies up to 2 months old.\r\n\r\nBIRTH PROGRAMME\r\nInspired by Professional research, BIRTH PROGRAMME is a unique nutritional solution which meets the needs of the bitch and her puppies during the first five stages of life cycle: gestation, birth, lactation, weaning, and growth up to 2 months old.\r\n\r\nStarter Complex\r\nThe fruit of ongoing science from Royal Canin, START COMPLEX is an exclusive combination of nutritional elements which are present in mother’s milk, reinforced with specific nutrients which actively contribute to promoting digestive security and strengthening the puppy’s natural defences.\r\n\r\nGESTATION/LACTATION SUPPORT\r\nNutritional profile which is adapted to the bitch’s high energy needs at end of gestation and during lactation.\r\n\r\nIDEAL FOR TRANSITION FROM MILK\r\nNutritional response which facilitates the transition from mother’s milk to solid food (energy value, quality protein, fats).\r\n\r\nEASY REHYDRATION\r\nThe kibbles easily rehydrate to a porridge-like consistency which is very palatable for the bitch and her weaning puppies.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"Medium, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Puppy, "
                         withFoodName:@"Medium Junior"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/medium-dogs-11-25kg/medium-junior"
                  withFoodDescription:@"Complete dog feed for medium breed puppies (adult weight from 11 to 25 kg) - Up to 12 months old.\r\n\r\nDIGESTIVE HEALTH\r\nAn exclusive combination of nutrients to support optimal digestive security (L.I.P. proteins) and a balanced intestinal flora (prebiotics: FOS, MOS) which also contribute to good stool quality.\r\n\r\nSHORT GROWTH - HIGH ENERGY\r\nMeets the high energy needs of medium breed puppies which have a short growth period.\r\n\r\nMINERAL BALANCE (CALCIUM / PHOSPHORE)\r\nHelps ensure robust skeletal development in medium breed puppies thanks to an adapted intake of calcium and phosphorus.\r\n\r\nNATURAL DEFENCES\r\nHelps support the puppy’s natural defences, thanks particularly to an antioxidant complex and manno-oligo-saccharides.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"+6 years"
                          withDogSize:@"Medium, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@""
                         withFoodName:@"Medium Adult 7+"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/medium-dogs-11-25kg/medium-adult-7"
                  withFoodDescription:@"Complete feed for dogs - For mature medium breed dogs (from 11 to 25 kg) - Over 7 years old.\r\n\r\nVITALITY SUPPORT\r\nAdapted content of nutrients to help maintain vitality in medium breed dogs facing the first signs of ageing. Contains an exclusive complex of antioxidants to help neutralise free radicals.\r\n\r\nDIGESTIVE TOLERANCE\r\nHelps promote optimal digestibility thanks to an exclusive formula including very high quality proteins and a balanced supply of dietary fibre.\r\n\r\nCOAT CONDITION\r\nThis formula contains nutrients that help support a healthy skin and coat. Enriched with EPA-DHA.\r\n\r\nDENTAL HEALTH\r\nHelps reduce tartar formation thanks to the chelation agents in calcium.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"+6 years"
                          withDogSize:@"Medium, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Longevity, "
                         withFoodName:@"Medium Ageing 10+"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/medium-dogs-11-25kg/medium-ageing-10"
                  withFoodDescription:@"Complete feed for dogs - For senior medium breed dogs (from 11 to 25 kg) - Over 10 years old.\r\n\r\nHEALTHY AGEING SUPPORT\r\nA selection of nutrients to support healthy ageing in senior medium breed dogs.Contains EPA-DHA and an exclusive complex of antioxidants to help neutralise free radicals.\r\n\r\nBONE & JOINT SUPPORT\r\nHelps maintain healthy bones and joints in senior medium breed dogs.\r\n\r\nSKIN & COAT CONDITION\r\nContains specific nutrients for a shiny coat and a healthy skin.\r\n\r\nHEALTHY TRANSIT\r\nHelps facilitate intestinal transit thanks to an adapted fibre content and contributes to good stool quality thanks to proteins selected for their high digestibility.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Medium, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Overweight, "
                         withFoodName:@"Medium Light"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/medium-dogs-11-25kg/medium-light"
                  withFoodDescription:@"Complete feed for dogs - For adult and mature medium breed dogs (from 11 to 25 kg). Over 12 months old. Tendency to gain weight\r\n\r\nWEIGHT MANAGEMENT\r\nHelps reduce your dog’s energy intake by 30% while giving the same quantity of food. Helps achieve and maintain ideal weight by combining an increased protein content (27%) with a low fat content (11%) and L-carnitine to aid the metabolism of fats while maintaining muscle mass.\r\n\r\nAPPETITE SATISFACTION\r\nEnriched formula with fibres which contributes to reducing the feeling of hunger between meals while satisfying the dog’s appetite.\r\n\r\nANTIOXIDANT COMBINATION\r\nA synergistic combination of antioxidants to help neutralise free radicals.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Medium, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Hair and Skin"
                         withFoodName:@"Medium Dermacomfort"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/medium-dogs-11-25kg/medium-dermacomfort"
                  withFoodDescription:@"Complete dog feed for adult and mature medium breed dogs (weight between 11 and 25 kg) - Dogs prone to skin irritation and itching - Over 12 months old.\r\n\r\nREDUCED ALLERGEN FORMULA\r\nSpecific formula with selected protein sources of very high quality. MEDIUM DERMACOMFORT is particularly suited to medium breed dogs prone to skin irritation and itching.\r\n\r\nHEALTHY SKIN COCKTAIL\r\nA unique combination of nutrients containing an exclusive complex to help support the skin’s barrier role, combined with Omega 6 fatty acids (including gamma-linolenic acid) and Omega 3 fatty acids (including EPA and DHA) known for their beneficial effects on skin.\r\n\r\nANTIOXIDANT COMBINATION\r\nA synergistic combination of antioxidants to help neutralise free radicals.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@" 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Medium, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Stomach, "
                         withFoodName:@"Medium Sensible"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/medium-dogs-11-25kg/medium-sensible"
                  withFoodDescription:@"DIGESTIVE HEALTH\r\nReinforced digestive tolerance thanks to very high quality protein sources and FOS and MOS which promote a balance in the intestinal flora and improve stool quality.\r\n\r\nCOAT CONDITION\r\nHelps reinforce coat shine thanks particularly to Omega 6 fatty acids.\r\n\r\nANTIOXIDANT COMBINATION\r\nA synergistic combination of antioxidants to help neutralise free radicals.\r\n"];
    
    
    // Large
    
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@""
                         withFoodName:@"Maxi Adult"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/maxi-dogs-26-44kg/maxi-adult"
                  withFoodDescription:@"Complete feed for adult large breed dogs (from 26 to 44 kg). Over 15 months.\r\n\r\nHIGH DIGESTIBILITY\r\nHelps promote optimal digestibility thanks to an exclusive formula including very high quality proteins and a balanced supply of dietary fibre.\r\n\r\nBONE & JOINT SUPPORT\r\nHelps support large breed dogs’ bones and joints placed under stress.\r\n\r\nHIGH PALATABILITY\r\nSatisfies the appetite of large breed dogs thanks to carefully selected flavourings.\r\n\r\nOMEGA 3: EPA - DHA\r\nEnriched formula with Omega 3 fatty acids (EPA-DHA) to help maintain a healthy skin.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"Large, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Puppy, Pregnant or Nursing Dog, Weaning"
                         withFoodName:@"Maxi Starter"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/maxi-dogs-26-44kg/maxi-starter"
                  withFoodDescription:@"Complete dog feed for the large breed bitch (from 26 to 44 kg) and her puppies: bitch at the end of gestation and during lactation - Weaning puppies up to 2 months old.\r\n\r\nBIRTH PROGRAMME\r\nInspired by Professional research, BIRTH PROGRAMME is a unique nutritional solution which meets the needs of the bitch and her puppies during the first five stages of life cycle: gestation, birth, lactation, weaning, and growth up to 2 months old.The fruit of ongoing science from Royal Canin, START COMPLEX is an exclusive combination of nutritional elements which are present in mother’s milk, reinforced with specific nutrients which actively contribute to promoting digestive security and strengthening the puppy’s natural defences.\r\n\r\nGESTATION/LACTATION SUPPORT\r\nNutritional profile which is adapted to the bitch’s high energy needs at end of gestation and during lactation.\r\n\r\nIDEAL FOR TRANSITION FROM MILK\r\nNutritional response which facilitates the transition from mother’s milk to solid food (energy value, quality protein, fats).\r\n\r\nEASY REHYDRATION\r\nThe kibbles easily rehydrate to a porridge-like consistency which is very palatable for the bitch and her weaning puppies.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months"
                          withDogSize:@"Large, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Puppy, "
                         withFoodName:@"Maxi Junior"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/maxi-dogs-26-44kg/maxi-junior"
                  withFoodDescription:@"Complete dog feed for large breed puppies (adult weight from 26 to 44 kg) - Up to 15 months old.\r\n\r\nDIGESTIVE HEALTH\r\nAn exclusive combination of nutrients to support optimal digestive security (L.I.P. proteins) and a balanced intestinal flora (prebiotics: FOS, MOS) which also contribute to good stool quality.\r\n\r\nLONG GROWTH - MODERATE ENERGY\r\nMeets the moderate energy needs of large breed puppies which have a long growth period.\r\n\r\nBONE AND JOINT SUPPORT\r\nContributes to good bone mineralisation in large breed puppies thanks to a balanced intake of energy and minerals (calcium and phosphorus), thus supporting bone consolidation and joints.\r\n\r\nNATURAL DEFENCES\r\nHelps support the puppy’s natural defences, thanks particularly to an antioxidant complex and manno-oligo-saccharides.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years,"
                          withDogSize:@"Large, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@""
                         withFoodName:@"Maxi Adult 5+"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/maxi-dogs-26-44kg/maxi-adult-5"
                  withFoodDescription:@"Complete feed for adult dogs. For large breed dogs (from 26 to 44 kg) over 5 years old.\r\n\r\nVITALITY SUPPORT\r\nAdapted content of nutrients to help maintain vitality in large breed dogs facing the first signs of ageing. Contains an exclusive complex of antioxidants to help neutralise free radicals.\r\n\r\nBONE & JOINT SUPPORT\r\nHelps support large breed dogs’ bones and joints placed under stress.\r\n\r\nDIGESTIVE TOLERANCE\r\nHelps promote optimal digestibility thanks to an exclusive formula including very high quality proteins and a balanced supply of dietary fibre.\r\n\r\nDENTAL HEALTH\r\nHelps reduce tartar formation thanks to the chelation agents in calcium.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"+6 years"
                          withDogSize:@"Large, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Longevity, "
                         withFoodName:@"Maxi Ageing 8+"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/maxi-dogs-26-44kg/maxi-ageing-8"
                  withFoodDescription:@"Complete feed for dogs - For senior large breed dogs (from 26 to 44 kg) - Over 8 years old.\r\n\r\nHEALTHY AGEING SUPPORT\r\nA selection of nutrients to support healthy ageing in senior medium breed dogs.Contains EPA-DHA and an exclusive complex of antioxidants to help neutralise free radicals.\r\n\r\nBONE & JOINT SUPPORT\r\nHelps support large breed dogs’ bones and joints placed under stress\r\n\r\nHEALTHY TRANSIT\r\nHelps facilitate intestinal transit thanks to an adapted fibre content and contributes to good stool quality thanks to proteins selected for their high digestibility.\r\n\r\nSKIN & COAT CONDITION\r\nContains specific nutrients for a shiny coat and a healthy skin.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Overweight, "
                         withFoodName:@"Maxi Light"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/maxi-dogs-26-44kg/maxi-light"
                  withFoodDescription:@"Complete feed for dogs - For adult and mature large breed dogs (from 26 to 44 kg). Over 15 months old. Tendency to gain weight.\r\n\r\nWEIGHT MANAGEMENT\r\nHelps reduce your dog’s energy intake by 30% while giving the same quantity of food. Helps achieve and maintain ideal weight by combining an increased protein content (27%) with a low fat content (11%) and L-carnitine to aid the metabolism of fats while maintaining muscle mass.\r\n\r\nAPPETITE SATISFACTION\r\nEnriched formula with fibres which contributes to reducing the feeling of hunger between meals while satisfying the dog’s appetite.\r\n\r\nBONE & JOINT SUPPORT\r\nHelps support bones and joints placed under stress in the case of excess weight.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Hair and Skin"
                         withFoodName:@"Maxi Dermacomfort"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/maxi-dogs-26-44kg/maxi-dermacomfort"
                  withFoodDescription:@"Complete dog feed for adult and mature large breed dogs (weight between 26 and 44 kg) - Dogs prone to skin irritation and itching - Over 15 months old.\r\n\r\nREDUCED ALLERGEN FORMULA\r\nSpecific formula with selected protein sources of very high quality. MAXI DERMACOMFORT is particularly suited to large breed dogs prone to skin irritation and itching.\r\n\r\nHEALTHY SKIN COCKTAIL\r\nA unique combination of nutrients containing an exclusive complex to help support the skin’s barrier role, combined with Omega 6 fatty acids (including gamma-linolenic acid) and Omega 3 fatty acids (including EPA and DHA) known for their beneficial effects on skin.\r\n\r\nHIGH PALATABILITY\r\nSatisfies the appetite of large breed dogs thanks to carefully selected flavourings.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Stomach, "
                         withFoodName:@"Maxi Sensible"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/maxi-dogs-26-44kg/maxi-sensible"
                  withFoodDescription:@"Complete feed for dogs - For adult and mature large breed dogs (from 26 to 44 kg). Over 15 months old. Digestive sensitivity.\r\n\r\nDIGESTIVE HEALTH\r\nReinforced digestive tolerance thanks to very high quality protein sources and MOS which promote a balance in the intestinal flora and improve stool quality.\r\n\r\nCOAT CONDITION\r\n\r\nHelps reinforce coat shine thanks particularly to Omega 6 fatty acids.\r\nBONE & JOINT SUPPORT\r\n\r\nHelps support large breed dogs’ bones and joints placed under stress.\r\n"];
    
    

     [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months"
                           withDogSize:@"Large, "
                         withFoodBrand:@"Royal Canin Size Health Nutrition"
                         withSelectOne:@"Puppy, Vitality, "
                          withFoodName:@"Maxi Junior Active"
                             withImage:@"royalCaninSizeHealthNutrition.jpg"
                           withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/maxi-dogs-26-44kg/maxi-junior-active"
                   withFoodDescription:@"Complete dog feed for large breed puppies with high energy needs (adult weight from 26 to 44 kg)Up to 15 months old.\r\n\r\nCONCENTRATED ENERGY\r\nA reinforced energy content to help maintain ideal weight and promote the harmonious growth of large breed puppies with high energy needs.\r\n\r\nDIGESTIVE HEALTH\r\nAn exclusive combination of nutrients to support optimal digestive security (L.I.P. proteins) and a balanced intestinal flora (prebiotics: FOS, MOS) which also contribute to good stool quality.\r\n\r\nBONE AND JOINT SUPPORT\r\nContributes to good bone mineralisation in large breed puppies thanks to a balanced intake of energy and minerals (calcium and phosphorus), thus supporting bone consolidation and joints.\r\n\r\nNATURAL DEFENCES\r\nHelps support the puppy’s natural defences, thanks particularly to an antioxidant complex and manno-oligo-saccharides.\r\n"];
      


    
      
      [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                            withDogSize:@"Large, "
                          withFoodBrand:@"Royal Canin Size Health Nutrition"
                          withSelectOne:@""
                           withFoodName:@"Maxi Adult Body Condition"
                              withImage:@"royalCaninSizeHealthNutrition.jpg"
                            withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/maxi-dogs-26-44kg/maxi-adult-body-conditiont"
                    withFoodDescription:@"Complete feed for dogs - For adult large breed dogs (from 26 to 44 kg) - Over 15 months old.\r\n\r\nMUSCLE MASS CONDITION\r\nAn increased protein (33%) and L-carnitine content contributes to maintaining muscle mass if your dog receives regular activity.\r\n\r\nBONE & JOINT SUPPORT\r\nHelps support large breed dogs’ bones and joints placed under stress.\r\n\r\nCOAT CONDITION\r\nThis formula contains nutrients that help support a healthy skin and coat. Enriched with EPA-DHA.\r\n\r\nDIGESTIVE TOLERANCE\r\nHelps promote optimal digestibility thanks to an exclusive formula including very high quality proteins and a balanced supply of dietary fibre.\r\n"];
       
       
 
    // Giant
    
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@""
                         withFoodName:@"Giant Adult"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/giant-dogs-45kg/giant-adult"
                  withFoodDescription:@"Complete feed for adult giant breed dogs (> 45 kg). Over 18/24 months old.\r\n\r\nBONE & JOINT SUPPORT\r\nHelps support giant breed dogs’ bones and joints placed under stress.\r\n\r\nANTIOXIDANT COMPLEX\r\nContains an exclusive complex of antioxidants to help neutralise free radicals.\r\n\r\nCARDIAC HEALTH\r\nHelps maintain a healthy heart thanks to an adapted taurine content.\r\n\r\nHIGH DIGESTIBILITY\r\nHelps promote optimal digestibility thanks to an exclusive formula including very high quality proteins and a balanced supply of dietary fibre.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"Large, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Puppy, Pregnant or Nursing Dog, Weaning"
                         withFoodName:@"Giant Starter"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/giant-dogs-45kg/giant-starter"
                  withFoodDescription:@"Complete dog feed for the giant breed bitch (> 45 kg) and her puppies: bitch at the end of gestation and during lactation - Weaning puppies up to 2 months old.\r\n\r\nBIRTH PROGRAMME\r\nInspired by Professional research, BIRTH PROGRAMME is a unique nutritional solution which meets the needs of the bitch and her puppies during the first five stages of life cycle: gestation, birth, lactation, weaning, and growth up to 2 months old.\r\nThe fruit of ongoing science from Royal Canin, START COMPLEX is an exclusive combination of nutritional elements which are present in mother’s milk, reinforced with specific nutrients which actively contribute to promoting digestive security and strengthening the puppy’s natural defences.\r\n\r\nGESTATION/LACTATION SUPPORT\r\nNutritional profile which is adapted to the bitch’s high energy needs at end of gestation and during lactation.\r\n\r\nIDEAL FOR TRANSITION FROM MILK\r\nNutritional response which facilitates the transition from mother’s milk to solid food (energy value, quality protein, fats).\r\n\r\nEASY REHYDRATION\r\nThe kibbles easily rehydrate to a porridge-like consistency which is very palatable for the bitch and her weaning puppies.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months"
                          withDogSize:@"Large, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Puppy, "
                         withFoodName:@"Giant Junior"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/giant-dogs-45kg/giant-junior"
                  withFoodDescription:@"Complete dog feed for giant breed puppies (adult weight > 45 kg) - From 8 to 18/24 months old.\r\n\r\nDIGESTIVE HEALTH\r\nAn exclusive combination of nutrients to support optimal digestive security (L.I.P. proteins) and a balanced intestinal flora (prebiotics: FOS, MOS) which also contribute to good stool quality.\r\n\r\n2ND GROWTH PHASE: MUSCLE DEVELOPMENT\r\nAn adapted protein and L-carnitine content to help support muscle development in giant breed puppies during the second growth phase from 8 months old.\r\n\r\nBONE AND JOINT SUPPORT\r\nContributes to good bone mineralisation in giant breed puppies thanks to a balanced intake of energy and minerals (calcium and phosphorus), thus supporting bone consolidation and joints.\r\n\r\nNATURAL DEFENCES\r\nHelps support the puppy’s natural defences, thanks particularly to an antioxidant complex and manno-oligo-saccharides.\r\n"];
    
         
        
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Stomach, "
                         withFoodName:@"Giant Sensible"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/giant-dogs-45kg/giant-sensible"
                  withFoodDescription:@"Complete feed for dogs.For adult giant breed dogs (> 45 kg) - Over 18/24 months old - Digestive sensitivity.\r\n\r\nDIGESTIVE HEALTH\r\nReinforced digestive tolerance thanks to very high quality protein sources and psyllium which improve stool quality\r\n\r\nCOAT CONDITION\r\nThis formula contains nutrients that help support a healthy skin and coat.Enriched with EPA-DHA.\r\n\r\nBONE & JOINT SUPPORT\r\nHelps support giant breed dogs’ bones and joints placed under stress.\r\n\r\nANTIOXIDANT COMPLEX\r\nContains an exclusive complex of antioxidants to help neutralise free radicals.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months"
                          withDogSize:@"Large, "
                        withFoodBrand:@"Royal Canin Size Health Nutrition"
                        withSelectOne:@"Puppy, Vitality, "
                         withFoodName:@"Giant Junior Active"
                            withImage:@"royalCaninSizeHealthNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/giant-dogs-45kg/giant-junior-active"
                  withFoodDescription:@"Complete dog feed for giant breed puppies with high energy needs (adult weight > 45 kg). From 8 to 18/24 months old.\r\n\r\nCONCENTRATED ENERGY\r\nA reinforced energy content to help maintain ideal weight and promote the harmonious growth of large breed puppies with high energy needs.\r\n\r\nDIGESTIVE HEALTH\r\nAn exclusive combination of nutrients to support optimal digestive security (L.I.P. proteins) and a balanced intestinal flora (prebiotics: FOS, MOS) which also contribute to good stool quality.\r\n\r\n2ND GROWTH PHASE: MUSCLE DEVELOPMENT\r\nAn adapted protein and L-carnitine content to help support muscle development in giant breed puppies during the second growth phase from 8 months old.\r\n\r\nNATURAL DEFENCES\r\nHelps support the puppy’s natural defences, thanks particularly to an antioxidant complex and manno-oligo-saccharides.\r\n"];
    
    
    
    
     [self insertFoodProductWithDogAge:@"0-12 months"
                           withDogSize:@"Large, "
                         withFoodBrand:@"Royal Canin Size Health Nutrition"
                         withSelectOne:@"Puppy, "
                          withFoodName:@"Giant Puppy"
                             withImage:@"royalCaninSizeHealthNutrition.jpg"
                           withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/giant-dogs-45kg/giant-puppy"
                   withFoodDescription:@"Complete dog feed for giant breed puppies (adult weight > 45 kg) - Up to 8 months old.\r\n\r\nDIGESTIVE HEALTH\r\nAn exclusive combination of nutrients to support optimal digestive security (L.I.P. proteins) and a balanced intestinal flora (prebiotics: FOS, MOS) which also contribute to good stool quality.\r\n\r\nINTENSE GROWTH - CONTROLLED ENERGY\r\nHelps support high growth rate during the first growth phase in giant breed puppies and avoid excess weight gain thanks to an adapted energy content.\r\n\r\nBONE AND JOINT SUPPORT\r\nContributes to good bone mineralisation in large breed puppies thanks to a balanced intake of energy and minerals (calcium and phosphorus), thus supporting bone consolidation and joints.\r\n\r\nNATURAL DEFENCES\r\nHelps support the puppy’s natural defences, thanks particularly to an antioxidant complex and manno-oligo-saccharides.\r\n"];
      

      
      
      [self insertFoodProductWithDogAge:@"0-12 months"
                            withDogSize:@"Large, "
                          withFoodBrand:@"Royal Canin Size Health Nutrition"
                          withSelectOne:@"Puppy, Vitality, "
                           withFoodName:@"Giant Puppy Active"
                              withImage:@"royalCaninSizeHealthNutrition.jpg"
                            withWebPage:@"http://www.royalcanin.co.uk/products/products/dog-products/size-health-nutrition/giant-dogs-45kg/giant-puppy-active"
                    withFoodDescription:@"Complete dog feed for giant breed puppies with high energy needs (adult weight > 45 kg).Up to 8 months old\r\n\r\nCONCENTRATED ENERGY\r\nA reinforced energy content to help maintain ideal weight and promote the harmonious growth of giant breed puppies with high energy needs.\r\n\r\nDIGESTIVE HEALTH\r\nAn exclusive combination of nutrients to support optimal digestive security (L.I.P. proteins) and a balanced intestinal flora (prebiotics: FOS, MOS) which also contribute to good stool quality.\r\n\r\nBONE AND JOINT SUPPORT\r\nContributes to good bone mineralisation in giant breed puppies thanks to a balanced intake of energy and minerals (calcium and phosphorus), thus supporting bone consolidation and joints.\r\n\r\nNATURAL DEFENCES\r\nHelps support the puppy’s natural defences, thanks particularly to an antioxidant complex and manno-oligo-saccharides.\r\n"];
       
    
    
    
    #pragma mark - Royal Canin Vet Care Nutrition
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Medium"
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Neutered, Sterilised, Ideal Weight, Hair and Skin, "
                         withFoodName:@"Neutered Adult Medium Dog"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/neutered-adult-medium-dog"
                  withFoodDescription:@"Complete feed for adult - For neutered, medium breed dogs (from 11 to 25 kg) with a tendency to gain weight and skin sensitivity - Over 12 months old.\r\n\r\nIDEAL BODY WEIGHT\r\nHelps maintain ideal weight thanks to a low-calorie formula promoting a feeling of fullness.\r\n\r\nSKIN & COAT\r\nNutrients which support hair growth and coat shine.\r\n\r\nDIGESTIVE TOLERANCE\r\nNutrients which support a balanced intestinal flora and digestive transit.\r\n\r\nANTIOXIDANT COMPLEX\r\nA patented synergistic complex of antioxidants to help neutralise free radicals.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"+6 years, "
                          withDogSize:@"X-Small, Mini"
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Longevity, Vitality, Oral Care, "
                         withFoodName:@"Senior Consult Mature Small Dog"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/senior-consult-mature-small-dog-new"
                  withFoodDescription:@"Complete feed for dogs - For mature dogs (under 10 kg) - Over 8 years old.\r\n\r\nVITALITY & BRAIN HEALTH\r\nSelection of nutrients that help support vital function in ageing dogs.\r\n\r\nTARTAR CONTROL\r\nNutrient that traps the calcium in saliva so reducing tartar deposits.\r\n\r\nMUSCLE MASS SUPPORT\r\nA specific balanced formulation to help preserve muscle mass with age.\r\n\r\nSKIN BARRIER\r\nA patented complex to support the barrier effect of the skin.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"+6 years, "
                          withDogSize:@"Medium"
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Longevity, Hair and Skin, Vitality, "
                         withFoodName:@"Senior Consult Mature Dog"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/senior-consult-mature-dog-new"
                  withFoodDescription:@"Complete feed for mature dogs - For medium breed dogs (from 11 to 25 kg) - Over 7 years old. Lifetime feeding.\r\n\r\nVITALITY & BRAIN HEALTH\r\nSelection of nutrients that help support vital function in ageing dogs.\r\n\r\nSKIN BARRIER\r\nA patented complex to support the barrier effect of the skin.\r\n\r\nMUSCLE MASS SUPPORT\r\nA specific balanced formulation to help preserve muscle mass with age.\r\n\r\nDIGESTIVE TOLERANCE\r\nNutrients which support a balanced intestinal flora and digestive transit.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Giant"
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Stomach, Bones and Joints"
                         withFoodName:@"Adult Giant Dog"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/adult-giant-dog"
                  withFoodDescription:@"Complete feed for dogs - For adult dogs (over 45 kg) with digestive or joint sensitivity - Over 18/24 months old.\r\n\r\nIndications: Joint sensitivity & Digestive sensitivity.\r\n\r\nBONE & JOINT SUPPORT\r\nHelps maintain healthy bones and joints.\r\n\r\nDIGESTIVE TOLERANCE\r\nNutrients which support a balanced intestinal flora and digestive transit.\r\n\r\nHIGH ENERGY\r\nHigh energy density to meet the needs of giant breed dogs without overloading their stomach.\r\n\r\nANTIOXIDANT COMPLEX\r\nA synergistic complex of antioxidants to help promote health with age.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Pregnant or Nursing Dog, Puppy, "
                         withFoodName:@"Pediatric Starter Wet"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/pediatric-starter-wet"
                  withFoodDescription:@"Complete dog feed for the bitch (gestation and lactation) and her puppies (from weaning up to 2 months old).\r\n\r\nBIRTH PROGRAMME\r\nOptimal nutritional and energy profile for weaning puppies and nursing/gestating female dogs.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n\r\nNATURAL DEFENCES SUPPORT\r\nA synergistic complex of antioxidants to help support natural defences.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, "
                          withDogSize:@"Giant"
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Puppy, Bones and Joints, Stomach, "
                         withFoodName:@"Pediatric Junior Giant Dog"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/pediatric-junior-giant-dog-new"
                  withFoodDescription:@"Complete dog feed - For giant breed puppies (adult weight > 45 kg) with joint or digestive sensitivity - From 8 to 18/24 months old.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n\r\nBONE & JOINT SUPPORT\r\nNutrients which contribute to healthy bones and joints.\r\n\r\nHIGH PROTEIN\r\nHelps support muscle development.\r\n\r\nNATURAL DEFENCES SUPPORT\r\nA synergistic complex of antioxidants to help support natural defences.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"X-Small, Mini, "
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Pregnant or Nursing Dog, Puppy, Weaning"
                         withFoodName:@"Pediatric Starter Small Dog"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/pediatric-starter-small-dog-new"
                  withFoodDescription:@"Complete feed for dogs - For the bitch (under 10 kg) and her puppies: bitch at the end of gestation and during lactation - Weaning puppies up to 2 months old.\r\n\r\nIndications: Lactation & Gestation.\r\n\r\nBIRTH PROGRAMME\r\nOptimal nutritional and energy profile for weaning puppies and nursing/gestating female dogs.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n\r\nNATURAL DEFENCES SUPPORT\r\nA synergistic complex of antioxidants to help support natural defences.\r\n\r\nEASY REHYDRATION\r\nKibbles which are easy to soak to facilitate the transition from milk to dry food.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"Medium"
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Pregnant or Nursing Dog, Puppy, Weaning"
                         withFoodName:@"Pediatric Starter Medium Dog"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/pediatric-starter-dog-new"
                  withFoodDescription:@"Complete feed for dogs - For the medium breed bitch (from 11 to 25 kg) and her puppies: bitch at the end of gestation and during lactation - Weaning puppies up to 2 months old.\r\n\r\nIndications: Gestation, Lactation, Lactation period & Lactating bitches\r\n\r\nBIRTH PROGRAMME\r\nOptimal nutritional and energy profile for weaning puppies and nursing/gestating female dogs.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n\r\nNATURAL DEFENCES SUPPORT\r\nA synergistic complex of antioxidants to help support natural defences.\r\n\r\nEASY REHYDRATION\r\nKibbles which are easy to soak to facilitate the transition from milk to dry food.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"Large, Giant"
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Pregnant or Nursing Dog, Puppy, Weaning"
                         withFoodName:@"Pediatric Starter Large Dog"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/pediatric-starter-large-dog-new"
                  withFoodDescription:@"Complete feed for dogs - For the bitch (over 25 kg) and her puppies: bitch at the end of gestation and during lactation - Weaning puppies up to 2 months old.\r\n\r\nIndications: Gestation & Lactation\r\n\r\nBIRTH PROGRAMME\r\nOptimal nutritional and energy profile for weaning puppies and nursing/gestating female dogs.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n\r\nNATURAL DEFENCES SUPPORT\r\nA synergistic complex of antioxidants to help support natural defences.\r\n\r\nEASY REHYDRATION\r\nKibbles which are easy to soak to facilitate the transition from milk to dry food.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"Giant"
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Pregnant or Nursing Dog, Puppy, Weaning"
                         withFoodName:@"Pediatric Starter Giant Dog"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/pediatric-starter-giant-dog-new"
                  withFoodDescription:@"Complete feed for dogs - For the bitch (over 45 kg) and her puppies: bitch at the end of gestation and during lactation - Weaning puppies up to 2 months old.\r\n\r\nIndications: Gestation & Lactation.\r\n\r\nBIRTH PROGRAMME\r\nOptimal nutritional and energy profile for weaning puppies and nursing/gestating female dogs.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n\r\nNATURAL DEFENCES SUPPORT\r\nA synergistic complex of antioxidants to help support natural defences.\r\n\r\nEASY REHYDRATION\r\nKibbles which are easy to soak to facilitate the transition from milk to dry food.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"Giant"
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Puppy, Stomach, Bones and Joints"
                         withFoodName:@"Pediatric Puppy Giant Dog"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/pediatric-puppy-giant-dog-new"
                  withFoodDescription:@"Complete feed for dogs - For giant breed puppies (adult weight > 45 kg) - From 2 to 8 months old.\r\n\r\n Indications: Joint sensitivity & Digestive sensitivity.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n\r\nBONE AND JOINT SUPPORT\r\nNutrients which contribute to healthy bones and joints.\r\n\r\nOPTIMAL ENERGY\r\nAdequate energy content to meet the needs of a giant breed puppy.\r\n\r\nNATURAL DEFENCES SUPPORT\r\nA synergistic complex of antioxidants to help support natural defences.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, "
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Neutered, Sterilised, Ideal Weight, Oral Care, Urinary"
                         withFoodName:@"Neutered Adult Small Dog"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/neutered-adult-small-dog"
                  withFoodDescription:@"Complete feed for dogs - For neutered adult dogs/bitches (under 10 kg) with a tendency to gain weight and oral sensitivity.\r\n\r\nIndications: Risk of excess weight gain, Oral sensitivity & Risk of oxalate and struvite uroliths.\r\n\r\nIDEAL BODY WEIGHT\r\nHelps maintain ideal weight thanks to a low-calorie formula promoting a feeling of fullness.\r\n\r\nTARTAR CONTROL\r\nNutrient that traps the calcium in saliva so reducing tartar deposits.\r\n\r\nDIGESTIVE TOLERANCE\r\nNutrients which support a balanced intestinal flora and digestive transit.\r\n\r\nANTIOXIDANT COMPLEX\r\nA synergistic complex of antioxidants to help promote health with age.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"Medium, "
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Neutered, Sterilised, Ideal Weight, Hair and Skin"
                         withFoodName:@"Neutered Junior Medium"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/neutered-junior-medium"
                  withFoodDescription:@"Complete feed for dogs - For neutered medium breed puppies (adult weight from 11 to 25 kg) with a tendency to gain weight and skin sensitivity - From neutering up to 12 months old.\r\n\r\nIndications: Risk of excess weight gain & Skin sensitivity.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which protect and support a balanced digestive system.\r\n\r\nOPTIMAL GROWTH\r\nHelps promote optimal growth and avoid excess weight gain.\r\n\r\nSKIN & COAT\r\nNutrients which support hair growth and coat shine.\r\n\r\nNATURAL DEFENCES SUPPORT\r\nA synergistic complex of antioxidants to help support natural defences.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 month"
                          withDogSize:@"Large, Giant"
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Neutered, Sterilised, Ideal Weight, Bones and Joints"
                         withFoodName:@"Neutered Junior Large Dog"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/neutered-junior-large-dog"
                  withFoodDescription:@"Complete feed for dogs - For neutered large breed puppies (adult weight over 25 kg) with a tendency to gain weight and joint sensitivity - From neutering up to 15 months old.\r\n\r\nIndications: Risk of excess weight gain & Joint sensitivity.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n\r\nOPTIMAL GROWTH\r\nHelps promote optimal growth and avoid excess weight gain.\r\n\r\nBONE AND JOINT SUPPORT\r\nHelps maintain healthy bones and joints.\r\n\r\nNATURAL DEFENCES SUPPORT\r\nA synergistic complex of antioxidants to help support natural defences.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, Giant"
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Neutered, Sterilised, Ideal Weight, Bones and Joints"
                         withFoodName:@"Neutered Adult Large Dog"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/neutered-adult-large-dog"
                  withFoodDescription:@"Complete feed - For neutered, adult dogs (over 25 kg) with a tendency to gain weight and joint sensitivity - Over 15 months old.\r\n\r\nIndications: Risk of excess weight gain & Joint sensitivity.\r\n\r\nIDEAL BODY WEIGHT\r\nHelps maintain ideal weight thanks to a low-calorie formula promoting a feeling of fullness.\r\n\r\nBONE & JOINT SUPPORT\r\nNutrients which contribute to healthy bones and joints.\r\n\r\nDIGESTIVE TOLERANCE\r\nNutrients which support a balanced intestinal flora and digestive transit.\r\n\r\nANTIOXIDANT COMPLEX\r\nA patented synergistic complex of antioxidants to help neutralise free radicals.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini"
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Stomach, Oral Care"
                         withFoodName:@"Adult Small Dog"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/adult-small-dog"
                  withFoodDescription:@"Complete feed for dogs - For adult dogs (under 10 kg) with oral or digestive sensitivity - Over 10 months old.\r\n\r\n Indications: Oral sensitivity & Digestive sensitivity.\r\n\r\nTARTAR CONTROL\r\nNutrient that traps the calcium in saliva so reducing tartar deposits.\r\n\r\nDIGESTIVE TOLERANCE\r\nNutrients which support a balanced intestinal flora and digestive transit.\r\n\r\nSKIN BARRIER\r\nA patented complex to support the barrier effect of the skin.\r\n\r\nANTIOXIDANT COMPLEX\r\nA synergistic complex of antioxidants to help promote health with age.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Medium"
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Stomach, Hair and Skin"
                         withFoodName:@"Adult Medium Dog"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/adult-medium-dog"
                  withFoodDescription:@"Complete feed for dogs - For adult medium breed dogs (from 11 to 25 kg) with skin or digestive sensitivity - Over 12 months old.\r\n\r\nIndications: Digestive sensitivity & Skin sensitivity.\r\n\r\nSKIN & COAT\r\nNutrients which support hair growth and coat shine.\r\n\r\nDIGESTIVE TOLERANCE\r\nNutrients which support a balanced intestinal flora and digestive transit.\r\n\r\nENHANCED FLAVOUR\r\nEnhanced palatability to satisfy fussy appetites.\r\n\r\nANTIOXIDANT COMPLEX\r\nA synergistic complex of antioxidants to help promote health with age.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, Giant"
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Stomach, Bones and Joints, "
                         withFoodName:@"Adult Large Dog"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/adult-large-dog"
                  withFoodDescription:@"Complete feed for dogs - For adult dogs (over 25 kg) with joint or digestive sensitivity - Over 15 months old.\r\n\r\nIndications: Joint sensitivity & Digestive sensitivity.\r\n\r\nBONE & JOINT SUPPORT\r\nHelps maintain healthy bones and joints.\r\n\r\nDIGESTIVE TOLERANCE\r\nNutrients which support a balanced intestinal flora and digestive transit.\r\n\r\nINTENSE HAIR COLOUR\r\nA patented complex of ingredients to help enhance the coat’s natural colour.\r\n\r\nANTIOXIDANT COMPLEX\r\nA synergistic complex of antioxidants to help promote health with age.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"+6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Vitality, Longevity"
                         withFoodName:@"Senior Consult Mature Dog Wet"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/senior-consult-mature-dog-wet"
                  withFoodDescription:@"Complete feed - For mature dogs - Over 7 years old.\r\n\r\nVITALITY & BRAIN HEALTH\r\nSelection of nutrients that help support vital function in ageing dogs.\r\n\r\nMUSCLE MASS SUPPORT\r\nA specific balanced formulation to help preserve muscle mass with age.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"X-Small, Mini"
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Stomach, Oral Care, Puppy, "
                         withFoodName:@"Pediatric Junior Small Dog"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/pediatric-junior-small-dog-new"
                  withFoodDescription:@"Complete feed for dogs - For small breed puppies (adult weight under 10 kg) with oral and digestive sensitivity - Up to 10 months old.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n\r\nTARTAR CONTROL\r\nNutrient that traps the calcium in saliva so reducing tartar deposits.\r\n\r\nSKIN BARRIER\r\nA patented complex to support the barrier effect of the skin.\r\n\r\nNATURAL DEFENCES SUPPORT\r\nA synergistic complex of antioxidants to help support natural defences.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"2-6 years, +6 years"
                          withDogSize:@"Large, Giant, "
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Vitality, Bones and Joints"
                         withFoodName:@"Senior Consult Mature Large Dog"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/senior-consult-mature-large-dog-new"
                  withFoodDescription:@"Complete feed for dogs - For mature dogs (over 25 kg) - Over 5 years old.\r\n\r\nLifetime feeding\r\n\r\nVITALITY & BRAIN HEALTH\r\nSelection of nutrients that help support vital function in ageing dogs.\r\n\r\nBONE AND JOINT SUPPORT\r\nNutrients which contribute to healthy bones and joints.\r\n\r\nMUSCLE MASS SUPPORT\r\nA specific balanced formulation to help preserve muscle mass with age.\r\n\r\nDIGESTIVE TOLERANCE\r\nNutrients which support a balanced intestinal flora and digestive transit.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, "
                          withDogSize:@"Large, Giant, "
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Stomach, Bones and Joints, Puppy"
                         withFoodName:@"Pediatric Junior Large Dog"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/pediatric-junior-large-dog-new"
                  withFoodDescription:@"Complete feed for dogs - For large breed puppies (adult weight over 25 kg) with digestive and joint sensitivity - Up to 15 months old.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n\r\nBONE AND JOINT SUPPORT\r\nHelps maintain healthy bones and joints.\r\n\r\nINTENSE HAIR COLOUR\r\nA patented complex of ingredients to help enhance the coat’s natural colour.\r\n\r\nNATURAL DEFENCES SUPPORT\r\nA synergistic complex of antioxidants to help support natural defences.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"Medium"
                        withFoodBrand:@"Royal Canin Vet Care Nutrition"
                        withSelectOne:@"Stomach, Hair and Skin, "
                         withFoodName:@"Pediatric Junior Medium Dog"
                            withImage:@"royalCaninVetCareNutrition.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-vet-care-nutrition/pediatric-junior-dog-new"
                  withFoodDescription:@"Complete feed for dogs - For medium breed puppies (adult weight from 11 to 25 kg) with digestive and skin sensitivity - Up to 12 months old.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which protect and support a balanced digestive system.\r\n\r\nSKIN & COAT\r\nNutrients which support hair growth and coat shine.\r\n\r\nENHANCED FLAVOUR\r\nEnhanced palatability to satisfy fussy appetites.\r\n\r\nNATURAL DEFENCES SUPPORT\r\nA synergistic complex of antioxidants to help support natural defences.\r\n"];
    
    
    
    
    #pragma mark - Royal Canin Veterinary Diets
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Convalescent, "
                         withFoodName:@"Convalescence Support"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/convalescence-support"
                  withFoodDescription:@"CONVALESCENCE SUPPORT is a complete dietetic feed for dogs, formulated to promote nutritional restoration during convalescence. This feed has a high energy density and a high concentration of essential nutrients which are highly digestible.\r\n\r\nRecommendations: Feed until restoration is achieved.\r\n\r\nHIGH PROTEIN\r\nAn increased protein level promotes lean body mass regain while enhancing palatability during the postoperative period.\r\n\r\nANTI OXIDATIVE STRESS\r\nThe synergistic antioxidant complex (Vit E, Vit C, taurine, lutein) reduces cell stresses caused by oxidative stress.\r\n\r\nEPA/DHA\r\nEicosapentaenoic and docosahexaenoic acids, omega-3 long chain fatty acids has a beneficial effect on joint mobility, skin health and digestion.\r\n\r\nHIGH ENERGY\r\nThe high energy density allows covering the dog's energy requirements while helping reduce the amount of food given per meal, thus decreasing the digestive workload. It also helps promote weight regain during a convalescence period.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Overweight, Diabetes, Gastrointestinal, "
                         withFoodName:@"Satiety Support Dry"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/satiety-support-dry"
                  withFoodDescription:@"SATIETY SUPPORT WEIGHT MANAGEMENT is a complete dietetic feed for dogs formulated to reduce excessive body weight. This feed has a low energy density.\r\n\r\nIndications: Diabetes mellitus, Constipation, Fibre responsive colitis, Hyperlipidaemia & Overweight.\r\n\r\nContraindications: Pregnancy, Lactation & Growth.\r\n\r\nRecommendations: It is recommended that a veterinarian’s opinion be sought before use or before extending the period of use. Feed SATIETY SUPPORT WEIGHT MANAGEMENT until the target body weight is achieved.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Gastrointestinal, Stomach, Hair and Skin, "
                         withFoodName:@"Sensitivity Control with Chicken"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/sensitivity-control-with-chicken-can"
                  withFoodDescription:@"SENSITIVITY CONTROL Chicken & Rice is a complete dietetic feed for dogs formulated to reduce ingredient and nutrient intolerances. This dietetic feed contains selected sources of protein and carbohydrate. Selected protein source: chicken. Selected carbohydrate source: rice.\r\n\r\nIndications: Food intolerance, Atopic dermatitis, Chronic and acute diarrhoea &  Chronic idiopathic colitis.\r\n\r\nRecommendations: Feed for 3 to 8 weeks. If signs of intolerance disappear, this diet can be used indefinitely. It is recommended that a veterinarian’s opinion be sought before use.\r\n\r\nSELECTED PROTEIN\r\nA limited number of protein sources helps reduce the risk of food allergies.\r\n\r\nSKIN BARRIER\r\nA patented complex to support the barrier effect of the skin.\r\n\r\nEPA/DHA\r\nFatty acids to help maintain a healthy digestive system and a healthy skin.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Gastrointestinal, Stomach, Hair and Skin, "
                         withFoodName:@"Sensitivity Control with Duck"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/sensitivity-control-with-duck-can"
                  withFoodDescription:@"SENSITIVITY CONTROL Duck & Rice is a complete dietetic feed for dogs formulated to reduce ingredient and nutrient intolerances. This dietetic feed contains selected sources of protein and carbohydrate. Selected protein source: duck. Selected carbohydrate source: rice.\r\n\r\nIndications: Food intolerance, Atopic dermatitis, Chronic and acute diarrhoea & Chronic idiopathic colitis.\r\n\r\nRecommendations: Feed for 3 to 8 weeks. If signs of intolerance disappear, this diet can be used indefinitely. It is recommended that a veterinarian’s opinion be sought before use.\r\n\r\nSELECTED PROTEIN\r\nA limited number of protein sources helps reduce the risk of food allergies.\r\n\r\nSKIN BARRIER\r\nA patented complex to support the barrier effect of the skin.\r\n\r\nEPA/DHA\r\nFatty acids to help maintain a healthy digestive system and a healthy skin.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n"];
    
    
    
    
     [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                            withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Urinary, "
                         withFoodName:@"Urinary S/O"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/urinary-s-o-can"
                  withFoodDescription:@"URINARY S/O is a complete dietetic feed for dogs formulated to dissolve struvite stones and reduce their recurrence through its urine acidifying properties, a low level of magnesium and a restricted level of protein, but of high quality.\r\n\r\nIndications: Bacterial cystitis, Dissolution of struvite uroliths & Struvite and calcium oxalate urolithiasis.\r\n\r\nContraindications: Pregnancy, Lactation, Growth, Chronic renal failure, metabolic acidosis, Heart failure, Pancreatitis, Hyperlipidaemia & Treatment with urine acidifying drugs.\r\n\r\nSTRUVITE DISSOLUTION\r\nHelps dissolve all types of struvite stones.\r\n\r\nURINE DILUTION\r\nUrine dilution makes the urine less liable to form struvite and calcium oxalate stones.\r\n\r\nLOW RSS\r\nHelps lower the concentration of ions contributing to crystal formation.\r\n\r\nLOW MAGNESIUM\r\nReduced level of magnesium, a natural component of struvite crystals.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Oral Care, "
                         withFoodName:@"Oral Bar OB 70"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/oral-bar-ob-70"
                  withFoodDescription:@"Oral Bar enhances the efficacy of the Dental diet and can be fed in addition to any complete nutrition to dogs over 6 months of age.\r\n\r\nBRUSHING EFFECT\r\nWhen chewed, the special very elastic texture of Oral Bar has a mild abrasive effect which breaks the biofilm (entangled bacteria) structure of dental plaque, helps remove tartar deposits and delays formation of new deposits.\r\n\r\nTARTAR CONTROL\r\nSodium polyphosphate is a chelating agent that makes calcium ions (Ca++) unavailable for tartar formation. Because of its highly hydrophilic nature, polyphosphate can spread through the whole oral cavity, including areas that are not in physical contact with Oral Bar Small Dog during mastication. Zinc favours calcium dissolution and slows down its incorporation into tartar.\r\n\r\nBACTERIA CONTROL\r\nBad breath is the result of bacteriaproduced Volatile Sulphur Compounds (V.S.C.). Because of their antibacterial properties, the active ingredients in Oral Bar Small Dog (zinc, eucalyptus and green tea polyphenols) help limit bacterial growth, reducing the production of Volatile Sulphur Compounds (V.S.C.).\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini,"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Oral Care, "
                         withFoodName:@"Oral Bar OBS 20"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/oral-bar-obs-20"
                  withFoodDescription:@"ORAL BAR SMALL DOG enhances the efficacy of Dental Special Small Dog diet and can be fed in addition to any complete nutrition to dogs over 6 months of age.\r\n\r\nBRUSHING EFFECT\r\nWhen chewed, the special very elastic texture of Oral Bar Small Dog has a mild abrasive effect which breaks the biofilm (entangled bacteria) structure of dental plaque, helps remove tartar deposits and delays formation of new deposits.\r\n\r\nTARTAR CONTROL\r\nSodium polyphosphate is a chelating agent that makes calcium ions (Ca++) unavailable for tartar formation. Because of its highly hydrophilic nature, polyphosphate can spread through the whole oral cavity, including areas that are not in physical contact with Oral Bar Small Dog during mastication. Zinc favours calcium dissolution and slows down its incorporation into tartar.\r\n\r\nBACTERIA CONTROL\r\nBad breath is the result of bacteriaproduced Volatile Sulphur Compounds (V.S.C.). Because of their antibacterial properties, the active ingredients in Oral Bar Small Dog (zinc, eucalyptus and green tea polyphenols) help limit bacterial growth, reducing the production of Volatile Sulphur Compounds (V.S.C.).\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini,"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Urinary"
                         withFoodName:@"Urinary S/O Small Dog"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/urinary-s-o-small-dog-under-10kg"
                  withFoodDescription:@"URINARY S/O Small Dog under 10 kg is a complete dietetic feed for adult small breed dogs formulated to dissolve struvite stones and reduce their recurrence through its urine acidifying properties, a low level of magnesium and a restricted level of protein, but of high quality.\r\n\r\nIndications: Bacterial cystitis, Dissolution of struvite uroliths & Struvite and calcium oxalate urolithiasis.\r\n\r\nContraindications: Pregnancy, Lactation, Growth, Pancreatitis, Hyperlipidaemia, Heart failure, Treatment with urine acidifying drugs, Chronic renal failure & metabolic acidosis.\r\n\r\nSTRUVITE DISSOLUTION\r\nHelps dissolve all types of struvite stones.\r\n\r\nLOW RSS\r\nHelps lower the concentration of ions contributing to struvite and calcium oxalate crystal formation.\r\n\r\nURINE DILUTION\r\nUrine dilution makes the urine less liable to form struvite and calcium oxalate stones.\r\n\r\nTARTAR CONTROL\r\nNutrient that traps the calcium in saliva so reducing tartar deposits.\r\n"];
    
   
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Hair and Skin, "
                         withFoodName:@"Skin Care Adult SK 23"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/skin-care-adult-sk-23-new"
                  withFoodDescription:@"SKIN CARE ADULT is a complete dietetic feed for dogs formulated to support the skin function in the case of dermatosis and excessive loss of hair. This diet has a high level of essential fatty acids.\r\n\r\nIndications: Atopic dermatitis, Ichthyosis, Pyodermatitis, Flea bite allergic dermatosis & Otitis (external).\r\n\r\nContraindications: Pregnancy, Lactation, Growth, Hyperlipidaemia, Pancreatitis, History of pancreatitis & Recommendations.\r\n\r\nIt is recommended that a veterinarian’s opinion be sought before use. After a feeding period of 2 months, it is recommended that a veterinarian’s opinion be sought before extending the period of use.\r\n\r\nDERMAL CARE\r\nHelps in the nutritional management of dogs with reactive skin.\r\n\r\nSKIN BARRIER\r\nA patented complex to support the barrier effect of the skin.\r\n\r\nDIGESTIVE TOLERANCE\r\nNutrients which support a balanced intestinal flora and digestive transit.\r\n\r\nANTIOXIDANT COMPLEX\r\nA patented synergistic complex of antioxidants to help neutralise free radicals.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, "
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Hair and Skin, "
                         withFoodName:@"Skin Care Adult Small Dog SKS 25"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/skin-care-adult-small-dog-sks-25-new"
                  withFoodDescription:@"SKIN CARE SMALL DOG is a complete dietetic feed for adult small breed dogs formulated to support the skin function in the case of dermatosis and excessive loss of hair. This diet has a high level of essential fatty acids.\r\n\r\nIndications: Atopic dermatitis, Ichthyosis, Pyodermatitis, Flea bite allergic dermatosis & Otitis (external).\r\n\r\nContraindications: Pregnancy, Lactation, Growth, Hyperlipidaemia, Pancreatitis & History of pancreatitis.\r\n\r\nRecommendations: It is recommended that a veterinarian’s opinion be sought before use. After a feeding period of 2 months, it is recommended that a veterinarian’s opinion be sought before extending the period of use.\r\n\r\nDERMAL CARE\r\nHelps in the nutritional management of dogs with reactive skin.\r\nSKIN BARRIER\r\nA patented complex to support the barrier effect of the skin.\r\n\r\nANTIOXIDANT COMPLEX\r\nA patented synergistic complex of antioxidants to help neutralise free radicals.\r\n\r\nDENTAL HEALTH\r\nContains specific nutrients which contribute to maintaining good oral health.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Allergic, Gastrointestinal, "
                         withFoodName:@"Anallergenic"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/anallergenic"
                  withFoodDescription:@"ANALLERGENIC is a complete dietetic feed for dogs formulated to reduce ingredient and nutrient intolerances. Selected and highly hydrolysed sources of protein; selected and purified sources of carbohydrate.\r\n\r\nIndications: Food elimination trial, Food allergy, Food intolerance & Inflammatory bowel disease (IBD).\r\n\r\nContraindications: Pregnancy, Lactation & Growth.\r\n\r\nFeed ANALLERGENIC for 3 to 8 weeks. If signs of intolerance disappear, this diet can be used indefinitely.\r\n\r\nOLIGOPEPTIDES\r\nLow molecular weight peptides to reduce the risk of allergic reactions to food.\r\n\r\nALLERGEN RESTRICTION\r\nFormula and production process aimed at excluding sources of food allergens.\r\n\r\nSKIN BARRIER\r\nA patented complex to support the barrier effect of the skin.\r\n\r\nANTIOXIDANT COMPLEX\r\nA patented synergistic complex of antioxidants to help neutralise free radicals.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, "
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Allergic, Gastrointestinal, "
                         withFoodName:@"Hypoallergenic Small Dog HSD 24"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/hypoallergenic-small-dog-hsd-24"
                  withFoodDescription:@"HYPOALLERGENIC SMALL DOG under 10 kg is a complete dietetic feed for adult small breed dogs formulated to reduce ingredient and nutrient intolerances. Selected sources of protein and carbohydrate.\r\n\r\nIndications: Food elimination trial, Food allergy, Food intolerance, Inflammatory bowel disease (IBD), Exocrine pancreatic insufficiency & Bacterial Overgrowth.\r\n\r\nContraindications: Gestating and lactating bitches - Puppies.\r\n\r\nRecommendations: It is recommended that a veterinarian’s opinion be sought before use. Feed HYPOALLERGENIC SMALL DOG under 10kg for 3 to 8 weeks. If signs of intolerance disappear, this diet can be used indefinitely.\r\n\r\nHYDROLYSED PROTEIN\r\nHydrolysed protein with low molecular weight to ensure the food is hypoallergenic.\r\n\r\nLOW RSS\r\nHelps lower the concentration of ions contributing to crystal formation.\r\n\r\nSKIN BARRIER\r\nA patented complex to support the barrier effect of the skin.\r\n\r\nDENTAL HEALTH\r\nContains specific nutrients which contribute to maintaining good oral health.\r\n"];
    
    
    
     
     [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                           withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                         withFoodBrand:@"Royal Canin Veterinary Diets"
                         withSelectOne:@"Allergic, Gastrointestinal, "
                          withFoodName:@"Hypoallergenic HME 23 Moderate Calorie"
                             withImage:@"royalCaninVeterinaryDiet.jpg"
                           withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/hypoallergenic-hme-23-moderate-calorie"
                   withFoodDescription:@"HYPOALLERGENIC MODERATE CALORIE is a complete dietetic feed for dogs formulated to reduce ingredient and nutrient intolerances. Selected sources of protein and carbohydrate.\r\n\r\nIndications: Food elimination trial, Food allergy, Food intolerance, Inflammatory bowel disease (IBD), Exocrine pancreatic insufficiency & Bacterial Overgrowth.\r\n\r\nRecommendations: It is recommended that a veterinarian’s opinion be sought before use. Feed HYPOALLERGENIC MODERATE CALORIE for 3 to 8 weeks. If signs of intolerance disappear, this diet can be used indefinitely.\r\n\r\nHYDROLISED PROTEIN\r\nHydrolysed protein with low molecular weight to ensure the food is hypoallergenic.\r\n\r\nMODERATE CALORIE\r\nModerate calorie content to help maintain ideal weight.\r\n\r\nSKIN BARRIER\r\nA patented complex to support the barrier effect of the skin.\r\n\r\nMODERATE PHOSPHORUS\r\nA moderate phosphorus intake to help support healthy kidney function.\r\n"];
     
     
     
     
      [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                            withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                         withFoodBrand:@"Royal Canin Veterinary Diets"
                         withSelectOne:@"Urinary"
                          withFoodName:@"Urinary U/C UUC 18 Low Purine"
                             withImage:@"royalCaninVeterinaryDiet.jpg"
                           withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/urinary-u-c-uuc-18-low-purine"
                    withFoodDescription:@"URINARY U/C LOW PURINE is a complete dietetic feed for dogs formulated to reduce the formation of urate and cystine stones through its low level of protein and purine, its high quality protein, its moderate level of sulphur amino acids and its urine alkalising properties.\r\n\r\nContraindications: Pregnancy, Lactation, Growth & Treatment with urine acidifying drugs.\r\n\r\nURATE CONTROL\r\nA selection of proteins with low purine content helps reduce the formation of urate urinary stones.\r\n\r\nCYSTINE CONTROL\r\nA limited intake of proteins and of some amino acids helps limit the formation of cystine urinary stones.\r\n\r\nSKIN BARRIER\r\nA patented complex to support the barrier effect of the skin.\r\n\r\nANTIOXIDANT COMPLEX\r\nA patented synergistic complex of antioxidants to help neutralise free radicals.\r\n"];
     
     
     
     
       [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                             withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                         withFoodBrand:@"Royal Canin Veterinary Diets"
                         withSelectOne:@"Gastrointestinal, "
                          withFoodName:@"Gastro Intestinal Low Fat"
                             withImage:@"royalCaninVeterinaryDiet.jpg"
                           withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/gastro-intestinal-low-fat-dry"
                     withFoodDescription:@"GASTRO-INTESTINAL LOW FAT is a complete dietetic feed for the nutritional management of dogs formulated to regulate lipid metabolism in the case of hyperlipidaemia. This feed contains a low level of fat and a high level of essential fatty acids.\r\n\r\n                            Indications: Chronic and acute diarrhoea, Hyperlipidaemia, Lymphangiectasia, Exocrine pancreatic insufficiency, Acute and chronic Pancreatitis, Exudative enteropathy & Bacterial Overgrowth.\r\n\r\nContraindications: Pregnancy & Lactation\r\n\r\nRecommendations: It is recommended that a veterinarian’s opinion be sought before use or before extending the period of use. Initially feed GASTRO-INTESTINAL LOW FAT for 2 months in the case of hyperlipidaemia.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n\r\nLOW FAT\r\nFor the nutritional management of dogs with digestive disorders in need of a low fat diet.\r\n\r\nLOW FIBRE\r\nFor the nutritional management of dogs with digestive disorders in need of a low fibre diet.\r\n\r\nANTIOXIDANT COMPLEX\r\nA patented synergistic complex of antioxidants to help neutralise free radicals.\r\n"];
     
     
     
     
     [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                           withDogSize:@"Large, Giant"
                         withFoodBrand:@"Royal Canin Veterinary Diets"
                         withSelectOne:@"Articular Mobility, Bones and Joints"
                          withFoodName:@"Mobility Larger Dogs "
                             withImage:@"royalCaninVeterinaryDiet.jpg"
                           withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/mobility-larger-dogs-dry"
                   withFoodDescription:@"Complete feed for adult dogs.\r\n\r\nContraindications: Lactation & Growth.\r\n\r\nMaximum benefits are expected after 6 to 8 weeks feeding.\r\nNutritional management can then be continued for the pet’s lifetime.\r\nFollow your vet’s nutritional recommendations.\r\n\r\nJOINT COMPLEX PLUS\r\nNew Zealand green-lipped mussel extract with nutrients to help maintain healthy joints.\r\n\r\nHIGH EPA / DHA\r\nHigh EPA/DHA content to help maintain healthy joints.\r\n\r\nMODERATE CALORIE\r\nModerate calorie content to help maintain ideal weight and support joints stressed by excess weight.\r\n\r\nDIGESTIVE TOLERANCE\r\nNutrients which support a balanced intestinal flora and digestive transit.\r\n"];
     
     
     
     
     [self insertFoodProductWithDogAge:@"0-12 months, "
                           withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                         withFoodBrand:@"Royal Canin Veterinary Diets"
                         withSelectOne:@"Convalescent, Gastrointestinal, Stomach, "
                          withFoodName:@"Gastro Intestinal Junior"
                             withImage:@"royalCaninVeterinaryDiet.jpg"
                           withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/gastro-intestinal-junior-dry"
                   withFoodDescription:@"GASTRO-INTESTINAL JUNIOR is a complete dietetic feed for the nutritional management of puppies formulated to reduce acute intestinal absorption disorders, and promote nutritional restoration and convalescence. Highly digestible ingredients. Increased level of electrolytes and essential nutrients. High energy level.\r\n\r\nIndications: Chronic and acute diarrhoea, Malabsorption, Maldigestion, Convalescence, Colitis, Bitches from the 6th to the 9th week of pregnancy, Lactating bitches & Bacterial Overgrowth.\r\n\r\nContraindications: Hyperlipidaemia, Pancreatitis, Lymphangiectasia -exudative enteropathy & All pathologies in which a low fat diet is indicated.\r\n\r\nRecommendations: It is recommended that a veterinarian’s opinion be sought before use. Feed GASTRO-INTESTINAL JUNIOR for 1 to 2 weeks during periods of recovery from acute diarrhoea, until restoration is achieved.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n\r\nHIGH ENERGY\r\nAppropriate energy content to meet the needs of puppies without overloading the stomach.\r\n\r\nEASY REHYDRATION\r\nKibbles which are easy to soak to facilitate the transition from milk to dry food.\r\n\r\nOPTIMAL GROWTH\r\nHelps support the puppy’s harmonious growth.\r\n"];
     
     
     
     
     [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                           withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                         withFoodBrand:@"Royal Canin Veterinary Diets"
                         withSelectOne:@"Convalescent, Gastrointestinal, Stomach, Anorexia"
                          withFoodName:@"Gastro Intestinal "
                             withImage:@"royalCaninVeterinaryDiet.jpg"
                           withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/gastro-intestinal-dry"
                   withFoodDescription:@"GASTRO-INTESTINAL is a complete dietetic feed for the nutritional management of dogs formulated to reduce acute intestinal absorption disorders, and promote nutritional restoration and convalescence. Highly digestible ingredients. Increased level of electrolytes and essential nutrients. High energy level.\r\n\r\nIndications: Chronic and acute diarrhoea, Inflammatory bowel disease (IBD), Malabsorption, Maldigestion, Convalescence, Exocrine pancreatic insufficiency, Gastritis, Colitis, Anorexia & Bacterial Overgrowth.\r\n\r\nContraindications: Pancreatitis, Hyperlipidaemia, History of pancreatitis, Lymphangiectasia & Hepatic encephalopathy.\r\n\r\nRecommendations: It is recommended that a veterinarian’s opinion be sought before use. Feed GASTRO-INTESTINAL for 1 to 2 weeks during periods of recovery from acute diarrhoea, until resolved.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n\r\nHIGH ENERGY\r\nAdequate energy content to meet the needs of adult dogs without overloading the stomach.\r\n\r\nHIGH PALATABILITY\r\nHigh palatability to satisfy decreased or fussy appetites.\r\n\r\nEPA/DHA\r\nEPA/DHA to help maintain a healthy digestive system.\r\n"];
     
     
     
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Cardiovascular"
                         withFoodName:@"Cardiac"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/cardiac-dry"
                  withFoodDescription:@"CARDIAC is a complete dietetic feed for dogs formulated to support heart function in the case of chronic cardiac insufficiency. This diet contains a low level of sodium and an increased K/Na ratio.\r\n\r\nIndications: Hypertension & Heart disease/failure.\r\n\r\nContraindications: Pregnancy, Lactation, Pancreatitis, Hyperlipidaemia & Growth.\r\n\r\n Recommendations: It is recommended that a veterinarian’s opinion be sought before use or before extending the period of use. Initially feed CARDIAC for up to 6 months.\r\n\r\nVASCULAR SUPPORT\r\nSpecific nutrients to help support the vascular system and help neutralise free radicals.\r\n\r\nEARLY RENAL SUPPORT\r\nA moderate phosphorus content to help maintain renal function.\r\n\r\nELECTROLYTE BALANCE\r\nPotassium, magnesium and sodium content adapted to help support dogs with chronic heart insufficiency.\r\n\r\nCARDIAC SUPPORT\r\nNutrients which contribute to maintaining health of the cardiac muscle.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Hepatic, "
                         withFoodName:@"Hepatic HF 16"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/hepatic-hf-16"
                  withFoodDescription:@"HEPATIC is a complete dietetic feed for the nutritional management of dogs formulated to support liver function in the case of chronic liver insufficiency and for the reduction of copper in the liver. Moderate level of high quality protein. High level of essential fatty acids and highly digestible carbohydrates. Low level of copper.\r\n\r\nIndications: Liver disease, Portosystemic shunt, Hepatic encephalopathy, Piroplasmosis, Chronic hepatitis, Liver failure & Copper metabolism disorders.\r\n\r\nContraindications: Pregnancy, Lactation, Pancreatitis, Hyperlipidaemia, Growth & History of pancreatitis.\r\n\r\nRecommendations: It is recommended that a veterinarian’s opinion be sought before use or before extending the period of use. Initially feed HEPATIC for up to 6 months.\r\n\r\nVEGETABLE PROTEIN\r\nVegetable protein which is better assimilated by dogs with liver insufficiency.\r\n\r\nLOW COPPER\r\nLow level of copper to help reduce its accumulation in liver cells.\r\n\r\nANTIOXIDANT COMPLEX\r\nA patented synergistic complex of antioxidants to help neutralise free radicals.\r\n\r\nHIGH ENERGY\r\nAdequate energy intake to meet the needs of an adult dog without overloading the stomach.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Renal, "
                         withFoodName:@"Renal Wet"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/renal-wet"
                  withFoodDescription:@"RENAL is a complete dietetic feed for dogs formulated to support renal function in the case of chronic or temporary renal insufficiency, through its low level of phosphorus and high quality protein.\r\n\r\nIndications: Chronic renal insufficiency (CRI) & Urate and cystine urolithiasis.\r\n\r\nContraindications: Pregnancy, Lactation, Growth, Pancreatitis, History of pancreatitis & Hyperlipidaemia.\r\n\r\nEPA/DHA\r\nEPA/DHA to help maintain a healthy digestive system.\r\n\r\nLOW PHOSPHORUS\r\nA low phosphorus intake is key to help support renal function in dogs with chronic renal insufficiency.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n\r\nANTIOXIDANT COMPLEX\r\nA patented synergistic complex of antioxidants to help neutralise free radicals.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Cardiovascular, "
                         withFoodName:@"Cardiac Wet"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/cardiac-wet"
                  withFoodDescription:@"CARDIAC is a complete dietetic feed for dogs formulated to support heart function in the case of chronic cardiac insufficiency. This diet contains a low level of sodium and an increased K/Na ratio.\r\n\r\nRecommendations\r\nIt is recommended that a veterinarian’s opinion be sought before use or before extending the period of use. Initially feed CARDIAC for up to 6 months.\r\n\r\nVASCULAR SUPPORT\r\nSpecific nutrients to help support the vascular system and help neutralise free radicals.\r\n\r\nCARDIAC SUPPORT\r\nNutrients which contribute to maintaining health of the cardiac muscle.\r\n\r\nELECTROLYTE BALANCE\r\nPotassium, magnesium and sodium content adapted to help support dogs with chronic heart insufficiency.\r\n\r\nLOW SODIUM\r\nLow sodium diets reduce the retention of water and sodium which are associated with cardiac disease. This significant restriction enables the veterinarian to choose a reasoned sodium supplement when required.\r\n\r\nPets with cardiac disease are more prone to oxidative stress. Free radicals are cytotoxic and have a negative inotropic effect. Polyphenols, thanks to their antioxidant properties, significantly minimise the deleterious effects of free radicals. Moreover, they have an antihypertensive action (Duarte 2001), by stimulating the endogenous production of nitric oxide (a local vasodilator).\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Gastrointestinal, Convalescent, Anorexia, Stomach"
                         withFoodName:@"Gastro Intestinal Wet"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/gastro-intestinal-wet"
                  withFoodDescription:@"GASTRO-INTESTINAL is a complete dietetic feed for the nutritional management of dogs formulated to reduce acute intestinal absorption disorders, and promote nutritional restoration and convalescence. Highly digestible ingredients. Increased level of electrolytes and essential nutrients. High energy level.\r\n\r\nIndications: Chronic and acute diarrhoea, Inflammatory bowel disease (IBD), Malabsorption, Maldigestion, Convalescence, Exocrine pancreatic insufficiency, Gastritis, Colitis, Anorexia & Bacterial Overgrowth.\r\n\r\nContraindications: Pancreatitis, Hyperlipidaemia, History of pancreatitis, Lymphangiectasia & Hepatic encephalopathy.\r\n\r\nRecommendations: It is recommended that a veterinarian’s opinion be sought before use. Feed GASTRO-INTESTINAL for 1 to 2 weeks during periods of recovery from acute diarrhoea, until resolved.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n\r\nHIGH ENERGY\r\nAdequate energy content to meet the needs of adult dogs without overloading the stomach.\r\n\r\nEPA/DHA\r\nEPA/DHA to help maintain a healthy digestive system.\r\n\r\nANTIOXIDANT COMPLEX\r\nA patented synergistic complex of antioxidants to help neutralise free radicals.\r\n"];
    
    
    
     [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                           withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Gastrointestinal, "
                         withFoodName:@"Gastro Intestinal Low Fat Wet"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/gastro-intestinal-low-fat-wet"
                   withFoodDescription:@"GASTRO-INTESTINAL LOW FAT is a complete dietetic feed for the nutritional management of dogs formulated to regulate lipid metabolism in the case of hyperlipidaemia. This food contains a low level of fat and a high level of essential fatty acids.\r\n\r\nIndications: Chronic and acute diarrhoea, Hyperlipidaemia, Lymphangiectasia, Exocrine pancreatic insufficiency, Acute pancreatitis and history of pancreatitis & Bacterial Overgrowth.\r\n\r\nContraindications: Pregnancy & Lactation.\r\n\r\nRecommendations: It is recommended that a veterinarian’s opinion be sought before use or before extending the period of use. Initially feed GASTRO-INTESTINAL LOW FAT for 2 months in the case of hyperlipidaemia.\r\n\r\nDIGESTIVE SECURITY\r\n Nutrients which support a balanced digestive system.\r\n\r\nLOW FAT\r\nFor the nutritional management of dogs with digestive disorders in need of a low fat diet.\r\n\r\nFIBRE BALANCE\r\nAdjusted levels of soluble/insoluble fibres to help limit fermentations and promote good stools quality.\r\n\r\nANTIOXIDANT COMPLEX\r\nA patented synergistic complex of antioxidants to help neutralise free radicals.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 year"
                          withDogSize:@"X-Small, Mini,"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Oral Care, "
                         withFoodName:@"Dental Special Small Dog"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/dental-special-small-dog-dry"
                  withFoodDescription:@"Complete feed for adult dogs - For small breed dogs (weight between 1 and 10 kg) with oral sensitivity.\r\n\r\nBRUSHING EFFECT\r\nThe kibble’s shape, texture and size help produce a mechanical brushing effect on teeth.\r\n\r\nTARTAR CONTROL\r\nNutrient that traps the calcium in saliva so reducing tartar deposits.\r\n\r\nSKIN BARRIER\r\nA patented complex to support the barrier effect of the skin.\r\n\r\nURINE DILUTION\r\nUrine dilution makes the urine less liable to form struvite and calcium oxalate stones.\r\n"];
    
    
   
     [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                           withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Overweight, Ideal Weight, "
                         withFoodName:@"Obesity Management"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/obesity-management-dry"
                   withFoodDescription:@"OBESITY MANAGEMENT is a complete dietetic feed for dogs formulated to reduce excessive body weight. This feed has a low energy density.\r\n\r\nIndications: Overweight.\r\n\r\nContraindications: Pregnancy, Lactation, Growth & Recommendations.\r\n\r\nIt is recommended that a veterinarian’s opinion be sought before use or before extending the period of use. Feed OBESITY MANAGEMENT until the target body weight is achieved.\r\n"];
    
    
    
      [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                            withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Gastrointestinal, Stomach"
                         withFoodName:@"Gastro Intestinal Moderate Calorie"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/gastro-intestinal-moderate-calorie-dry"
                    withFoodDescription:@"GASTRO-INTESTINAL MODERATE CALORIE is a complete dietetic feed for the nutritional management of dogs formulated to reduce  acute intestinal absorption disorders, and as compensation from maldigestion. Highly digestible ingredients. Increased level of electrolytes. Low level of fat. Its moderate calorie content makes it particularly suitable for dogs in which ideal weight is hard to maintain (neutering / overweight / low activity)\r\n\r\nIndications: Chronic and acute diarrhoea, Inflammatory bowel disease (IBD), Malabsorption, Maldigestion, Exocrine pancreatic insufficiency, Chronic pancreatitis, Gastritis, Colitis & Bacterial Overgrowth.\r\n\r\nContraindications: Pregnancy & Lactation.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n\r\nMODERATE CALORIE\r\nModerate calorie content to help maintain ideal weight.\r\n\r\nHIGH PALABILITY\r\nHigh palatability to satisfy decreased or fussy appetites.\r\n\r\nEPA/DHA\r\nEPA/DHA to help maintain a healthy digestive system.\r\n"];
    
    
    
       [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                             withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Fibre, Gastrointestinal, Stomac, "
                         withFoodName:@"Fibre Response"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/fibre-response-dry"
                     withFoodDescription:@"Indications: Constipation, Fibre responsive colitis, Stress-diarrhoea, Disorders & in which a higher level of fiber is indicated.\r\n\r\n Contraindications: Obstipation & Megacolon.\r\n\r\nRecommendations: Follow your vet’s nutritional recommendations.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n\r\nHIGH FIBRE\r\nFeed with a high dietary fibre content.\r\n\r\nEPA/DHA\r\nEPA/DHA to help maintain a healthy digestive system.\r\n\r\nANTIOXIDANT COMPLEX\r\nA patented synergistic complex of antioxidants to help neutralise free radicals.\r\n"];
    
    
    
        [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                              withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Renal, "
                         withFoodName:@"Renal"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/renal-dry"
                      withFoodDescription:@"RENAL is a complete dietetic feed for dogs formulated:\r\n - to support renal function in the case of chronic or temporary renal insufficiency, through its low level of phosphorus and high quality protein\r\n - to reduce oxalate stone formation, through its low level of calcium and vitamin D, and its urine alkalising properties\r\n\r\nIndications: Chronic renal insufficiency (CRI) & Urate and cystine urolithiasis\r\n\r\n Contraindications: Pregnancy, Lactation, Growth, History of pancreatitis, Pancreatitis & Hyperlipidaemia.\r\n\r\nLOW PHOSPHORUS\r\nA low phosphorus intake is key to help support renal function in dogs with chronic renal insufficiency.\r\n\r\nVASCULAR SUPPORT\r\nNutrients that help support good renal filtration.\r\n\r\nANTIOXIDANT COMPLEX\r\nA patented synergistic complex of antioxidants to help neutralise free radicals.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n"];
    
    
    
         [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                               withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                             withFoodBrand:@"Royal Canin Veterinary Diets"
                             withSelectOne:@"Overweight, Ideal Weight, "
                         withFoodName:@"Obesity Management Wet"
                            withImage:@"royalCaninVeterinaryDiet.jpg"
                          withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/obesity-management-wet"
                       withFoodDescription:@"OBESITY MANAGEMENT is a complete dietetic feed for dogs formulated to reduce excessive body weight. This feed has a low energy density.\r\n\r\nRecommendations: It is recommended that a veterinarian’s opinion be sought before use. Feed OBESITY MANAGEMENT until the target body weight is achieved.\r\n\r\nENERGY DILUTION\r\nDecreases the energy intake 50-70% compared to the same volume of a standard wet food.\r\n\r\nHIGH PROTEIN\r\nHigh protein content to help maintain muscle mass throughout the weight loss period.\r\n\r\nNUTRIENTS BALANCE\r\nEnriched with nutrients, minerals and vitamins to avoid deficiencies when calorie intake is restricted.\r\n\r\nBONE AND JOINT HEALTH\r\nHelps maintain healthy bones and joints.\r\n"];
    
          
          
          [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                                withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                              withFoodBrand:@"Royal Canin Veterinary Diets"
                              withSelectOne:@"Articular Mobility, Bones and Joints"
                               withFoodName:@"Mobility"
                                  withImage:@"royalCaninVeterinaryDiet.jpg"
                                withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/mobility-dry"
                        withFoodDescription:@"Indications:  Helps to maintain mobility in dogs & Helps support the joints after an orthopedic surgery or a traumatism.\r\n\r\n  Contraindications: Lactation.\r\n\r\nRecommendations: Maximum benefits are expected after 6 to 8 weeks feeding. Nutritional management can then be continued for the pet’s lifetime. Follow your vet’s nutritional recommendations.\r\n\r\nJOINT COMPLEX PLUS\r\nNew Zealand green-lipped mussel extract with nutrients to help maintain healthy joints.\r\n\r\nEPA/DHA\r\nHigh EPA/DHA content to help maintain healthy joints.\r\n\r\nMODERATE CALORIE\r\nModerate calorie content to help maintain ideal weight and support joints stressed by excess weight.\r\n\r\nANTIOXIDANT COMPLEX\r\nA patented synergistic complex of antioxidants to help neutralise free radicals.\r\n"];
          
          
          
          
           [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                                 withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                               withFoodBrand:@"Royal Canin Veterinary Diets"
                               withSelectOne:@"Hepatic, "
                               withFoodName:@"Hepatic Wet"
                                  withImage:@"royalCaninVeterinaryDiet.jpg"
                                withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/hepatic-wet"
                         withFoodDescription:@"HEPATIC is a complete dietetic feed for the nutritional management of dogs formulated to support liver function in the case of chronic liver insufficiency and for the reduction of copper in the liver. Moderate level of high quality protein. High level of essential fatty acids and highly digestible carbohydrates. Low level of copper.\r\n\r\nIndications: Liver disease, Portosystemic shunt, Hepatic encephalopathy, Piroplasmosis, Chronic hepatitis, Liver failure & Copper metabolism disorders.\r\n\r\nContraindications: Pregnancy, Lactation, Hyperlipidaemia,  Pancreatitis, Growth & History of pancreatitis.\r\n\r\nLOW COPPER\r\nLow level of copper to help reduce its accumulation in liver cells.\r\n\r\nANTIOXIDANT COMPLEX\r\nA patented synergistic complex of antioxidants to help neutralise free radicals.\r\n\r\nELECTROLYTE BALANCE\r\nA low sodium intake decreases portal hypertension and reduces extravascular fluid loss.\r\n\r\nHIGH ENERGY\r\nAdequate energy intake to meet the needs of an adult dog without overloading the stomach.\r\n"];
          
          
          
          
            [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                                  withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                                withFoodBrand:@"Royal Canin Veterinary Diets"
                                withSelectOne:@"Gastrointestinal, Stomach, Allergic, "
                               withFoodName:@"Sensitivity Control SC 21"
                                  withImage:@"royalCaninVeterinaryDiet.jpg"
                                withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/sensitivity-control-sc-21"
                        withFoodDescription:@"SENSITIVITY CONTROL is a complete dietetic feed for dogs formulated to reduce ingredient and nutrient intolerances. Selected protein source: duck. Selected carbohydrate source: tapioca.\r\n\r\nIndications: Food elimination trial, Food allergy, Food intolerance, Inflammatory bowel disease (IBD), Diarrhoea & Colitis.\r\n\r\nRecommendations: It is recommended that a veterinarian’s opinion be sought before use. Feed SENSITIVITY CONTROL for 3 to 8 weeks. If signs of intolerance disappear, this diet can be used indefinitely.\r\n\r\nSELECTED PROTEIN\r\nA limited number of protein sources helps reduce the risk of food allergies.\r\n\r\n SKIN BARRIER\r\n A patented complex to support the barrier effect of the skin.\r\n\r\nEPA/DHA\r\nFatty acids to help maintain a healthy digestive system and a healthy skin.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n"];
          
          
          
          
          [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                                withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                              withFoodBrand:@"Royal Canin Veterinary Diets"
                              withSelectOne:@"Ideal Weight, "
                               withFoodName:@"Weight Control DS 30"
                                  withImage:@"royalCaninVeterinaryDiet.jpg"
                                withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/weight-control-ds-30"
                        withFoodDescription:@"Complete feed for adult dogs.\r\n\r\nLEAN BODY MASS\r\nHigh protein content to help favour maintenance of lean body mass.\r\n\r\nMODERATE CALORIE\r\nModerate calorie content to help combat excess weight gain.\r\n\r\nBONE AND JOINT HEATH\r\nHelps maintain healthy bones and joints.\r\n\r\nANTIOXIDANT COMPLEX\r\nA synergistic complex of antioxidants to help neutralise free radicals.\r\n"];
          
          
          
          
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                              withFoodBrand:@"Royal Canin Veterinary Diets"
                              withSelectOne:@"Allergic"
                               withFoodName:@"Hypoallergenic Canine WET"
                                  withImage:@"royalCaninVeterinaryDiet.jpg"
                                withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/hypoallergenic-canine-wet"
                  withFoodDescription:@"HYPOALLERGENIC is a complete dietetic feed for dogs formulated to reduce ingredient and nutrient intolerances. Selected sources of protein and carbohydrate.\r\n\r\nHYDROLISED PROTEIN\r\nSoy protein isolate digest, which is composed of low molecular weight peptides, is highly digestible and of very low allergenicity.\r\n\r\nSKIN BARRIER\r\nA combination of nicotinamide, inositol, choline, histidine and pantothenic acid helps reduce water losses through the skin and strengthen the barrier effect of the skin.\r\n\r\nANTIOXIDANT COMPLEX\r\nThe synergistic antioxidant complex reduces oxidative stress and helps neutralise free radicals.\r\n\r\nFATTY ACIDS\r\nEnriched with linoleic acid, EPA and DHA, essential and non-essential fatty acids known to modulate cutaneous reactions and help maintain skin health.\r\n"];
          
          
          
          
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                              withFoodBrand:@"Royal Canin Veterinary Diets"
                              withSelectOne:@"Diabetes"
                               withFoodName:@"Diabetic DS37"
                                  withImage:@"royalCaninVeterinaryDiet.jpg"
                                withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/diabetic-dog-ds37"
                  withFoodDescription:@"DIABETIC is a complete dietetic feed for dogs formulated to regulate glucose supply (Diabetes Mellitus). This feed contains a low level of rapid glucosereleasing carbohydrates.\r\n\r\nRecommendations: It is recommended that a veterinarian’s opinion be sought before use or before extending the period of use. Initially feed.\r\n\r\nDIABETIC for up to 6 months.Indications: Diabetes mellitus.\r\n\r\nContraindications: Pregnancy, Lactation & Growth.\r\n\r\nGLUCOMODULATION\r\nSpecific formula to help in the management of post-prandial blood glucose in diabetic dogs.\r\n\r\nHIGH PROTEIN\r\nHigh protein content. Maintenance of muscle mass is essential in overweight diabetic dogs.\r\n\r\nLOW STARCH\r\nFormula that contains a reduced level of starch.\r\n\r\nANTIOXIDANT COMPLEX\r\nA synergistic complex of antioxidants to help neutralise free radicals.\r\n"];
          
          
          
          
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, "
                              withFoodBrand:@"Royal Canin Veterinary Diets"
                              withSelectOne:@"Stress, "
                               withFoodName:@"Calm CD 25"
                                  withImage:@"royalCaninVeterinaryDiet.jpg"
                                withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/calm-cd-25"
                  withFoodDescription:@"From 15 months.\r\n\r\nComplete feed for adult dogs.\r\n\r\nIndications:\r\n\r\n- Helps dogs of under 15 kg manage stressful situations\r\n- Contributes to fight against stress-related digestive and skin manifestations\r\n- As support for behavioural therapy initiated for anxiety disorders\r\n\r\nContraindications: Chronic renal insufficiency, metabolic acidosis, Heart failure, Hypertension, Pancreatitis & Hyperlipidaemia.\r\n\r\nRecommendations: Follow your vet’s nutritional recommendations.\r\n\r\nEMOTIONAL BALANCE\r\nAlpha-S1 casein trypsic hydrolysate and an adequate content of tryptophan (amino acid) to help maintain emotional balance.\r\n\r\nSKIN BARRIER\r\n\r\nA patented complex to support the barrier effect of the skin.\r\nDIGESTIVE TOLERANCE\r\n\r\nNutrients which support a balanced intestinal flora and digestive transit.\r\n\r\nTARTAR CONTROL\r\nNutrient that traps the calcium in saliva so reducing tartar deposits.\r\n"];
          
          
          
          
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                              withFoodBrand:@"Royal Canin Veterinary Diets"
                              withSelectOne:@"Convalescent"
                               withFoodName:@"Rehydration Support Cats/Dogs"
                                  withImage:@"royalCaninVeterinaryDiet.jpg"
                                withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/rehydration-support-cats-dogs"
                  withFoodDescription:@"REHYDRATION SUPPORT ELECTROLYTE INSTANT is a complementary food for dogs and cats for the support of intestinal absorptive disorders. This food contains an increased level of electrolytes and highly digestible ingredients.\r\n\r\nFeeding Duration: According to the veterinarian’s assessment.\r\n\r\nELECTROLYTE BALANCE\r\nRehydration Support Instant Diet formula has been designed to replace lost fluids and electrolytes in dehydrated dogs and cats. Sodium and chloride contents are approximately equivalent and compensate for losses.\r\nFurther information:\r\nRehydration Support Instant Diet is a solution for oral administration which offers many advantages: - easy administration - low cost - low supervision and maintenance - non-invasive technique.\r\n"];
          
          
          
          
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                              withFoodBrand:@"Royal Canin Veterinary Diets"
                              withSelectOne:@"Convalescent"
                               withFoodName:@"Convalescence Support Dogs/Cats"
                                  withImage:@"royalCaninVeterinaryDiet.jpg"
                                withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/convalescence-support-dogs-cats"
                  withFoodDescription:@"CONVALESCENCE SUPPORT INSTANT DIET is a complete dietetic feed intended for dogs and cats for nutritional restoration and convalescence. This feed has a high energy level and a high concentration of essential nutrients which are highly digestible.\r\n\r\nIndications: Anorexia, Malnutrition, Tube feeding, Post-surgery, Pregnancy, Lactation & Growth.\r\n\r\nFeeding Duration: According to the veterinarian’s assessment.\r\n\r\nHIGH ENERGY\r\nConvalescence Instant Diet has a high energy concentration (4 734 kcal/kg dry matter). Easily diluted with water, it becomes an energy dense and complete liquid diet which is highly palatable and highly digestible.\r\n\r\nANTIOXIDANT COMPLEX\r\nAntioxidant complex (Vit E, Vit C, taurine and lutein) reduces cell stresses caused by oxidative stress and free radicals.\r\n\r\nHIGH DIGESTIBILITY\r\nHighly digestible ingredients compensate for the decreased activity of intestinal enzymes, ensuring an optimal nutrient supply.\r\n"];
          
          
          
          
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Royal Canin Veterinary Diets"
                        withSelectOne:@"Convalescent"
                               withFoodName:@"Recovery Cats/Dogs"
                                  withImage:@"royalCaninVeterinaryDiet.jpg"
                                withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/recovery-cats-dogs"
                  withFoodDescription:@"RECOVERY is a complete dietetic feed for dogs and cats, formulated to promote nutritional restoration during convalescence or in the case of feline hepatic lipidosis. This feed has a high energy density and a high concentration of essential nutrients which are highly digestible.\r\n\r\nIndications: Anorexia, Malnutrition, Convalescence, Tube feeding, Hepatic lipidosis, Pregnancy, Lactation, Growth & Post-surgery.\r\n\r\nContraindications: Hepatic encephalopathy, Pancreatitis & Hyperlipidaemia.\r\n\r\nRecommendations: Feed until restoration is achieved. Administration under veterinary supervision.\r\n\r\nHIGH ENERGY\r\nThe high energy content of Recovery helps compensate the volume reduction of food intake with fussy pets.\r\n\r\nEASY TUBE FEEDING\r\nRecovery texture makes it easier to use for periodic syringe feeding and tube feeding.\r\n\r\nEPA/DHA\r\nEicosapentaenoic and docosahexaenoic acids, omega-3 long chain fatty acids, modulate skin reactions and contribute to the intestinal mucosal integrity.\r\n\r\nANTIOXIDANT COMPLEX\r\nThe synergistic antioxydant complex (vitamin. E, vitamin. C, taurine and luteine) helps fight cellular agressions induced by oxidative stress and promotes good health of the immune system.\r\n"];
          
          
          
          
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                              withFoodBrand:@"Royal Canin Veterinary Diets"
                              withSelectOne:@"Urinary, Overweight, Sterilised, Neutered, "
                               withFoodName:@"Urinary S/O Moderate Calorie"
                                  withImage:@"royalCaninVeterinaryDiet.jpg"
                                withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/urinary-s-o-moderate-calorie"
                  withFoodDescription:@"URINARY S/O Moderate Calorie is a complete dietetic feed for dogs formulated to dissolve struvite stones and reduce their recurrence through its urine acidifying properties, a low level of magnesium and a restricted level of protein, but of high quality. Its moderate calorie content makes it particularly suitable for dogs in which ideal weight is hard to maintain (neutering / overweight / low activity).\r\n\r\nIndications: Bacterial cystitis, Dissolution of struvite uroliths & Struvite and calcium oxalate urolithiasis.\r\n\r\nContraindications: Pregnancy, Lactation, Growth, Chronic renal failure, metabolic acidosis, Pancreatitis, Hyperlipidaemia, Heart failure & Treatment with urine acidifying drugs.\r\n\r\nSTRUVITE DISSOLUTION\r\nHelps dissolve all types of struvite stones.\r\n\r\nMODERATE CALORIE\r\nModerate calorie content to help maintain ideal weight.\r\n\r\nURINE DILUTION\r\nUrine dilution makes the urine less liable to form struvite and calcium oxalate stones.\r\n\r\nLOW RSS\r\nHelps lower the concentration of ions contributing to struvite and calcium oxalate crystal formation.\r\n"];
          
          
          
          
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                              withFoodBrand:@"Royal Canin Veterinary Diets"
                              withSelectOne:@"Diabetes, "
                               withFoodName:@"Diabetic Special Low Carbohydrate"
                                  withImage:@"royalCaninVeterinaryDiet.jpg"
                                withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/diabetic-special-low-carbohydrate"
                  withFoodDescription:@"DIABETIC SPECIAL is a complete dietetic feed for dogs formulated to regulate glucose supply (Diabetes Mellitus). This feed contains a low level of rapid glucose-releasing carbohydrates.\r\n\r\nRecommendations:\r\nIt is recommended that a veterinarian’s opinion be sought before use or before extending the period of use. Initially feed DIABETIC SPECIAL for up to 6 months.\r\n\r\nGLUCO MODULATION\r\nFibres and cereals of low glycaemic index enable control of post-prandial hyperglycaemia.\r\n\r\nHIGH PROTEIN\r\nA high protein level promotes lean muscle mass and helps limit postprandial glycaemia. Enriched with L-carnitine.\r\n\r\nMODERATE CALORIE\r\nA reduced calorie content helps limit weight gain in dogs with a tendency to overweight.\r\n\r\nLOW STARCH\r\nA low carbohydrate intake helps control postprandial blood glucose to facilitate global diabetes mellitus management.\r\n"];
          
          
          
          
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                              withFoodBrand:@"Royal Canin Veterinary Diets"
                              withSelectOne:@"Urinary"
                               withFoodName:@"Urinary S/O LP 18"
                                  withImage:@"royalCaninVeterinaryDiet.jpg"
                                withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/urinary-s-o-lp-18"
                  withFoodDescription:@"URINARY S/O is a complete dietetic feed for dogs formulated to dissolve struvite stones and reduce their recurrence through its urine acidifying properties, a low level of magnesium and a restricted level of protein, but of high quality.\r\n\r\nIndications: Bacterial cystitis, Dissolution of struvite uroliths & Struvite and calcium oxalate urolithiasis.\r\n\r\nContraindications: Pregnancy, Lactation, Growth, Chronic renal failure, metabolic acidosis, Pancreatitis, Hyperlipidaemia, Heart failure & Treatment with urine acidifying drugs.\r\n\r\nSTRUVITE DISSOLUTION\r\nHelps dissolve all types of struvite stones.\r\n\r\nLOW RSS\r\nHelps lower the concentration of ions contributing to crystal formation.\r\n\r\nURINE DILUTION\r\nUrine dilution makes the urine less liable to form struvite and calcium oxalate stones.\r\n\r\nLOW MAGNESIUM\r\nReduced level of magnesium, a natural component of struvite crystals.\r\n"];
          
          
          
          
     [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                           withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                              withFoodBrand:@"Royal Canin Veterinary Diets"
                              withSelectOne:@"Allergic, "
                               withFoodName:@"Hypoallergenic DR 21"
                                  withImage:@"royalCaninVeterinaryDiet.jpg"
                                withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/hypoallergenic-dr-21"
                   withFoodDescription:@"HYPOALLERGENIC is a complete dietetic feed for dogs formulated to reduce ingredient and nutrient intolerances. Selected sources of protein and carbohydrate.\r\n\r\nIndications: Food elimination trial, Food allergy, Food intolerance, Inflammatory bowel disease (IBD), Exocrine pancreatic insufficiency & Bacterial Overgrowth.\r\n\r\nContraindications: Pancreatitis, History of pancreatitis & Hyperlipidaemia.\r\n\r\nRecommendations: It is recommended that a veterinarian’s opinion be sought before use. Feed HYPOALLERGENIC for 3 to 8 weeks. If signs of intolerance disappear, this diet can be used indefinitely.\r\n\r\nHYDROLYSED PROTEIN\r\nHydrolysed protein with low molecular weight to ensure the food is hypoallergenic.\r\n\r\nSKIN BARRIER\r\nA patented complex to support the barrier effect of the skin.\r\n\r\nEPA/DHA\r\nFatty acids to help maintain a healthy digestive system and a healthy skin.\r\n\r\nDIGESTIVE HEALTH\r\nNutrients which support a balanced digestive system.\r\n"];
          
          
          
          
      [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                            withDogSize:@"Medium, Large, Giant"
                              withFoodBrand:@"Royal Canin Veterinary Diets"
                              withSelectOne:@"Oral Care"
                               withFoodName:@"Dental"
                                  withImage:@"royalCaninVeterinaryDiet.jpg"
                                withWebPage:@"http://www.royalcanin.co.uk/products/products/vet-products/canine-veterinary-diets/dental-dry"
                    withFoodDescription:@"Complete feed for adult dogs with oral sensitivity.\r\n\r\nRecommendations: Follow your vet’s nutritional recommendations\r\n- Puppies under 6 months\r\n- Pancreatitis or history of pancreatitis\r\n- Hyperlipidaemia.\r\n\r\nIndications:\r\n- Daily oral hygiene in dogs over 10 kg\r\n- Limits the development of dental plaque and tartar\r\n- Helps fight bad breath\r\n\r\nBRUSHING EFFECT\r\nThe kibble’s shape, texture and size help produce a mechanical brushing effect on teeth.\r\n\r\nTARTAR CONTROL\r\nNutrient that traps the calcium in saliva so reducing tartar deposits.\r\n\r\nBONE & JOINT SUPPORT\r\nHelps maintain healthy bones and joints.\r\n\r\nDIGESTIVE SECURITY\r\nNutrients which support a balanced digestive system.\r\n"];
          
          
     
#pragma mark - Eukanuba

    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"X-Small, Mini, "
                        withFoodBrand:@"Eukanuba"
                        withSelectOne:@"Puppy, "
                         withFoodName:@"Puppy Small Breed"
                            withImage:@"eukanuba.png"
                          withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/puppy-small-breed.jspx"
                  withFoodDescription:@"Small breed puppies burn more calories and need more energy per kg of bodyweight than larger breed puppies. This Eukanuba diet delivers The optimal levels of protein, fat and carbohydrates to meet that need. It provides all important vitamins and minerals necessary for optimal growth. Contains high-quality ingredients and high levels of animal-based protein, with chicken as the number one source.\r\n\r\n100% complete and balanced nutrition for small breed puppies, reaching an adult weight of 10kg or less.\r\n\r\nRich in Chicken\r\nAlso recommended during pregnancy and lactation.\r\n\r\n[1-12] months Days of feeding\r\n\r\nImmunoHealth\r\nSupports the immune system and promotes the daily, natural regeneration of healthy cells. Contains important antioxidants, such as vitamin E.\r\n\r\nCoatCare\r\nPromotes a thick and shiny coat, supports healthy skin and the natural healing process Contains an optimal balance of Omega-6 and Omega-3 fatty acids.\r\n\r\nDigestiCare\r\nPromotes a healthy digestive tract and effective nutrient absorption Contains a moderately fermentable fibre (beet pulp).\r\n\r\nGlucoseBalance\r\nHelps nutritionally manage normal blood sugar levels after meals Page 1 Product 148, 25 October 2007 Contains special carbohydrate sources.\r\n\r\nVitamin Levels\r\nVitamin levels guaranteed until best before date.\r\n\r\nSmarter puppy Contains DHA\r\nFor a Smart, Trainable Puppy Formulated with an optimal level of DHA, a key brain building nutrient, to support optimal hearing, vision and brain function Based on a groundbreaking study with puppies and their mothers fed Eukanuba.\r\n"];
    
    
    
     [self insertFoodProductWithDogAge:@"0-12 months, "
                           withDogSize:@"Medium, "
                         withFoodBrand:@"Eukanuba"
                         withSelectOne:@"Puppy, Pregnant or Nursing Dog, "
                          withFoodName:@"Puppy Medium Breed"
                            withImage:@"eukanuba.png"
                          withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/puppy-medium-breed.jspx"
                   withFoodDescription:@"Medium breed puppies have their own nutritional requirements. This Eukanuba diet delivers the optimal levels of protein, fat and carbohydrates to meet those requirements. It provides all important vitamins and minerals necessary for optimal growth. Contains high-quality ingredients and high levels of animal-based protein, with chicken as the number one source.\r\n\r\n100% complete and balanced nutrition for medium breed puppies, reaching an adult weight of 10-25kg.\r\n\r\nAlso recommended during pregnancy and lactation.\r\n[1-12] months\r\nRich in Chicken\r\n\r\nImmunoHealth\r\nSupports the immune system and promotes the daily, natural regeneration of healthy cells. Contains important antioxidants, such as vitamin E.\r\n\r\nCoatCare\r\nPromotes a thick and shiny coat, supports healthy skin and the natural healing process Contains an optimal balance of Omega-6 and Omega-3 fatty acids.\r\n\r\nDigestiCare\r\nPromotes a healthy digestive tract and effective nutrient absorption Contains a moderately fermentable fibre (beet pulp).\r\n\r\nGlucoseBalance\r\nHelps nutritionally manage normal blood sugar levels after meals Page 1 Product 148, 25 October 2007 Contains special carbohydrate sources.\r\n\r\nVitamin Levels\r\nVitamin levels guaranteed until best before date.\r\n\r\nSmarter puppy Contains DHA\r\nFor a Smart, Trainable Puppy Formulated with an optimal level of DHA, a key brain building nutrient, to support optimal hearing, vision and brain function Based on a groundbreaking study with puppies and their mothers fed Eukanuba.\r\n"];
    
    
    
      [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, "
                            withDogSize:@"Large, Giant"
                          withFoodBrand:@"Eukanuba"
                          withSelectOne:@"Puppy, "
                           withFoodName:@"Puppy Large Breed"
                            withImage:@"eukanuba.png"
                          withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/puppy-large-breed.jspx"
                    withFoodDescription:@"Large and giant breed puppies grow so fast and therefore have very specific nutritional requirements. This Eukanuba diet has \r\n\r\nadjusted protein, calcium and energy levels, provides all important vitamins and minerals, and supports a balanced muscular and skeletal growth of large and giant breed puppies. Contains high-quality ingredients and high levels of animal-based protein, with chicken as the number one source.\r\n\r\n100% complete and balanced nutrition for large and giant breed puppies, reaching an adult weight of 25kg or more.\r\n\r\nNOT recommended for feeding bitches during pregnancy and lactation due to the specially adjusted mineral content. [1-12] / [1-24] months\r\n\r\nRich in Chicken\r\nFlexMobility (JMS LB)\r\nHelps support healthy joints, a critical need for large breed dogs Contains glucosamine and chondroitin sulphate to promote cartilage resilience and strength.\r\n\r\nImmunoHealth\r\nSupports the immune system and promotes the daily, natural regeneration of healthy cells. Contains important antioxidants, such as vitamin E.\r\n\r\nCoatCare\r\nPromotes a thick and shiny coat, supports healthy skin and the natural healing process Contains an optimal balance of Omega-6 and Omega-3 fatty acids Page 1 Product 202, 25 October 2007.\r\n\r\nDigestiCare\r\nPromotes a healthy digestive tract and effective nutrient absorption Contains a moderately fermentable fibre (beet pulp).\r\n\r\nGlucoseBalance\r\nHelps nutritionally manage normal blood sugar levels after meals Contains special carbohydrate sources.\r\n\r\nVitamin levels\r\nVitamin levels guaranteed until best before date.\r\n\r\nSmarter puppy Contains DHA\r\nFor a Smart, Trainable Puppy Formulated with an optimal level of DHA, a key brain building nutrient, to support optimal hearing, vision and brain function Based on a groundbreaking study with puppies and their mothers fed Eukanuba.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Eukanuba"
                        withSelectOne:@"Optimal Care, Bones and Joints, Hair and Skin, Stomach, Oral Care, "
                         withFoodName:@"Healthy Extras Puppy & Junior"
                            withImage:@"eukanuba.png"
                          withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/healthy-extras-puppy-junior-all-breeds.jspx"
                  withFoodDescription:@"For puppies all breeds.\r\n\r\n1 to 12 months.\r\n\r\nA complementary pet food for puppies. No artificial flavourings or colourants added. Eukanuba Healthy Extras help support total body health and are specifically tailored for your puppy. They help provide key nutrients in six performance areas (Bones & Muscles, Heart, Skin & Coat, Digestion, Teeth, Immune System) and your dog will love the great taste. Biscuits are designed as an additional food source, 2-4 biscuits a day in combination with Eukanuba dog food will deliver the benefits.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Eukanuba"
                        withSelectOne:@"Optimal Care, Bones and Joints, Hair and Skin, Stomach, Oral Care, "
                         withFoodName:@"Healthy Extras Adult"
                            withImage:@"eukanuba.png"
                          withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/healthy-extras-adult-all-breeds.jspx"
                  withFoodDescription:@"Adult all Breeds.\r\n\r\n1 + years.\r\n\r\nA complementary pet food adults dogs. No artificial flavourings or colourant added.Eukanuba Healthy Extras help support total body health and are specifically tailored for your adult dog. They help provide key nutrients in six performance areas (Bones & Muscles, Heart, Skin & Coat, Digestion, Teeth, Immune System) and your dog will love the great taste. Biscuits are designed as an additional food source, 2-4 biscuits a day in combination with Eukanuba dog food will deliver the benefits.\r\n"];
    
    
    
     [self insertFoodProductWithDogAge:@"+6 years"
                           withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                         withFoodBrand:@"Eukanuba"
                         withSelectOne:@"Optimal Care, Bones and Joints, Hair and Skin, Stomach, Oral Care, "
                          withFoodName:@"Healthy Extras Mature & Senior"
                            withImage:@"eukanuba.png"
                          withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/healthy-extras-mature-senior-all-breeds.jspx"
                   withFoodDescription:@"Mature & Seniors all Breeds.\r\n\r\n7 + years.\r\n\r\nA complementary pet food for ageing dogs. No artificial flavourings or colourants added. Eukanuba Healthy Extras help support total body health and are specifically tailored for your ageing dog. They help provide key nutrients in six performance areas (Bones & Muscles, Heart, Skin & Coat, Digestion, Teeth, Immune System) and your dog will love the great taste. Biscuits are designed as an additional food source, 2-4 biscuits a day in combination with Eukanuba dog food will deliver the benefits.\r\n"];
    
    
    
       [self insertFoodProductWithDogAge:@"+6 years"
                             withDogSize:@"X-Small, Mini, Medium, "
                        withFoodBrand:@"Eukanuba"
                        withSelectOne:@"Optimal Care, "
                         withFoodName:@"Mature & Senior Small & Medium Breed"
                            withImage:@"eukanuba.png"
                          withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/mature-senior-small-medium-breed.jspx"
                     withFoodDescription:@"This Eukanuba diet is formulated to address the special nutritional needs of mature and senior small or medium breed dogs - like immune health, joint health, weight control, and dental health. Eukanuba provides the optimal daily amount of protein, fat, carbohydrates, important vitamins and minerals for the health and well-being of your dog. Contains high-quality ingredients and high levels of animal-based protein.\r\n\r\n100% complete and balanced nutrition for mature and senior small and medium breed dogs - up to 25 kg - 7+ years.\r\n\r\n7+ years Days of feeding\r\n\r\nImmunoHealth\r\nSupports the immune system and promotes the daily, natural regeneration of healthy cells. Contains important antioxidants, such as vitamin E.\r\n\r\n FlexMobility (M small-Medium)\r\nHelps support healthy joints, a critical need for ageing dogs Contains glucosamine and chondroitin sulphate to promote cartilage resilience and strength.\r\n\r\nWeightControl\r\nHelps manage weight loss and maintenance Contains reduced fat levels and L-carnitine, to help burn fat and maintain lean muscle mass.\r\n\r\nCoatCare+\r\nPromotes a thick and shiny coat, supports healthy skin and the natural healing process Contains gamma-linolenic acid (GLA) and an optimal balance of Omega-6 and Omega-3 fatty acids.\r\n\r\nDigestiCare+\r\nPromotes a healthy digestive tract, intestinal environment and excellent nutrient absorption Contains an exclusive formulation of fermentable fibres (beet pulp + FOS).\r\n\r\nGlucoseBalance\r\nHelps nutritionally manage normal blood sugar levels after meals Contains special carbohydrate sources.\r\n\r\nDental Care (Tartar)\r\nPromotes healthy teeth by reducing tartar build-up Crunchy kibbles help remove plaque and a special combination of minerals helps keep tartar-forming materials from depositing on the teeth.\r\n\r\nVitamin Levels\r\nVitamin levels guaranteed until best before date.\r\n\r\nHealthy Joints\r\nSupports Healthy Joints.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"2-6 years, +6 years, "
                          withDogSize:@"Large, Giant, "
                        withFoodBrand:@"Eukanuba"
                        withSelectOne:@"Optimal Care, "
                         withFoodName:@"Mature & Senior Large Breed"
                            withImage:@"eukanuba.png"
                          withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/mature-senior-large-breed.jspx"
                  withFoodDescription:@"Rich in Chicken.\r\n\r\nThis Eukanuba diet is formulated to address the special nutritional needs of mature and senior large breed dogs - like immune health, joint health, weight control, and dental health. Eukanuba provides the optimal daily amount of protein, fat, carbohydrates, important vitamins and minerals for the health and well-being of your dog. Contains high-quality ingredients and high levels of animal-based protein.\r\n\r\n100% complete and balanced nutrition for mature and senior large (25 - 40kg: 6+ years) and giant breed dogs (>40kg: 5+ years).\r\n\r\n5+ years Days of feeding\r\n\r\nImmunoHealth\r\nSupports the immune system and promotes the daily, natural regeneration of healthy cells.Contains important antioxidants, such as vitamin E.\r\n\r\nFlexMobility (JMS mat/sen)\r\nHelps support healthy joints, a critical need for ageing and large breed dogs contains glucosamine and chondroitin sulphate to promote cartilage resilience and strength.\r\n\r\nWeightControl\r\nHelps manage weight loss and maintenance contains reduced fat levels and L-carnitine, to help burn fat and maintain lean muscle mass.\r\n\r\nCoatCare+\r\nPromotes a thick and shiny coat, supports healthy skin and the natural healing process contains gamma-linolenic acid (GLA) and an optimal balance of Omega-6 and Omega-3 fatty acids.\r\n\r\nDigestiCare+\r\nPromotes a healthy digestive tract, intestinal environment and excellent nutrient absorption contains an exclusive formulation of fermentable fibres (beet pulp + FOS).\r\n\r\nGlucoseBalance\r\nHelps nutritionally manage normal blood sugar levels after meals contains special carbohydrate sources.\r\n\r\nDental Care (Tartar)\r\nPromotes healthy teeth by reducing tartar build-up.Crunchy kibbles help remove plaque and a special combination of minerals helps keep tartar-forming materials from depositing on the teeth.\r\n\r\nVitamin Levels\r\nVitamin levels guaranteed until best before date.\r\n\r\nHealthy Joints\r\nSupports Healthy Joints\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"+6 years, "
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Eukanuba"
                        withSelectOne:@"Optimal Care, "
                         withFoodName:@"Adult Mature & Senior All Breeds"
                            withImage:@"eukanuba.png"
                          withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/adult-mature-senior-all-breeds-rich-in-lamb-rice.jspx"
                  withFoodDescription:@"Lamb meat represents a highly digestible nutrition, even suitable for sensitive dogs. Eukanuba provides the optimal daily amount of protein, fat, carbohydrates, important vitamins and minerals for the health and well-being of your dog. Contains high-quality ingredients and high levels of animal-based protein.\r\n\r\n100% complete and balanced nutrition for mature and senior dogs of all breeds preferring a lamb meat diet, for easy digestion and excellent skin and coat condition.\r\n\r\n[7+] years Days of feeding Maintenance.\r\n\r\nImmunoHealth\r\nSupports the immune system and promotes the daily, natural regeneration of healthy cells. Contains important antioxidants, such as vitamin E.\r\n\r\nFlexMobility (JMS mat/sen)\r\nHelps support healthy joints, a critical need for ageing and large breed dogs Contains glucosamine and chondroitin sulphate to promote cartilage resilience and strength.\r\n\r\nWeightControl\r\nHelps manage weight loss and maintenance Contains reduced fat levels and L-carnitine, to help burn fat and maintain lean muscle mass.\r\n\r\nCoatCare+\r\nPromotes a thick and shiny coat, supports healthy skin and the natural healing process Contains gamma-linolenic acid (GLA) and an optimal balance of Omega-6 and Omega-3 fatty acids.\r\n\r\nDigestiCare+\r\nPromotes a healthy digestive tract, intestinal environment and excellent nutrient absorption Contains an exclusive formulation of fermentable fibres (beet pulp + FOS).\r\n\r\nDental Care (Tartar)\r\nPromotes healthy teeth by reducing tartar build-up Crunchy kibbles help remove plaque and a special combination of minerals helps keep tartar-forming materials from depositing on the teeth.\r\n\r\nVitamin Levels\r\nVitamin levels guaranteed until best before date.\r\n\r\nHealthy Joints\r\nSupports Healthy Joints\r\n"];
    
    
    
       [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                             withDogSize:@"X-Small, Mini, "
                           withFoodBrand:@"Eukanuba"
                           withSelectOne:@"Optimal Care, "
                            withFoodName:@"Adult Small Breed"
                               withImage:@"eukanuba.png"
                             withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/adult-small-breed.jspx"
                     withFoodDescription:@"Rich in Chicken.\r\n\r\nWith smaller kibbles for easy chewing and digestion. Eukanuba provides the optimal daily amount of protein, fat, carbohydrates, important vitamins and minerals for the health and well-being of your dog. Contains high-quality ingredients and high levels of animal-based protein. 100% complete and balanced nutrition for small breed adult dogs with an average activity level and normal weight.\r\n\r\n1+ years\r\nDays of feeding\r\n\r\nDental Care (Tartar)\r\nPromotes healthy teeth by reducing tartar build-up Crunchy kibbles help remove plaque and a special combination of minerals helps keep tartar-forming materials from depositing on the teeth.\r\n\r\nImmunoHealth\r\nSupports the immune system and promotes the daily, natural regeneration of healthy cells. Contains important antioxidants, such as vitamin E.\r\n\r\nCoatCare\r\nPromotes a thick and shiny coat, supports healthy skin and the natural healing process Contains an optimal balance of Omega-6 and Omega-3 fatty acids.\r\n\r\nDigestiCare\r\nPromotes a healthy digestive tract and effective nutrient absorption Contains a moderately fermentable fibre (beet pulp).\r\n\r\nGlucoseBalance\r\nHelps nutritionally manage normal blood sugar levels after meals Contains special carbohydrate sources.\r\n\r\nVitamin levels\r\nVitamin levels guaranteed until best before date.\r\n"];
       
       
       [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                             withDogSize:@"Medium"
                           withFoodBrand:@"Eukanuba"
                           withSelectOne:@"Optimal Care, "
                            withFoodName:@"Adult Medium Breed"
                               withImage:@"eukanuba.png"
                             withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/adult-medium-breed.jspx"
                     withFoodDescription:@"Rich in Chicken.\r\n\r\nEukanuba provides the optimal daily amount of protein, fat, carbohydrates, important vitamins and minerals for the health and well-being of your dog. Contains high-quality ingredients and high levels of animal-based protein. 100% complete and balanced nutrition for medium breed adult dogs with an average activity level and normal weight.\r\n\r\n1+ years Days of feeding.\r\n\r\nDental Care (Tartar)\r\nPromotes healthy teeth by reducing tartar build-up Crunchy kibbles help remove plaque and a special combination of minerals helps keep tartar-forming materials from depositing on the teeth.\r\n\r\nImmunoHealth\r\nSupports the immune system and promotes the daily, natural regeneration of healthy cells. ContainsPromotes a thick and shiny coat, supports healthy skin and the natural healing process Contains an optimal balance of Omega-6 and Omega-3 fatty acids.\r\n\r\nDigestiCare\r\nPromotes a healthy digestive tract and effective nutrient absorption Contains a moderately fermentable fibre (beet pulp).\r\n\r\nGlucoseBalance\r\nHelps nutritionally manage normal blood sugar levels after meals Contains special carbohydrate sources.\r\n\r\nVitamin Levels\r\nVitamin levels guaranteed until best before date.\r\n"];
       
       
       [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                             withDogSize:@"Large, Giant"
                           withFoodBrand:@"Eukanuba"
                           withSelectOne:@"Optimal Care, "
                            withFoodName:@"Adult Large Breed"
                               withImage:@"eukanuba.png"
                             withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/adult-large-breed.jspx"
                     withFoodDescription:@"Rich in Chicken.\r\n\r\nEukanuba provides the optimal daily amount of protein, fat, carbohydrates, important vitamins and minerals for the health and well-being of your dog. This diet specially includes FlexMobility (Joint Management System) to nutritionally support healthy joint cartilage and a reduced fat level to help maintain optimal weight and minimise joint stress. Contains high-quality ingredients and high levels of animal-based protein, with chicken as the number one source.\r\n\r\n100% complete and balanced nutrition for large and giant breed adult dogs with an average activity level and normal weight.\r\n\r\n[1+] / [2+] years Days of feeding.\r\n\r\nDental Care (Tartar)\r\nPromotes healthy teeth by reducing tartar build-up Crunchy kibbles help remove plaque and a special combination of minerals helps keep tartar-forming materials from depositing on the teeth.\r\n\r\nFlexMobility (JMS LB)\r\nHelps support healthy joints, a critical need for large breed dogs Contains glucosamine and chondroitin sulphate to promote cartilage resilience and strength.\r\n\r\nImmunoHealth\r\nSupports the immune system and promotes the daily, natural regeneration of healthy cells. Contains important antioxidants, such as vitamin E.\r\n\r\nCoatCare\r\nPromotes a thick and shiny coat, supports healthy skin and the natural healing process Contains an optimal balance of Omega-6 and Omega-3 fatty acids.\r\n\r\nDigestiCare\r\nPromotes a healthy digestive tract and effective nutrient absorption Contains a moderately fermentable fibre (beet pulp).\r\n\r\nGlucoseBalance\r\nHelps nutritionally manage normal blood sugar levels after meals Contains special carbohydrate sources.\r\n\r\nVitamin Levels\r\nVitamin levels guaranteed until best before date.\r\n"];
       
       
       [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                             withDogSize:@"X-Small, Mini, Medium, "
                           withFoodBrand:@"Eukanuba"
                           withSelectOne:@"Optimal Care, "
                            withFoodName:@"Adult Small & Medium Lamb & Rice"
                               withImage:@"eukanuba.png"
                             withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/adult-small-medium-breed-rich-in-lamb-rice.jspx"
                     withFoodDescription:@"Rich in Lamb & Rice.\r\n\r\nLamb meat represents a highly digestible nutrition, even suitable for sensitive dogs. Eukanuba provides the optimal daily amount of protein, fat, carbohydrates, important vitamins and minerals for the health and well-being of your dog. Contains high-quality ingredients and high levels of animal-based protein.\r\n\r\n100% complete and balanced nutrition for small and medium breed adult dogs preferring a lamb meat diet, for easy digestion and excellent skin and coat condition.\r\n\r\n1+ years Days of feeding.\r\n\r\nDental Care (Tartar)\r\nPromotes healthy teeth by reducing tartar build-up.Crunchy kibbles help remove plaque and a special combination of minerals helps keep tartar-forming materials from depositing on the teeth.\r\n\r\nImmunoHealth\r\nSupports the immune system and promotes the daily, natural regeneration of healthy cells. Contains important antioxidants, such as vitamin E.\r\n\r\nCoatCare\r\nPromotes a thick and shiny coat, supports healthy skin and the natural healing process Contains an optimal balance of Omega-6 and Omega-3 fatty acids.\r\n\r\nDigestiCare\r\nPromotes a healthy digestive tract and effective nutrient absorption Contains a moderately fermentable fibre (beet pulp).\r\n\r\nVitamin levels\r\nVitamin levels guaranteed until best before date.\r\n"];
       
       
       [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                             withDogSize:@"Large, Giant"
                           withFoodBrand:@"Eukanuba"
                           withSelectOne:@"Optimal Care, "
                            withFoodName:@"Adult Large Lamb & Rice"
                               withImage:@"eukanuba.png"
                             withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/adult-large-breed-rich-in-lamb-rice.jspx"
                     withFoodDescription:@"Lamb meat represents a highly digestible nutrition, even suitable for sensitive dogs. Eukanuba provides the optimal daily amount of protein, fat, carbohydrates, important vitamins and minerals for the health and well-being of your dog. This diet specially includes FlexMobility (Joint Management System) to nutritionally support healthy joint cartilage and a reduced fat level to help maintain optimal weight and minimise joint stress. Contains high-quality ingredients and high levels of animal-based protein.\r\n\r\n100% complete and balanced nutrition for large and giant breed adult dogs with an average activity level and normal weight.\r\n\r\n[1+] / [2+] years Days of feeding.\r\n\r\nDental Care (Tartar)\r\nPromotes healthy teeth by reducing tartar build-up Crunchy kibbles help remove plaque and a special combination of minerals helps keep tartar-forming materials from depositing on the teeth.\r\n\r\nFlexMobility (JMS LB)\r\nHelps support healthy joints, a critical need for large breed dogs Contains glucosamine and chondroitin sulphate to promote cartilage resilience and strength.\r\n\r\nImmunoHealth\r\nSupports the immune system and promotes the daily, natural regeneration of healthy cells. Contains important antioxidants, such as vitamin E.\r\n\r\nCoatCare\r\nPromotes a thick and shiny coat, supports healthy skin and the natural healing process Contains an optimal balance of Omega-6 and Omega-3 fatty acids.\r\n\r\nDigestiCare\r\nPromotes a healthy digestive tract and effective nutrient absorption Contains a moderately fermentable fibre (beet pulp).\r\n\r\nVitamin Levels\r\nVitamin levels guaranteed until best before date.\r\n"];
       
       
        [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                              withDogSize:@"Large, Giant"
                           withFoodBrand:@"Eukanuba"
                           withSelectOne:@"Optimal Care, Ideal Weight"
                            withFoodName:@"Adult Large Breed Weight Control"
                               withImage:@"eukanuba.png"
                             withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/adult-large-breed-weight-control.jspx"
                      withFoodDescription:@"Eukanuba provides the optimal daily amount of protein, carbohydrates, important vitamins and minerals for the health and well-being of your dog. This diet has a reduced fat level to help maintain optimal weight and minimise joint stress. Certain fats have been replaced with lower calorie carbohydrates without losing any nutritional value. Specially includes FlexMobility (Joint Management System) to nutritionally support healthy joint cartilage. Contains high-quality ingredients and high levels of animal-based protein.\r\n\r\n100% complete and balanced nutrition for large and giant breed adult dogs that are overweight or have a lower activity level.\r\n\r\n[1+] /[2+] years Days of feeding.\r\n\r\nDental Care (Tartar)\r\nPromotes healthy teeth by reducing tartar build-up Crunchy kibbles help remove plaque and a special combination of minerals helps keep tartar-forming materials from depositing on the teeth.\r\n\r\nFlexMobility (JMS LB)\r\nHelps support healthy joints, a critical need for large breed dogs Contains glucosamine and chondroitin sulphate to promote cartilage resilience and strength.\r\n\r\nWeightControl\r\nHelps manage weight loss and maintenance Contains reduced fat levels and L-carnitine, to help burn fat and maintain lean muscle mass.\r\n\r\nImmunoHealth\r\nSupports the immune system and promotes the daily, natural regeneration of healthy cells. Contains important antioxidants, such as vitamin E.\r\n\r\nCoatCare\r\nPromotes a thick and shiny coat, supports healthy skin and the natural healing process Contains an optimal balance of Omega-6 and Omega-3 fatty acids.\r\n\r\nDigestiCare\r\nPromotes a healthy digestive tract and effective nutrient absorption Contains a moderately fermentable fibre (beet pulp).\r\n\r\nGlucoseBalance\r\nHelps nutritionally manage normal blood sugar levels after meals Contains special carbohydrate sources.\r\n\r\nVitamin Levels\r\nVitamin levels guaranteed until best before date.\r\n"];
       
       
       [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                             withDogSize:@"X-Small, Mini, Medium, "
                           withFoodBrand:@"Eukanuba"
                           withSelectOne:@"Optimal Care, Ideal Weight"
                            withFoodName:@"Adult Small & Medium Weight Control"
                               withImage:@"eukanuba.png"
                             withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/adult-small-medium-weight-control.jspx"
                     withFoodDescription:@"Rich in Chicken.\r\n\r\nThis Eukanuba diet has a reduced fat level and provides the optimal daily amount of protein, carbohydrates, important vitamins and minerals for the health and well-being of your dog. Certain fats have been replaced with lower calorie carbohydrates without losing any nutritional value. Contains high-quality ingredients and high levels of animal-based protein. 100% complete and balanced nutrition for small and medium breed adult dogs that are overweight or have a lower activity level.\r\n\r\n1+ years Days of feeding.\r\n\r\nDental Care (Tartar)\r\nPromotes healthy teeth by reducing tartar build-up Crunchy kibbles help remove plaque and a special combination of minerals helps keep tartar-forming materials from depositing on the teeth.\r\n\r\nWeightControl\r\nHelps manage weight loss and maintenance Contains reduced fat levels and L-carnitine, to help burn fat and maintain lean muscle mass.\r\n\r\nImmunoHealth\r\nSupports the immune system and promotes the daily, natural regeneration of healthy cells. Contains important antioxidants, such as vitamin E.\r\n\r\nCoatCare\r\nPromotes a thick and shiny coat, supports healthy skin and the natural healing process Contains an optimal balance of Omega-6 and Omega-3 fatty acids.\r\n\r\nDigestiCare\r\nPromotes a healthy digestive tract and effective nutrient absorption Contains a moderately fermentable fibre (beet pulp)\r\n\r\nGlucoseBalance\r\nHelps nutritionally manage normal blood sugar levels after meals Contains special carbohydrate sources.\r\n\r\nVitamin Levels\r\nVitamin levels guaranteed until best before date.\r\n"];
       
       
        
        
        
        
        
#pragma mark - Eukanuba Breed-Specific
     
        
       
       
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, "
                           withFoodBrand:@"Eukanuba Breed-Specific"
                           withSelectOne:@"Labrador Retriever, Chesapeake Bay Retrievers, Curly Coated Retriever"
                            withFoodName:@"Labrador Retriever"
                               withImage:@"eukanuba.png"
                             withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/eukanuba-labrador-retriever.jspx"
                  withFoodDescription:@"Labrador Retrievers are an extremely popular choice of dog; they are both gentle and affectionate. If they do not exercise regularly they can gain weight easily and excess weight can put stress on their joints meaning they can benefit from extra nutritional care.\r\n\r\nEukanuba Labrador Retriever is a complete and balanced daily food designed to keep the joints healthy and help to control their weight for overall good health.\r\n\r\nEukanuba Labrador Retriever is made with:\r\n-Cartilage nutrient for healthy joints\r\n-L-Carnitine for optimal weight\r\n-Omega-3 and Omega-6, zinc and copper for optimal skin and coat care\r\n-Vitamin E to support the immune system\r\n\r\nAlso suitable for Curly coated and Chesapeake Bay Retrievers, who share the same nutritional needs.\r\n"];
       
       
       
       
       
       [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                             withDogSize:@"Large, "
                           withFoodBrand:@"Eukanuba Breed-Specific"
                           withSelectOne:@"Golden Retriever, Flat-Coated Retriever, Portuguese Water Dog, Irish Water Spaniel, Italian Spinone, "
                            withFoodName:@"Golden Retriever"
                               withImage:@"eukanuba.png"
                             withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/eukanuba-golden-retriever.jspx"
                     withFoodDescription:@"Golden Retrievers are friendly and intelligent dogs, well-mannered, with great charm. They need essential nutrients for a superb coat and the digestion can benefit from prebiotic fibres. Regular exercise helps maintain optimal body conditions.\r\n\r\nEukanuba Golden Retriever is a complete and balanced daily food designed to keep his coat shiny and support healthy joints and stable digestion.\r\n\r\nEukanuba Golden Retriever is made with:\r\n-High level of protein and omega-3 and omega-6 for skin and coat care\r\n-Cartilage nutrients + L-carnitine for healthy joints and optimal weight\r\n-A blend of special dietary fibre with prebiotics helps promote healthy digestion and nutrient absorption\r\n-Vitamin E to support the immune system\r\n\r\nAlso suitable for Flat coated Retriever, Portuguese Water Dog, Irish Water Spaniel, Italian Spinone, who share the same nutritional needs.\r\n"];
       
       
       
       
       
       [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                             withDogSize:@"Large, "
                           withFoodBrand:@"Eukanuba Breed-Specific"
                           withSelectOne:@"German Shepherd, Belgian Shepherds, "
                            withFoodName:@"German Shepherd"
                               withImage:@"eukanuba.png"
                             withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/german-shepherd.jspx"
                     withFoodDescription:@"German Shepherds are lively and alert large breed dogs that are always keen to please their owner. In order to maintain good digestion and long term agility they may benefit from special nutritional care.\r\n\r\nEukanuba German Shepherd is a complete and balanced daily food designed to promote healthy digestion, firm stools and long term agility.\r\n\r\nEukanuba German Shepherd is made with:\r\n-A blend of special dietary fibres to promote healthy digestion and nutrient absorption\r\n-Cartilage nutrients such as glucosamine and chondroitin sulphate for healthy joints and mobility\r\n-L-carnitine to help naturally burn fat instead of storing it\r\n-Omega-6;3 fatty acids, zinc + copper for optimal skin and coat care\r\n\r\nAlso suitable for Belgian Shepherds, who share the same nutritional needs.\r\n"];
       
       
       
       
       
       [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                             withDogSize:@"Mini, "
                           withFoodBrand:@"Eukanuba Breed-Specific"
                           withSelectOne:@"West Highland White Terrier, Cairn Terriers, Scottish Terriers"
                            withFoodName:@"West Highland White Terrier"
                               withImage:@"eukanuba.png"
                             withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/west-highland-white-terrier.jspx"
                     withFoodDescription:@"West Highland White Terrier are friendly, confident dogs that thrive on a lot of attention. In order to be in best condition their weight must be controlled. Their sensitive skin may benefit from special nutritional care. Eukanuba West Highland White Terrier is a complete and balanced daily food designed to support healthy skin and help manage their weight.\r\n\r\nEukanuba West Highland White Terriers is made with:\r\n-Skin nutrients such as zinc, copper and increased omega-3 fatty acids\r\n-Reduced calories and L-carnitine, a natural fat burner, to manage weight\r\n-Vitamin E to support the immune system\r\n-Highly digestible ingredients and natural fibre for healthy digestion\r\n\r\nAlso suitable for Cairn Terriers and Scottish Terriers, who share the same nutritional needs.\r\n"];
       
       
    
       
       
       
       [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                             withDogSize:@"Large, Giant, "
                           withFoodBrand:@"Eukanuba Breed-Specific"
                           withSelectOne:@"Rottweiler, French Mastiff, Cane Corso, Rhodesian Ridgeback"
                            withFoodName:@"Rottweiler"
                               withImage:@"eukanuba.png"
                             withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/rottweiler.jspx"
                     withFoodDescription:@"Rottweilers are powerfully built and well proportioned dogs that are admired for their loyalty and stoic nature. Being a large breed dog, their joints carry a lot of weight and this may benefit from tailored nutritional care. Their digestive system can also require extra attention.\r\n\r\nEukanuba Rottweiler is a complete and balanced daily food to support their joints, maintain optimal weight and promote healthy digestion.\r\n\r\nEukanuba Rottweiler is made with:\r\n-Cartilage nutrients, such as glucosamine and chondroitin sulphate for healthy joints and mobility\r\n-Only 13% fat + L-carnitine to promote lean muscle and optimal weight control.\r\n-Natural fibre for healthy digestion and optimal absorption of nutrients\r\n-Omega-3 and omega-6, zinc + copper for optimal skin and coat care\r\n\r\nAlso suitable for French Mastiff, Cane Corso and Rhodesian Ridgeback who share the same nutritional needs\r\n"];
       
       
       
       
       
       [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                             withDogSize:@"Medium, "
                           withFoodBrand:@"Eukanuba Breed-Specific"
                           withSelectOne:@"Cocker Spaniel, English Springer Spaniels and American Cocker Spaniels, "
                            withFoodName:@"Cocker Spaniel"
                               withImage:@"eukanuba.png"
                             withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/cocker-spaniel.jspx"
                     withFoodDescription:@"The Cocker Spaniel is an elegant breed renowned for his pleasant attitude and a happy wagging tail. In order to maintain weight control and support a healthy skin they can benefit from tailored nutritional care. Eukanuba Cocker Spaniel is a complete and balanced daily food designed to help manage weight, promote healthy skin and a luxurious coat.\r\n\r\nEukanuba Cocker Spaniel is made with:\r\n-Skin nutrients such as zinc and copper and increased omega-3 fatty acids\r\n-Cartilage nutrients such as glucosamine and chondroitin sulphate for healthy joints and mobility\r\n-Reduced calories + L-carnitine to manage weight for optimal body condition\r\n-Natural fibre for a healthy digestion\r\n\r\nAlso suitable for English Springer Spaniels and American Cocker Spaniels, who share the same nutritional needs.\r\n"];
       
       
       
       
       
       [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                             withDogSize:@"Medium, "
                           withFoodBrand:@"Eukanuba Breed-Specific"
                           withSelectOne:@"Boxer, English Setters, Irish Setters, Gordon Setters, Doberman Pinschers"
                            withFoodName:@"Boxer"
                               withImage:@"eukanuba.png"
                             withWebPage:@"http://breeders.eukanuba.co.uk/products/breed-nutrition-boxer-also-ideal-doberman-pinschers-english-setters"
                     withFoodDescription:@"Boxers are athletic, energetic and active dogs, with a loyal temperament. In order to maintain a healthy heart and immune system they may benefit from special nutritional care.\r\n\r\nEukanuba Boxer is a complete and balanced daily food designed to help keep a Boxer's heart healthy and to support the strength of their immune system to keep them healthy and active.\r\n\r\nEukanuba Boxer is made with:\r\n-Naturally rich in taurine + L-carnitine to support a healthy heart\r\n-Cartilage nutrients such as glucosamine and chondroitin sulphate for healthy joints and mobility\r\n-Antioxidants such as Vitamin E and ;-carotene to support the immune system\r\n-Highly digestible ingredients + natural dietary fibre to promote healthy digestion. \r\n\r\nAlso suitable for English, Irish & Gordon Setters and Doberman Pinschers, who share the same nutritional needs.\r\n"];
       
       
       
       
       
       [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                             withDogSize:@"Mini"
                           withFoodBrand:@"Eukanuba Breed-Specific"
                           withSelectOne:@"Jack Russell, Parson Russell, Fox Terrier, Border Terrier"
                            withFoodName:@"Jack Russell"
                               withImage:@"eukanuba.png"
                             withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/jack-russell.jspx"
                     withFoodDescription:@"Jack Russell Terriers are small, compact athletic dogs, playful and full of energy but also fearless, admired for their independence and courage. They are very active and will be happy with space to run, hunt and play. Like other small breed dogs they may be prone to have dental problems and therefore benefit from tailored nutrition.\r\n\r\nEukanuba Jack Russell Terrier is a complete and balanced daily food designed to support an active life style, promote joint health and mobility and help keep their small mouth healthy.\r\n\r\nEukanuba Jack Russell Terrier contains:\r\n-High quality animal protein and L-carnitine for good muscle tone and peak body condition\r\n-Special kibble coating to help reduce tartar formation\r\n-Natural and prebiotic fibre to promote healthy digestion\r\n-Vitamin E to support the immune system\r\n\r\nAlso suitable for Parson Russell, Fox & Border Terriers, who share the same nutritional needs.\r\n"];
       
       

       
       
#pragma mark - Eukanuba Daily Care
   
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Eukanuba Daily Care"
                        withSelectOne:@"Overweight, Sterilised, Neutered, "
                         withFoodName:@"Overweight Sterilized Dogs"
                            withImage:@"eukanuba.png"
                          withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/eukanuba-daily-care-overweight-sterilized-dogs.jspx"
                  withFoodDescription:@"DAILY CARE FOR ADULT DOGS THAT ARE OVERWEIGHT, STERILIZED\r\n100% COMPLETE AND BALANCED DOG NUTRITION\r\n\r\nEveryone knows the yo-yo effect of dieting. People change their diet to lose weight. Then, when they reach the ideal weight, they go back to the old nutrition habits and put the weight back on!!\r\nTo maintain a healthy weight you need to stick to your winning habits.\r\n\r\nDAILY CARE FOR OVERWEIGHT, STERILIZED DOGS follows the same principle. Dogs are prone to gain weight after sterilization as hormone levels change. Follow our feeding guidelines to first help your dog lose weight, then, keep exercising your dog and keep feeding Daily Care for Overweight, Sterilized Dogs as his daily diet to maintain optimal weight.\r\n\r\nDaily Care for Overweight, Sterilized Dogs is a complete and balanced everyday diet for sterilised dogs that includes the essential vitamins and minerals your dog needs.\r\n\r\nDaily Care Overweight, Sterilized Dogs is a complete and balanced everyday diet for sterilized dogs prone to gaining weight. It includes:\r\nLOW CALORIES*\r\nL-CARNITINE A NATURAL FAT BURNER\r\nOPTIMAL LEVELS OF NATURAL FIBRE\r\n\r\n* Compared to Eukanuba Adult Maintenance diet\r\nNO ARTIFICIAL FLAVOURINGS ADDED\r\nNO ARTIFICIAL PRESERVATIVES ADDED\r\nNO ARTIFICIAL COLOURANTS ADDED\r\nNO FILLERS ADDED\r\n"];
     
     
    
     [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                           withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Eukanuba Daily Care"
                        withSelectOne:@"Bones and Joints"
                         withFoodName:@"Sensitive Joints"
                            withImage:@"eukanuba.png"
                          withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/eukanuba-daily-care-sensitive-joints.jspx"
                  withFoodDescription:@"DAILY CARE FOR ADULT DOGS WITH SENSITIVE JOINTS\r\n100% COMPLETE AND BALANCED DOG NUTRITION\r\n\r\nIf you had a joint problem and a change in diet helped manage it, would you go back to your previous diet? Most likely not.\r\n\r\nDAILY CARE FOR SENSITIVE JOINTS follows the same principle. It is a complete and balanced everyday diet for dogs with a predisposition to stiff joints. It has natural fish oils to help support healthy joints, natural cartilage nutrients for flexible joints, essential vitamins and minerals your dog needs to help him stay active and low calories for proper weight management.\r\nKeep feeding this carefully designed nutrition to make sure your dog is getting all the care he needs especially with breeds that are prone to joint sensitivities. Maintain the diet that agrees with your dog!\r\n\r\nDaily Care Sensitive Joints is a complete and balanced everyday diet for dogs with predisposition to stiff joints. It includes:\r\nLOWER FAT LEVELS*\r\nNATURAL FISH OILS\r\nNATURAL CARTILAGE NUTRIENTS\r\n\r\n* Compared to Eukanuba Adult Maintenance diet\r\nNO ARTIFICIAL FLAVOURINGS ADDED\r\nNO ARTIFICIAL PRESERVATIVES ADDED\r\nNO ARTIFICIAL COLOURANTS ADDED\r\nNO FILLERS ADDED\r\n"];
     
     
    
      [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                            withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Eukanuba Daily Care"
                        withSelectOne:@"Stomach, "
                         withFoodName:@"Sensitive Digestion"
                            withImage:@"eukanuba.png"
                          withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/eukanuba-daily-care-sensitive-digestion.jspx"
                    withFoodDescription:@"DAILY CARE FOR ADULT DOGS WITH SENSITIVE DIGESTION\r\n100% COMPLETE AND BALANCED DOG NUTRITION\r\n\r\nIf you had sensitive digestion and a change in diet helped manage it would you go back to your previous diet? Most likely not.\r\n\r\nDAILY CARE FOR SENSITIVE DIGESTION follows the same principle. First feed your dog this diet to help support a balanced digestion system, then keep feeding this carefully designed Daily Care for Sensitive Digestion diet even when his digestion is balanced. Maintain the diet that agrees with your dog rather than feeding the old diet.\r\nDaily Care for Sensitive Digestion is a complete and balanced everyday diet for dogs with sensitive digestion that includes the essential vitamins and minerals your dog needs.\r\n\r\nDaily Care Sensitive Digestion is a complete and balanced everyday diet for dogs with sensitive digestion. It includes:\r\nPREBIOTIC FIBRE\r\nEASY TO DIGEST RICE\r\nNATURAL BEET PULP\r\n\r\nNO ARTIFICIAL FLAVOURINGS ADDED\r\nNO ARTIFICIAL PRESERVATIVES ADDED\r\nNO ARTIFICIAL COLOURANTS ADDED\r\nNO FILLERS ADDED\r\n"];
     
     
    
       [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                             withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Eukanuba Daily Care"
                        withSelectOne:@"Hair and Skin"
                         withFoodName:@"Sensitive Skin"
                            withImage:@"eukanuba.png"
                          withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/eukanuba-daily-care-sensitive-skin.jspx"
                  withFoodDescription:@"DAILY CARE FOR ADULT DOGS WITH SENSITIVE SKIN\r\n100% COMPLETE AND BALANCED DOG NUTRITION\r\n\r\nIf you had a skin problem and a change in diet helped manage it would you go back to your previous diet? Most likely not.\r\n\r\nDAILY CARE FOR SENSITIVE SKIN follows the same principle. First, feed your dog this diet to help promote skin & coat health, then, even when his coat is brilliant and shiny, keep feeding Daily Care for Sensitive Skin to help maintain this magnificent appearance. Maintain the diet that agrees with your dog rather than feeding the old diet.\r\nDaily Care for Sensitive Skin is a complete and balanced everyday diet for dogs with sensitive skin that includes the essential vitamins and minerals your dog needs.\r\n\r\nDaily Care Sensitive Skin is a complete and balanced everyday diet for dogs with sensitive skin. It includes:\r\nFISH PROTEIN\r\nMORE OMEGA 3 FATTY ACIDS*\r\nNATURAL FISH OILS\r\n\r\n* Compared to Eukanuba Adult Maintenance diet\r\nNO ARTIFICIAL FLAVOURINGS ADDED\r\nNO ARTIFICIAL PRESERVATIVES ADDED\r\nNO ARTIFICIAL COLOURANTS ADDED\r\nNO FILLERS ADDED\r\n"];
     
     
    
        [self insertFoodProductWithDogAge:@"+6 years"
                              withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Eukanuba Daily Care"
                        withSelectOne:@"Longevity"
                         withFoodName:@"Care Senior 9+"
                            withImage:@"eukanuba.png"
                          withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/eukanuba-daily-care-senior-9.jspx"
                      withFoodDescription:@"DAILY CARE FOR ADULT DOGS THAT ARE SENIOR 9+\r\n100% COMPLETE AND BALANCED DOG NUTRITION\r\n\r\nSometimes your ageing dog seems less happy, occasionally experiencing age related conditions. Specially designed food is your ally to make him feel as good as he can be.\r\nDAILY CARE FOR SENIOR 9+ is a complete and balanced everyday diet for his age related predispositions. It has antioxidants to help maintain his immune system, prebiotic fiber for a balanced digestion and essential vitamins and minerals to get the support he needs. Keep feeding this carefully designed Daily Care for Senior 9+ nutrition. Maintain the diet that agrees with your dog!\r\n\r\nDaily Care Senior 9+ is a complete and balanced everyday diet for his age related predispositions. It includes:\r\nHIGH LEVELS OF PROTEIN\r\nANTIOXIDANTS FOR IMMUNE SYSTEM\r\nPREBIOTIC FIBRE FOR DIGESTION\r\n\r\nNO ARTIFICIAL FLAVOURINGS ADDED\r\nNO ARTIFICIAL PRESERVATIVES ADDED\r\nNO ARTIFICIAL COLOURANTS ADDED\r\nNO FILLERS ADDED\r\n"];
       
       
        
    
    
#pragma mark - Eukanuba Premium Performance
    
    
        
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Eukanuba Premium Performance"
                        withSelectOne:@"Vitality, "
                         withFoodName:@"Jogging & Agility"
                            withImage:@"eukanuba.png"
                          withWebPage:@"http://www.eukanuba.co.uk/en-UK/product/jogging-agility.jspx"
                  withFoodDescription:@"Adult 1+ years\r\n\r\nDogs enjoying regular outdoor activities with their owner such as jogging, hiking, biking and agility need more energy and daily nutrients than normal active dogs.\r\n\r\nEukanuba Jogging ; Agility is a complete and balanced food designed especially with extra nutrients to provide that extra needed energy for extra active dogs.\r\n\r\nEukanuba Jogging ; Agility is made with:\r\nIncreased* protein + fat to promote sustained energy\r\nCartilage nutrients such as glucosamine and chondroitin sulphate for healthy joints\r\nL-carnitine to promote lean muscle and burn fat\r\n*compared to Adult Maintenance Large Breed\r\n\r\nJogging & Agility\r\n\r\nFor active dogs that enjoy jogging, hiking and agility. French on back of pack\r\n\r\nIncreased* protein + fat promote sustained energy\r\nCartilage nutrients + L-carnitine for healthy joints and strong muscle\r\n*compared to Adult Maintenance Large Breed\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Eukanuba Premium Performance"
                        withSelectOne:@"Vitality, Pregnant or Nursing Dog, Anorexia, "
                         withFoodName:@"Working & Endurance"
                            withImage:@"eukanuba.png"
                          withWebPage:@""
                  withFoodDescription:@"Adult 1+ years\r\n\r\nDogs who have high levels of exercise through working and field trials need more than everyday nutrition to maintain health and stay at peak performance. The same is true for dogs that are pregnant, in lactation or those that are underweight.\r\n\r\nEukanuba Working ; Endurance is complete and balanced high quality nutrition for daily feeding. It is designed to provide sustained levels of energy and nutrients for top performance.\r\n\r\nEukanuba Working ; Endurance is made with:\r\n\r\n30 % more protein + 50 % more fat* for extra energy\r\nDual energy system for fast and sustained energy release\r\nNatural + prebiotic fibres to maintain a healthy and stable intestinal environment\r\nCartilage nutrients such as glucosamine and chondroitin sulphate to support healthy joints\r\nRich in omega-3 fatty acids for good nose and scenting ability\r\n\r\n*compared to Adult Maintenance Large Breed\r\n"];
    
    
    
    
    
    
#pragma mark - Hill's Prescription Diet

    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Allergic, "
                         withFoodName:@"z/d ULTRA Allergen-Free"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-zd-ultra-allergen-free-dry.html"
                  withFoodDescription:@"Prescription Diet™ Canine z/d™ ULTRA Allergen-Free has the following key benefits.\r\n\r\nKey Benefits\r\nHelps minimise allergic reactions to food. The unique hydrolysed formula provides a safe solution to virtually any food allergy.\r\nChicken hydrolysate is the only protein source.\r\nHelps nourish skin and coat as it is formulated with high levels of essential fatty acids.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Ideal Weight, Fibre, Diabetes, Gastrointestinal"
                         withFoodName:@"w/d with Chicken"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-wd-with-chicken-dry.html"
                  withFoodDescription:@"Prescription Diet™ Canine w/d™ has the following key benefits.\r\n\r\nKey Benefits\r\nOnce your dog has reached the ideal weight, you can help maintain it by feeding Prescription Diet weight maintenance products.\r\nLow in calories and fat to maintain your dogs ideal weight.\r\nHigh in dietary fibre to help reduce hunger and discourage begging\r\nSupplemented with L-carnitine, a vitamin that helps burn fat and preserve muscles during weight loss.\r\nNew great taste your dog will enjoy.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, "
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Ideal Weight, Fibre, Diabetes, Gastrointestinal"
                         withFoodName:@"w/d Mini with Chicken"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-wd-mini-with-chicken-dry.html"
                  withFoodDescription:@"\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Urinary, "
                         withFoodName:@"u/d"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/products/pd-canine-prescription-diet-ud-dry.html"
                  withFoodDescription:@"Prescription Diet™ Canine u/d™ was developed to aid in the management of dogs with the problems associated with urolithiasis.\r\n\r\nKey Benefits\r\nHelps reduce the formation of oxalate, urate and cystine stones.\r\nContains a low level of high-quality protein to reduce the formation of break-down products that cause discomfort in patients with kidney failure.\r\nWith reduced salt to help control fluid retention in early heart disease.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Urinary, "
                         withFoodName:@"u/d Canned"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-ud-canned.html"
                  withFoodDescription:@"For the nutritional management of pets with advanced kidney disease. Advanced kidney disease is characterised by a number of serious and even life threatening signs shown by your dog. This condition, also called kidney failure, is usually considered irreversible but may be managed with proper care and the right food. Prescription Diet™ Canine u/d™ was developed to help in the management of dogs with the problems associated with advanced kidney disease. Kidney disease causes the kidneys to be less efficient at removing waste substances from the bloodstream and regulating body fluids.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Oral Care"
                         withFoodName:@"t/d Mini"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/products/pd-canine-prescription-diet-td-mini-dry.html"
                  withFoodDescription:@"Prescription Diet™Canine t/d™ helps to maintain oral health.\r\n\r\nKey Benefits\r\nClinically proven to help reduce the build-up of tartar, plaque and stain.\r\nContains a special fibre matrix with aligned fibres that help the kibble engulf the tooth before it splits. This provides a gentle scraping action that helps reduce the build-up of plaque, tartar and stains.\r\nHelps to neutralise free radicals as it contains high level of antioxidants.\r\nWith smaller kibbles for dogs below 25 kg.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Oral Care"
                         withFoodName:@"t/d"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-td-dry.html"
                  withFoodDescription:@"Prescription Diet™Canine t/d™ helps to maintain oral health.\r\n\r\nClinically proven to help reduce the build-up of tartar, plaque and stain.\r\nContains a special fibre matrix with aligned fibres that help the kibble engulf the tooth before it splits. This provides a gentle scraping action that helps reduce the build-up of plaque, tartar and stains.\r\nHelps to neutralise free radicals as it contains high level of antioxidants.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Overweight, Ideal Weight, Fibre, "
                         withFoodName:@"r/d Mini with Chicken"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-rd-mini-with-chicken-dry.html"
                  withFoodDescription:@"\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Overweight, Ideal Weight,"
                         withFoodName:@"r/d Canned"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-rd-canned.html"
                  withFoodDescription:@"Prescription Diet™ Canine r/d™ was designed specifically for the management of weight problems in dogs.\r\n\r\nKey Benefits\r\nLow in calories and fat to help promote weight loss.\r\nHigh in dietary fibre to help reduce hunger and discourage begging.\r\nSupplemented with L-carnitine to help burn fat and preserve muscle.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months"
                          withDogSize:@"Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Puppy, Convalescent, Bones and Joints"
                         withFoodName:@"p/d Large Breed"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/products/pd-canine-prescription-diet-large-breed-dry.html"
                  withFoodDescription:@"Prescription Diet™ p/d™ is a complete pet food designed to speed up a puppies recovery from illness. (Puppies 25kg or over when adult)\r\n\r\nHelps ensure healthy bone and joint development in large breed puppies\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months"
                          withDogSize:@"Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Puppy, Convalescent, Bones and Joints"
                         withFoodName:@"p/d Canned"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-canned.html"
                  withFoodDescription:@"Prescription Diet™ p/d™ is a complete pet food designed to speed up a puppies recovery from illness.\r\n\r\nKey Benefits\r\nSupports nutritional restoration in puppies.\r\nClinically proven to aid the immune response in puppies.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Gastrointestinal, Convalescent "
                         withFoodName:@"i/d RECOVERY PACK Canned"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-id-recovery-pack-canned.html"
                  withFoodDescription:@"Prescription Diet™ Canine i/d™ is a highly digestible formula created specifically to help manage dogs with gastrointestinal disorders.\r\n\r\nKey Benefits\r\nHelps to neutralise free radicals as it contains high level of antioxidants.\r\nHighly digestible ingredients for better gastrointestinal health.\r\nProvides special fibres to help nourish the cells in the guts.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Gastrointestinal, Convalescent"
                         withFoodName:@"i/d Low Fat"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/products/pd-canine-prescription-diet-id-low-fat-dry.html"
                  withFoodDescription:@"Highly digestible, low fat food that can be fed long term to manage gastrointestinal disorders and minimize risk of recurrence.\r\nClinically proven to help digestive tract recovery.\r\n\r\nKey Benefits\r\nPrebiotic fibres to promote growth of beneficial bacteria\r\nIncludes ginger to help calm and soothe digestive tract\r\nGreat taste your dog will love\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Gastrointestinal, Convalescent "
                         withFoodName:@"i/d Low Fat Canned"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-id-low-fat-canned.html"
                  withFoodDescription:@"Highly digestible, low fat food that can be fed long term to manage gastrointestinal disorders and minimize risk of recurrence.\r\nClinically proven to help digestive tract recovery.\r\n\r\nKey Benefits\r\nPrebiotic fibres to promote growth of beneficial bacteria\r\nIncludes ginger to help calm and soothe digestive tract\r\nGreat taste your dog will love\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Gastrointestinal, Convalescent"
                         withFoodName:@"i/d Canned"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-id-canned.html"
                  withFoodDescription:@"Prescription Diet™ Canine i/d™ is a highly digestible formula created specifically to help manage dogs with gastrointestinal disorders.\r\n\r\nKey Benefits\r\nHelps to neutralise free radicals as it contains high level of antioxidants.\r\nHighly digestible ingredients for better gastrointestinal health.\r\nProvides special fibres to help nourish the cells in the guts.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Cardiovascular, "
                         withFoodName:@"h/d Canned"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-hd-canned.html"
                  withFoodDescription:@"Prescription Diet™ Canine h/d™ was created specifically for the nutritional management dogs with heart disease.\r\n\r\nKey Benefits\r\nWith reduced salt to help control fluid retention.\r\nWith extra taurine and L-carnitine to help support the heart muscle.\r\nHelps to neutralise free radicals as it contains high level of antioxidants.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Hair and Skin, Allergic"
                         withFoodName:@"d/d Salmon & Rice"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/products/pd-canine-prescription-diet-dd-salmon-and-rice-dry.html"
                  withFoodDescription:@"Prescription Diet™ Canine d/d™ Salmon and Rice is formulated for the nutritional management of dogs with any skin condition and vomiting/diarrhoea due to allergy.\r\n\r\nKey Benefits\r\nHelps to reduce signs of adverse reactions to food and supports healthy skin function with the right levels of natural omega-3 fatty acids.\r\nSalmon is less commonly used in dog food, this decreases the risk that your allergic dog reacts to this diet.\r\nHelps to neutralise free radicals as it contains high level of antioxidants.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Hair and Skin, Allergic"
                         withFoodName:@"d/d Lamb Canned"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-dd-lamb-canned.html"
                  withFoodDescription:@"Prescription Diet™ Canine d/d™ Lamb is formulated for the nutritional management of dogs with any skin condition and vomiting/diarrhoea due to allergy.\r\n\r\nKey Benefits\r\nHelps to reduce signs of adverse reactions to food and supports healthy skin function with the right levels of natural omega-3 fatty acids.\r\nLamb is less commonly used in dog food, this decreases the risk that your allergic dog reacts to this diet.\r\nHelps to neutralise free radicals as it contains high level of antioxidants.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Hair and Skin, Allergic"
                         withFoodName:@"d/d Egg & Rice"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-dd-egg-and-rice-dry.html"
                  withFoodDescription:@"Prescription Diet™ Canine d/d™ Egg and Rice is formulated for the nutritional management of dogs with any skin condition and vomiting/diarrhoea due to allergy.\r\n\r\nKey Benefits\r\nHelps to reduce signs of adverse reactions to food and supports healthy skin function with the right levels of natural omega-3 fatty acids.\r\nEgg is less commonly used in dog food, this decreases the risk that your allergic dog reacts to this diet.\r\nHelps to neutralise free radicals as it contains high level of antioxidants.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Hair and Skin, Allergic"
                         withFoodName:@"d/d Duck & Rice"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-dd-duck-and-rice-dry.html"
                  withFoodDescription:@"Prescription Diet™ Canine d/d™ Duck and Rice is formulated for the nutritional management of dogs with any skin condition and vomiting/diarrhoea due to allergy.\r\n\r\nKey Benefits\r\nHelps to reduce signs of adverse reactions to food and supports healthy skin function with the right levels of natural omega-3 fatty acids.\r\nDuck is less commonly used in dog food, this decreases the risk that your allergic dog reacts to this diet.\r\nHelps to neutralise free radicals as it contains high level of antioxidants.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Convalescent, "
                         withFoodName:@"a/d Canned"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-feline-prescription-diet-ad-canned.html"
                  withFoodDescription:@"For the nutritional management of pets recovering from serious illness, accidents and surgery.\r\n\r\nKey Benefits\r\nIncreased special proteins to support wound healing and the immune system.\r\nEasily digestible ingredients and extra calories for pets recovering from surgery or serious illness.\r\nExtra tasty with a soft consistency that makes it easier to feed by hand or syringe.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your pet.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Allergic, "
                         withFoodName:@"z/d ULTRA Allergen-Free Canned"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-zd-ultra-allergen-free-canned.html"
                  withFoodDescription:@"Prescription Diet™ Canine z/d™ ULTRA Allergen-Free has the following key benefits.\r\n\r\nKey Benefits\r\nHelps minimise allergic reactions to food. The unique hydrolysed formula provides a safe solution to virtually any food allergy.\r\nChicken hydrolysate is the only protein source.\r\nHelps nourish skin and coat as it is formulated with high levels of essential fatty acids.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Allergic, "
                         withFoodName:@"z/d Low Allergen"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-zd-low-allergen-dry.html"
                  withFoodDescription:@"Prescription Diet™ Canine z /d™ Low Allergen has the following key benefits.\r\n\r\nKey Benefits\r\nHelps minimise allergic reactions to food. The unique hydrolysed formula provides a safe solution to virtually any food allergy.\r\nChicken hydrolysate is the only animal protein source.\r\nHelps nourish skin and coat as it is formulated with high levels of essential fatty acids.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Urinary, "
                         withFoodName:@"s/d Canned"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-sd-canned.html"
                  withFoodDescription:@"For the nutritional management of dogs with urinary tract disease. Urinary tract disease in dogs is often caused by the formation of mineral-based crystals and stones in the urinary tract that can cause discomfort, bloody urine and even life-threatening obstruction. For dogs, struvite crystals generally cause urinary tract disease. Prescription Diet™ s/d™ has been formulated by veterinarians to help resolve struvite crystals and stones in your dog. Struvite forms as a result of urine that's saturated with protein, calcium, phosphorus and magnesium combined with an improper urine pH.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Overweight, Ideal Weight, Fibre, "
                         withFoodName:@"r/d with Chicken"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-rd-with-chicken-dry.html"
                  withFoodDescription:@"Prescription Diet™ Canine r/d™ was designed specifically for the management of weight problems in dogs.\r\n\r\nKey Benefits\r\nScientifically proven to reduce body fat by at least 22% in 8 weeks.\r\nSupplemented with L-carnitine and lysine to burn fat and preserve muscle.\r\nHigh in dietary fibre to help reduce hunger and discourage begging.\r\nNew great taste your dog will enjoy.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Puppy, Convalescent, Bones and Joints"
                         withFoodName:@"p/d"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-dry.html"
                  withFoodDescription:@"Prescription Diet™ p/d™ is a complete pet food designed to speed up a puppies recovery from illness.\r\n\r\nKey Benefits\r\nSupports nutritional restoration in puppies.\r\nClinically proven to aid the immune response in puppies.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Cancer, Convalescent, "
                         withFoodName:@"n/d Canned"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-nd-canned.html"
                  withFoodDescription:@"Prescription Diet™ Canine n/d™ For the Nutritional Support of Dogs with Serious illnesses such as Cancer.\r\n\r\nKey Benefits\r\nSupports dogs recovering from debilitating conditions such as cancer or cancer treatment.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your pet.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Hepatic, "
                         withFoodName:@"l/d"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-ld-dry.html"
                  withFoodDescription:@"Prescription Diet™ Canine l/d™ was created specifically for the nutritional management dogs with liver disorders that cause reduced liver function.\r\n\r\nKey Benefits\r\nHelps managing dogs with liver disease.\r\nHighly digestible protein, carbohydrate and fats.\r\nHelps limit the production of metabolic toxins from nutrients.\r\nHelps reduce the workload of the liver\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Hepatic, "
                         withFoodName:@"l/d Canned"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-ld-canned.html"
                  withFoodDescription:@"Prescription Diet™ Canine l/d™ was created specifically for the nutritional management dogs with liver disorders that cause reduced liver function.\r\n\r\nKey Benefits\r\nHelps managing dogs with liver disease.\r\nHighly digestible protein, carbohydrate and fats.\r\nHelps limit the production of metabolic toxins from nutrients.\r\nHelps reduce the workload of the liver\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Renal, "
                         withFoodName:@"k/d"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-kd-dry.html"
                  withFoodDescription:@"Prescription Diet™ k/d™ Canine is formulated by veterinarians to help manage dogs with kidney disease.\r\n\r\nKey Benefits\r\nClinically proven to help maintain quality of life in kidney patients\r\nHelps to neutralise free radicals as it contains high level of antioxidants\r\nClinically proven to help dogs with chronic kidney failure show fewer signs of disease\r\nGreat taste and texture with tender chunks and delicious gravy that releases tempting aromas and flavours\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Renal, "
                         withFoodName:@"k/d Canned"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-kd-canned.html"
                  withFoodDescription:@"Prescription Diet™ k/d™ Canine is formulated by veterinarians to help manage dogs with kidney disease.\r\n\r\nKey Benefits\r\nClinically proven to help maintain quality of life in kidney patients.\r\nHelps to neutralise free radicals as it contains high level of antioxidants.\r\nClinically proven to help dogs with chronic kidney failure show fewer signs of disease.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
        
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Articular Mobility, Bones and Joints, "
                         withFoodName:@"j/d Mini"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-jd-mini-dry.html"
                  withFoodDescription:@"Hill's™ Prescription Diet™ j/d™ Canine is clinically proven to improve mobility in as little as 21 days with the right balance of healthy nutrients , EPA (a special omega-3 oil) and total omega 3 fatty acids.\r\n\r\nKey Benefits\r\nClinically proven to help dogs walk, run, play and climb stairs more easily, see a difference in 21 days\r\nHelps your dog walk, run and play better by soothing aching joints and preserving healthy cartilage\r\nHelps maintain joint cartilage thanks to high levels of EPA (a special omega-3 fatty acid from fish oil) and glucosamine and chondroitin sulphate from natural sources\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Articular Mobility, Bones and Joints, "
                         withFoodName:@"j/d"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-jd-dry.html"
                  withFoodDescription:@"Hill's™ Prescription Diet™ j/d™ Canine is clinically proven to improve mobility in as little as 21 days with the right balance of healthy nutrients, EPA (a special omega-3 oil) and total omega 3 fatty acids\r\n\r\nKey Benefits\r\nClinically proven to help dogs walk, run, play and climb stairs more easily, see a difference in 21 days\r\nHelps your dog walk, run and play better by soothing aching joints and preserving healthy cartilage\r\nHelps maintain joint cartilage thanks to high levels of EPA (a special omega-3 fatty acid from fish oil) and glucosamine and chondroitin sulphate from natural sources\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Articular Mobility, Bones and Joints, "
                         withFoodName:@"j/d Canned"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-jd-canned.html"
                  withFoodDescription:@"Hill's™ Prescription Diet™ j/d™ Canine is clinically proven to improve mobility in as little as 21 days with the right balance of healthy nutrients, EPA (a special omega-3 oil) and total omega 3 fatty acids.\r\n\r\nKey Benefits\r\nClinically proven to help dogs walk, run, play and climb stairs more easily, see a difference in 21 days\r\nHelps your dog walk, run and play better by soothing aching joints and preserving healthy cartilage\r\nHelps maintain joint cartilage thanks to high levels of EPA (a special omega-3 fatty acid from fish oil) and glucosamine and chondroitin sulphate from natural sources\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Gastrointestinal, Convalescent "
                         withFoodName:@"i/d"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-id-dry.html"
                  withFoodDescription:@"Prescription Diet™ Canine i/d™ is a highly digestible formula created specifically to help manage dogs with gastrointestinal disorders.\r\n\r\nKey Benefits\r\nHelps to neutralise free radicals as it contains high level of antioxidants.\r\nHighly digestible ingredients for better gastrointestinal health.\r\nProvides special fibres to help nourish the cells in the guts.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Cardiovascular, "
                         withFoodName:@"h/d"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-hd-dry.html"
                  withFoodDescription:@"Prescription Diet™ Canine h/d™ was created specifically for the nutritional management dogs with heart disease.\r\n\r\nKey Benefits\r\nWith reduced salt to help control fluid retention.\r\nWith extra taurine and L-carnitine to help support the heart muscle.\r\nHelps to neutralise free radicals as it contains high level of antioxidants.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Hair and Skin, Allergic"
                         withFoodName:@"d/d Venison Canned"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-dd-venison-canned.html"
                  withFoodDescription:@"Prescription Diet™ Canine d/d™ Venison is formulated for the nutritional management of dogs with any skin condition and vomiting/diarrhoea due to allergy.\r\n\r\nKey Benefits\r\nHelps to reduce signs of adverse reactions to food and supports healthy skin function with the right levels of natural omega-3 fatty acids.\r\nVenison is less commonly used in dog food, this decreases the risk that your allergic dog reacts to this diet.\r\nHelps to neutralise free radicals as it contains high level of antioxidants.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Hair and Skin, Allergic"
                         withFoodName:@"d/d Salmon Canned"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-dd-salmon-canned.html"
                  withFoodDescription:@"Prescription Diet™ Canine d/d™ Salmon is formulated for the nutritional management of dogs with any skin condition and vomiting/diarrhoea due to allergy.\r\n\r\nKey Benefits\r\nHelps to reduce signs of adverse reactions to food and supports healthy skin function with the right levels of natural omega-3 fatty acids.\r\nSalmon is less commonly used in dog food, this decreases the risk that your allergic dog reacts to this diet.\r\nHelps to neutralise free radicals as it contains high level of antioxidants.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Hair and Skin, Allergic"
                         withFoodName:@"d/d Duck Canned"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-dd-duck-canned.html"
                  withFoodDescription:@"Prescription Diet™ Canine d/d™ Duck is formulated for the nutritional management of dogs with any skin condition and vomiting/diarrhoea due to allergy.\r\n\r\nKey Benefits\r\nHelps to reduce signs of adverse reactions to food and supports healthy skin function with the right levels of natural omega-3 fatty acids.\r\nDuck is less commonly used in dog food, this decreases the risk that your allergic dog reacts to this diet.\r\nHelps to neutralise free radicals as it contains high level of antioxidants.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Urinary"
                         withFoodName:@"c/d Canned"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-cd-canned.html"
                  withFoodDescription:@"Bladder stones can be very painful and may reoccur in the same dog after being dissolved. Prescription Diet™ Canine c/d™ helps to reduce the risk that struvite stones develop again in the same dogs.\r\n\r\nKey Benefits\r\nHelps reduce recurrence of struvite or calcium phosphate crystals and stones in the urine.\r\nHelps to neutralise free radicals as it contains high level of antioxidants.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"+6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Longevity, "
                         withFoodName:@"b/d"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-bd-dry.html"
                  withFoodDescription:@"Prescription Diet™ b/d™ Canine is a complete pet food for the nutritional management of pets with behavioural changes associated with brain ageing.\r\n\r\nKey Benefits\r\nWith special antioxidants and omega-3 fatty acids to maintain brain function and improve learning ability in older dogs.\r\nReduced protein, salt and phosphorus to help maintain heart and kidney health in the older dog.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Urinary"
                         withFoodName:@"c/d"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-cd-dry.html"
                  withFoodDescription:@"Bladder stones can be very painful and may reoccur in the same dog after being dissolved. Prescription Diet™ Canine c/d™ helps to reduce the risk that struvite stones develop again in the same dogs.\r\n\r\nKey Benefits\r\nHelps reduce recurrence of struvite or calcium phosphate crystals and stones in the urine.\r\nHelps to neutralise free radicals as it contains high level of antioxidants.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Ideal Weight, Fibre, Diabetes, Gastrointestinal"
                         withFoodName:@"w/d Canned"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-wd-canned.html"
                  withFoodDescription:@"Prescription Diet™ Canine w/d™ has the following key benefits.\r\n\r\nKey Benefits\r\nOnce your dog has reached the ideal weight, you can help maintain it by feeding Prescription Diet weight maintenance products.\r\nLow in calories and fat to maintain your dogs ideal weight.\r\nHigh in dietary fibre to help reduce hunger and discourage begging\r\nSupplemented with L-carnitine, a vitamin that helps burn fat and preserve muscles during weight loss.\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Prescription Diet"
                        withSelectOne:@"Articular Mobility, Bones and Joints, "
                         withFoodName:@"j/d Reduced Calorie"
                            withImage:@"hillsPD.PNG"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/pd-canine-prescription-diet-jd-reduced-calorie-dry.html"
                  withFoodDescription:@"Hill's™ Prescription Diet™ j/d™ Canine Reduced Calorie is clinically proven to improve mobility in as little as  21 days with the right balance of healthy nutrients , EPA (a special omega-3 oil) and total omega 3 fatty acids.\r\n\r\nKey Benefits\r\nClinically proven to help dogs walk, run, play and climb stairs more easily, see a difference in 21 days\r\nHelps your dog walk, run and play better by soothing aching joints and preserving healthy cartilage\r\nHelps maintain joint cartilage thanks to high levels of EPA (a special omega-3 fatty acid from fish oil) and glucosamine and chondroitin sulphate from natural sources\r\n\r\nPlease consult your vet for further information and guidance on what is best for your dog.\r\n"];
    
    
    

    
    
#pragma mark - Hill's Science Plan

    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"Medium,"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Puppy, Optimal Care"
                         withFoodName:@"Puppy Medium Chicken Canned"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-puppy-medium-savoury-chicken-canned.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Puppy Savoury Chicken is formulated to support immunity and mobility, with clinically proven antioxidants and DHA from fish oil.\r\n\r\nKey Benefits\r\n\r\nClinically proven antioxidants for a healthy immune system.\r\nWith omega-3 and optimal mineral levels for mobility and skeletal development.\r\nHigh quality ingedients for gentle, healthy digestion and great tase. 100% guaranteed.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Puppy, Optimal Care"
                         withFoodName:@"Puppy Lamb & Rice"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-puppy-lamb-and-rice-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Puppy Healthy Development™ Lamb & Rice is formulated to support strong immunity and digestive health. With clinically proven antioxidants and optimal levels of omega-3 and 6.\r\n\r\nKey Benefits\r\n\r\nHigh quality lamb for gentle, healthy digestion.\r\nEnhanced omega-3 and 6 for healthy skin and coat.\r\nClinically proven antioxidants for a healthy immune system.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"X-Small, Mini,"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Puppy, Optimal Care"
                         withFoodName:@"Healthy Development Puppy Mini"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-puppy-healthy-development-mini-chicken-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Puppy Healthy Development™ Mini Chicken is formulated to support immunity and mobility, for puppies who prefer a smaller kibble. With clinically proven antioxidants and DHA.\r\n\r\nKey Benefits\r\n\r\nClinically proven antioxidants for a healthy immune system.\r\nWith omega-3 and optimal mineral levels for mobility and skeletal development.\r\nHigh quality ingedients for gentle, healthy digestion and great taste. 100% guaranteed.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"Medium, "
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Puppy, Optimal Care"
                         withFoodName:@"Healthy Development Puppy Medium"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-puppy-healthy-development-medium-chicken-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Puppy Healthy Development™ Medium Chicken is formulated to support immunity and mobility, with clinically proven antioxidants and DHA from fish oil.\r\n\r\nKey Benefits\r\n\r\nClinically proven antioxidants for a healthy immune system.\r\nWith omega-3 and optimal mineral levels for mobility and skeletal development.\r\nHigh quality ingedients for gentle, healthy digestion and great tase. 100% guaranteed.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"Large, Giant"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Puppy, Optimal Care"
                         withFoodName:@"Healthy Development Puppy Large"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-puppy-healthy-development-large-breed-chicken-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Puppy Healthy Development™ Large Breed Chicken is formulated for healthy skeletal development in large breed puppies. With clinically proven antioxidants and optimal mineral levels.\r\n\r\nKey Benefits\r\n\r\nWith optimal mineral levels for healthy skeletal development.\r\nWith quality proteins and L-carnitine to support lean muscle.\r\nClinically proven antioxidants for a healthy immune system.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Puppy, Hair and Skin, "
                         withFoodName:@"Sensitive Skin SNACKS Puppy"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-snacks-puppy-sensitive-skin-treats.html"
                  withFoodDescription:@"The Snack that Helps Keep Your Puppy's Coat Beautiful and Shiny.\r\n\r\nDeliciously crunchy Science Plan™ Skin & Coat SNACKS contain the vital fatty acids every puppy needs to help nourish his skin and support a healthy coat. Plus, we add a balance of vitamins and minerals to help your puppy grow and develop into a healthy adult dog.\r\n\r\nKey Benefits\r\n\r\nWith Super Antioxidant Formula\r\nSupports healthy skin & shiny coat thanks to essential fatty acids\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Puppy, Optimal Care, "
                         withFoodName:@"Immunity Support SNACKS Puppy"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-snacks-puppy-immunity-support-treats.html"
                  withFoodDescription:@"The Fun Wafer-Shaped Snack No Puppy Can Resist.\r\n\r\nDeliciously crunchy Science Plan™ Immunity Support SNACKS have an ideal balance of antioxidant vitamins and minerals in every bite to help support his immune system. The high quality protein packed into every portion is great for strong bones and muscles too.\r\n\r\nKey Benefits\r\n\r\nWith Super Antioxidant Formula\r\nIdeal balance of vitamins and minerals for added immunity defense\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, Giant"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Oral Care, "
                         withFoodName:@"Oral Care SNACKS Adult Large"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sd-canine-science-plan-snacks-adult-oral-care-large-breed-treats.html"
                  withFoodDescription:@"Give Your Dog Something to Smile About.\r\n\r\nGood oral health is important to man and man’s best friend alike. That’s why our Science Plan™ Oral Care Snacks help freshen your dog’s breath and clean their teeth.\r\n\r\nKey Benefits\r\n\r\nWith Super Antioxidant Formula\r\nWorks like a toothbrush to help freshen breath and clean teeth\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, "
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Hair and Skin"
                         withFoodName:@"Sensitive Skin SNACKS Adult Mini/Medium"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-snacks-adult-mini-medium-sensitive-skin-treats.html"
                  withFoodDescription:@"The Snack that Helps Keep Your Dog's Coat Beautiful and Shiny.\r\nDeliciously crunchy Science Plan™ Skin & Coat SNACKS contain the vital fatty acids every dog needs to help nourish his skin and keep his coat shiny. Plus, we add a balance of vitamins and minerals to keep your dog going strong.\r\n\r\nKey Benefits\r\n\r\nWith Super Antioxidant Formula\r\nSupports healthy skin & shiny coat thanks to essential fatty acids.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium,"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Oral Care"
                         withFoodName:@"Oral Care SNACKS Adult Mini/Medium"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-snacks-adult-mini-medium-oral-care-treats.html"
                  withFoodDescription:@"Give Your Dog Something to Smile About.\r\n\r\nBecause good oral health is so important, our Science Plan™ Oral Care SNACKS not only reward your dog but also help freshen his breath and clean his teeth.\r\n\r\nKey Benefits\r\n\r\nWith Super Antioxidant Formula\r\nWorks like a toothbrush to help freshen breath and clean teeth\r\n"];
    
            
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium,"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Ideal Weight"
                         withFoodName:@"Light SNACKS Adult Mini/Medium"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-snacks-adult-mini-medium-light-treats.html"
                  withFoodDescription:@"The Reduced Calorie Snack Your Dog Will Love.\r\n\r\nExcess weight is a serious health issue. That’s why we developed Science Plan™ Light SNACKS, the great tasting, reduced calorie healthy canine snacks that help keep your dog fit, trim and healthy.\r\n\r\nKey Benefits\r\n\r\nWith Super Antioxidant Formula\r\nLow fat and reduced calorie formula\r\nHelps maintain healthy body weight\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium,"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Optimal Care, "
                         withFoodName:@"Immunity Support SNACKS Adult Mini/Medium"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-snacks-adult-mini-medium-immunity-support-treats.html"
                  withFoodDescription:@"The Playful, Wafer-Shaped Snack No Dog Can Resist.\r\n\r\nDeliciously crunchy Science Plan™ Immunity Support Snacks are just what your dog needs to help stay hearty and healthy. The vital fatty acids and healthful antioxidants in every bite help support immunity, while the balance of vitamins and minerals provide added defence.\r\n\r\nKey Benefits\r\n\r\nWith Super Antioxidant Formula\r\nVital fatty acids and healthful antioxidants to help support immunity\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium,"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Bones and Joints"
                         withFoodName:@"Healthy Mobility SNACKS Adult Mini/Medium"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-snacks-adult-mini-medium-healthy-mobility-treats.html"
                  withFoodDescription:@"Keep your Dog Feeling Healthy and Strong.\r\n\r\nTo help support healthy joints of your active dog we created Science Plan™ Healthy Mobility SNACKS, the deliciously crunchy snacks which contain increased levels of omega-3 fatty acids.\r\n\r\nKey Benefits\r\n\r\nWith Super Antioxidant Formula\r\nWith increased levels of omega-3 fatty acids to help support healthy joints\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, Giant"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Ideal Weight"
                         withFoodName:@"Light SNACKS Adult Large"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-snacks-adult-large-breed-light-treats.html"
                  withFoodDescription:@"The Reduced Calorie Snack Your Dog Will Love.\r\n\r\nAt Hills, we believe every dog should have his day. That’s why we developed Science Plan™ Light Snacks, the great tasting; reduced calorie healthy canine snacks that help keep your dog fit.\r\n\r\nKey Benefits\r\n\r\nWith Super Antioxidant Formula\r\nReduced Calorie Content\r\nHelps maintain healthy, trim body weight with low fat and reduced calories\r\n"];
    
        
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, Giant"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Bones and Joints"
                         withFoodName:@"Healthy Mobility SNACKS Adult Large"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-snacks-adult-large-breed-healthy-mobility-treats.html"
                  withFoodDescription:@"Keep your Dog Feeling Healthy and Strong.\r\n\r\nTo help support healthy joints of your active dog we created Science Plan™ Healthy Mobility Snacks, the deliciously crunchy snacks which contain increased levels of omega-3 fatty acids.\r\n\r\nKey Benefits\r\n\r\nWith Super Antioxidant Formula\r\nWith increased levels of omega-3 fatty acids to help support healthy joints.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"+6 years"
                          withDogSize:@"Medium,"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Optimal Care, Longevity"
                         withFoodName:@"Mature Adult 7+ Medium Canned"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-mature-adult-7-plus-medium-savoury-chicken-canned.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Mature Adult/Senior 7+Savoury Chicken is formulated to sustain mobility and healthy vital organs. With clinically proven antioxidants, and glucosamine and chondroitin from natural sources.\r\n\r\nKey Benefits\r\n\r\nJoint and mobility support with glucosamine and chondroitin from natural sources.\r\nSustains healthy vital organs with balanced sodium and phosphorus levels.\r\nHighly digestible ingredients for optimal nutrient absorption.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
    
     
     
     
     
    
    [self insertFoodProductWithDogAge:@"+6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Fibre, Ideal Weight, Longevity, "
                         withFoodName:@"Light Active Longevity 7+ Chicken"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-mature-adult-7-plus-light-active-longevity-with-chicken-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Mature Adult 7 Light with Chicken is formulated to help maintain ideal weight and sustain mobility. With clinically proven antioxidants and L-carnitine to help turn fat into energy.\r\n\r\nKey Benefits\r\n\r\n-48% fat and -16% calories (compared to Hill's Science Plan Advanced Fitness Adult).\r\nHigh fibre controls hunger between meals.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"+6 years"
                          withDogSize:@"X-Small, Mini,"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Longevity"
                         withFoodName:@"Active Longevity 7+ Mini Chicken"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-mature-adult-7-plus-active-longevity-mini-with-chicken-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Mature Adult 7+ Active Longevity™ Mini with Chicken is formulated to sustain mobility and healthy vital organs.,for dogs who prefer a smaller kibble. With clinically proven antioxidants, and glucosamine and chondroitin from natural sources.\r\n\r\nKey Benefits\r\n\r\nJoint and mobility support with glucosamine and chondroitin from natural sources.\r\nSustains healthy vital organs with balanced sodium and phosphorus levels.\r\nHighly digestible ingredients for optimal nutrient absorption.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"+6 years"
                          withDogSize:@"Medium, "
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Longevity"
                         withFoodName:@"Active Longevity 7+ Medium Chicken"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-mature-adult-7-plus-active-longevity-medium-with-chicken-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Mature Adult 7+ Active Longevity™ Medium with Chicken is formulated to sustain mobility and healthy vital organs. With clinically proven antioxidants, and glucosamine and chondroitin from natural sources.\r\n\r\nKey Benefits\r\n\r\nJoint and mobility support with glucosamine and chondroitin from natural sources.\r\nSustains healthy vital organs with balanced sodium and phosphorus levels.\r\nHighly digestible ingredients for optimal nutrient absorption.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"+6 years"
                          withDogSize:@"Medium, "
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Longevity"
                         withFoodName:@"Active Longevity 7+ Medium Lamb & Rice"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-mature-adult-7-plus-active-longevity-medium-lamb-and-rice-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Mature Adult 7+ Active Longevity™ Lamb & Rice is formulated to promote digestive health and sustain mobility. With clinically proven antioxidants and highly digestible lamb.\r\n\r\nKey Benefits\r\n\r\nHigh quality lamb for gentle, healthy digestion.\r\nEnhanced omega-3 and 6 for healthy skin and coat.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"2-6 years, +6 years"
                          withDogSize:@"Large, Giant"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Longevity"
                         withFoodName:@"Active Longevity 5+ Large Chicken"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-mature-adult-5-plus-active-longevity-large-breed-with-chicken-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Mature Adult 5+ Active Longevity™ Large Breed with Chicken is formulated to sustain mobility, lean muscles and organ health, for large breed dogs. With clinically proven antioxidants and L-carnitine.\r\n\r\nKey Benefits\r\n\r\nJoint and mobility support with glucosamine and chondroitin from natural sources.\r\nSustains healthy vital organs with balanced sodium and phosphorus levels.\r\nSupports lean muscles with high quality proteins and L-carnitine.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Stomach, "
                         withFoodName:@"Sensitive Stomach Adult Chicken, Egg & Rice"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-adult-sensitive-stomach-chicken-with-egg-and-rice-dry.html"
                  withFoodDescription:@"Science Plan™ Canine Adult Sensitive Stomach Chicken with Egg & Rice is formulated to promote gentle digestion. With clinically proven antioxidants and highly digestible proteins and fibres.\r\n\r\nKey Benefits\r\n\r\nAdvanced nutrition for comfortable digestion.\r\nUnique fibre blend promotes intestinal health.\r\nMade with high quality proteins to support lean muscle.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Hair and Skin, "
                         withFoodName:@"Sensitive Skin Adult Chicken"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-adult-sensitive-skin-with-chicken-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Adult Sensitive Skin with Chicken is formulated to help avoid dry, flaky and itchy skin. With clinically proven antioxidants and omega- 3 & 6.\r\n\r\nKey Benefits\r\n\r\nEnhanced omega-3 and 6 for healthy skin and coat.\r\nNourishes skin and replenishes its natural oils.\r\nWith high quality proteins to support lean muscle.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Vitality"
                         withFoodName:@"Performance Adult Chicken"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-adult-performance-chicken-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Adult Performance Chicken is formulated to meet the additional energy needs of active, working and hunting dogs. With clinically proven antioxidants and a high energy density kibble...\r\n\r\nKey Benefits\r\n\r\nHigh energy density kibble.\r\nWith high quality proteins to support lean muscle.\r\nSustains healthy vital organs with balanced sodium and phosphorus levels.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Oral Care"
                         withFoodName:@"Oral Care Adult Chicken"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-adult-oral-care-chicken-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Adult Oral Care Chicken is clinically proven to reduce plaque and tartar. With antioxidants and advanced oral care technology.\r\n\r\nKey Benefits\r\n\r\nClinically proven kibble technology to reduce plaque and tartar.\r\nDaily dental protection to freshen breath.\r\nWith high quality proteins to support lean muscle.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Medium, "
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Optimal Care"
                         withFoodName:@"Adult Medium Turkey Canned"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-adult-medium-savoury-turkey-canned.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Adult Savoury Turkey is formulated to support lean muscle and healthy vital organs. With clinically proven antioxidants, lean proteins and omega 3's.\r\n\r\nKey Benefits\r\n\r\nWith high quality proteins to support lean muscle.\r\nSustains healthy vital organs with balanced sodium and phosphorus levels.\r\nHighly digestible ingredients for optimal nutrient absorption.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Medium, "
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Optimal Care"
                         withFoodName:@"Adult Medium Chicken Canned"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-adult-medium-savoury-chicken-canned.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Adult Savoury Chicken is formulated to support lean muscle and healthy vital organs. With clinically proven antioxidants, lean proteins and omega 3's.\r\n\r\nKey Benefits\r\n\r\nWith high quality proteins to support lean muscle.\r\nSustains healthy vital organs with balanced sodium and phosphorus levels.\r\nHighly digestible ingredients for optimal nutrient absorption.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Medium, "
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Optimal Care"
                         withFoodName:@"Adult Medium Beef Canned"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-adult-medium-delicious-beef-canned.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Adult Delicious Beef is formulated to support lean muscle and healthy vital organs. With clinically proven antioxidants, lean proteins and omega 3's.\r\n\r\nKey Benefits\r\n\r\nWith high quality proteins to support lean muscle.\r\nSustains healthy vital organs with balanced sodium and phosphorus levels.\r\nHighly digestible ingredients for optimal nutrient absorption.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Ideal Weight, Fibre"
                         withFoodName:@"Light Adult Chicken"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-adult-light-with-chicken-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Adult Light with Chicken is formulated to help maintain ideal weight. With clinically proven antioxidants and L-carnitine to help turn fat into energy.\r\n\r\nKey Benefits\r\n\r\n-40% fat and -18% calories (compared to Hill's Science Plan Adult).\r\nHigh fibre helps controls hunger between meals.\r\nGreat Taste, 100% guaranteed.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Ideal Weight,"
                         withFoodName:@"Light Adult Chicken Canned"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-adult-light-with-chicken-canned.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Light Adult with chicken is formulated to help maintain ideal weight. With clinically proven antioxidants and L-carnitine to help turn fat into energy.\r\n\r\nKey Benefits\r\n\r\n-40% fat and -18% calories (compared to Hill's Science Plan Advanced Fitness).\r\nHigh fibre helps controls hunger between meals.\r\nGreat Taste, 100% guaranteed.\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, Giant"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Ideal Weight, Fibre"
                         withFoodName:@"Light Adult Large Chicken"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-adult-light-large-breed-chicken-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Adult Light Large Breed with Chicken is formulated to help maintain ideal weight and healthy joints, for large breed dogs. With clinically proven antioxidants and L-carnitine to help turn fat into energy.\r\n\r\nKey Benefits\r\n\r\n-37% fat and -18% calories* (compared to Hill's Science Plan Adult Large Breed).\r\nHigh fibre helps controls hunger between meals.\r\nOptimal joint support with glucosamine and chondroitin from natural sources.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, "
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Articular Mobility, Bones and Joints"
                         withFoodName:@"Healthy Mobility Adult Mini Chicken"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-adult-healthy-mobility-mini-with-chicken-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Adult Healthy Mobility Mini with Chicken is specifically formulated to support active mobility and joint care in dogs who prefer a smaller kibble. Enriched with omega-3 fatty acids and clinically proven antioxidants.\r\n\r\nKey Benefits\r\n\r\nProven advanced nutrition to help support your dog's active mobility\r\nProven nutrition to support joint flexibility\r\nHelps ease of movement through healthy joints\r\nMade with high quality ingredients for great taste. 100% guaranteed\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@" Medium, "
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Articular Mobility, Bones and Joints"
                         withFoodName:@"Healthy Mobility Adult Medium Chicken"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-adult-healthy-mobility-medium-with-chicken-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Adult Healthy Mobility Medium with Chicken is specifically formulated to support active mobility and joint care in dogs. Enriched with omega-3 fatty acids and clinically proven antioxidants.\r\n\r\nKey Benefits\r\n\r\nProven advanced nutrition to help support your dog's active mobility\r\nProven nutrition to support joint flexibility\r\nHelps ease of movement through healthy joints\r\nMade with high quality ingredients for great taste. 100% guaranteed\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@" 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, Giant"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Articular Mobility, Bones and Joints"
                         withFoodName:@"Healthy Mobility Adult Large Chicken"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-adult-healthy-mobility-large-with-chicken-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Adult Healthy Mobility Large Breed with Chicken is specifically formulated to support active mobility and joint care in dogs who prefer a larger kibble. Enriched with omega-3 fatty acids and clinically proven antioxidants.\r\n\r\nKey Benefits\r\n\r\nProven advanced nutrition to help support your dog's active mobility\r\nProven nutrition to support joint flexibility\r\nHelps ease of movement through healthy joints\r\nMade with high quality ingredients for great taste. 100% guaranteed\r\n"];
    
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini,"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Optimal Care"
                         withFoodName:@"Advanced Fitness Adult Mini Chicken"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-adult-advanced-fitness-mini-with-chicken-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Adult Advanced Fitness™ Mini with Chicken is formulated to support lean muscle and healthy vital organs, for dogs who prefer a smaller kibble. With clinically proven antioxidants, lean proteins and omega 3's.\r\n\r\nKey Benefits\r\n\r\nWith high quality proteins to support lean muscle.\r\nSustains healthy vital organs with balanced sodium and phosphorus levels.\r\nHighly digestible ingredients for optimal nutrient absorption.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    

    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Medium, "
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Optimal Care"
                         withFoodName:@"Advanced Fitness Adult Medium Tuna & Rice"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-adult-advanced-fitness-medium-with-tuna-and-rice-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Adult Advanced Fitness™ with Tuna & Rice is formulated to support lean muscle and healthy vital organs. With clinically proven antioxidants, lean proteins and omega 3's.\r\n\r\nKey Benefits\r\n\r\nWith high quality proteins to support lean muscle.\r\nSustains healthy vital organs with balanced sodium and phosphorus levels.\r\nHighly digestible ingredients for optimal nutrient absorption.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
     
     
     
     
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Medium, "
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Optimal Care"
                         withFoodName:@"Advanced Fitness Adult Medium Chicken"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-adult-advanced-fitness-medium-with-chicken-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Adult Advanced Fitness™ Medium with Chicken is formulated to support lean muscle and healthy vital organs. With clinically proven antioxidants, lean proteins and omega 3's.\r\n\r\nKey Benefits\r\n\r\nWith high quality proteins to support lean muscle.\r\nSustains healthy vital organs with balanced sodium and phosphorus levels.\r\nHighly digestible ingredients for optimal nutrient absorption.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
    
     
     
     [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                           withDogSize:@"Medium,"
                         withFoodBrand:@"Hill's Science Plan"
                         withSelectOne:@"Optimal Care"
                          withFoodName:@"Advanced Fitness Adult Medium Beef"
                             withImage:@"hillsSP.png"
                           withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-adult-advanced-fitness-medium-with-beef-dry.html"
                   withFoodDescription:@"Hill's™ Science Plan™ Canine Adult Advanced Fitness™ with Beef is formulated to support lean muscle and healthy vital organs. With clinically proven antioxidants, lean proteins and omega 3's.\r\n\r\nKey Benefits\r\n\r\nWith high quality proteins to support lean muscle.\r\nSustains healthy vital organs with balanced sodium and phosphorus levels.\r\nHighly digestible ingredients for optimal nutrient absorption.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Medium,"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Optimal Care"
                         withFoodName:@"Advanced Fitness Adult Medium Lamb & Rice"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-adult-advanced-fitness-medium-lamb-and-rice-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Adult Advanced Fitness™ Lamb & Rice is formulated to support digestive health and lean muscle. With clinically proven antioxidants and highly digestible lamb.\r\n\r\nKey Benefits\r\n\r\nHigh quality lamb for gentle, healthy digestion.\r\nEnhanced omega-3 and 6 for healthy skin and coat.\r\nWith high quality proteins to support lean muscle.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, Giant"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Optimal Care"
                         withFoodName:@"Advanced Fitness Adult Large Chicken"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sp-canine-science-plan-adult-advanced-fitness-large-breed-with-chicken-dry.html"
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Adult Advanced Fitness™ Large Breed with Chicken is formulated for optimal joint and muscle support, for large breed dogs. With clinically proven antioxidants, and glucosamine and chondroitin from natural sources.\r\n\r\nKey Benefits\r\n\r\nSupports joints with glucosamine and chondroitin from natural sources.\r\nWith high quality proteins to support lean muscle.\r\nHighly digestible ingredients for optimal nutrient absorption.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
    
     
     
     
     
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, Giant"
                        withFoodBrand:@"Hill's Science Plan"
                        withSelectOne:@"Optimal Care"
                         withFoodName:@"Advanced Fitness Adult Large Lamb & Rice"
                            withImage:@"hillsSP.png"
                          withWebPage:@"http://www.hillspet.co.uk/en-gb/en-gb/products/sd-canine-science-plan-adult-advanced-fitness-large-breed-lamb-and-rice-dry.html "
                  withFoodDescription:@"Hill's™ Science Plan™ Canine Adult Advanced Fitness™ Large Breed Lamb & Rice is formulated to support digestion and joint health, for large breed dogs. With clinically proven antioxidants and highly digestible lamb.\r\n\r\nKey Benefits\r\n\r\nHigh quality lamb for gentle, healthy digestion.\r\nEnhanced omega-3 and 6 for healthy skin and coat.\r\nOptimal joint and muscle support, with high quality proteins and L-carnitine.\r\nMade with high quality ingredients for great taste. 100% guaranteed.\r\n"];
    
    
    
    
    
#pragma mark - Purina Veterinary Diets  
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Veterinary Diets"
                        withSelectOne:@"Fibre"
                         withFoodName:@"DCO Dual Fiber Control"
                            withImage:@"purinaVetDiets.jpg"
                          withWebPage:@"http://www.purinaveterinarydiets.com/Product/DCODualFiberControlDogFood.aspx"
                  withFoodDescription:@"Dietary Considerations\r\nPurina Veterinary Diets® DCO® canine formula provides complete and balanced nutrition for maintenance of the adult dog and has been formulated to achieve the following characteristics:\r\n\r\nHigh level of complex carbohydrates\r\nIncreased fiber including soluble fiber\r\nModerate total dietary fat and calories\r\nSource of omega-3 and omega-6 fatty acids\r\nLite Snackers® are a perfect complement when using the DCO formula.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Veterinary Diets"
                        withSelectOne:@"Oral Care"
                         withFoodName:@"DH Dental Health"
                            withImage:@"purinaVetDiets.jpg"
                          withWebPage:@"http://www.purinaveterinarydiets.com/Product/DHDentalHealthDogFood.aspx"
                  withFoodDescription:@"Dietary Considerations\r\nPurina Veterinary Diets® DH® Dental Health Canine Formula and DH® Small Bites Canine Formula have been formulated to provide complete and balanced nutrition for adult and senior dogs, while providing the following characteristics:\r\n\r\nOptimal kibble size\r\nPatented kibble texture\r\nAdded antioxidants A and E\r\nNatural source of glucosamine\r\nModerate calories\r\nExceptional palatability\r\nPerfect solution for everyday feeding of adult and senior dogs\r\nCanine Dental Chewz™ are a perfect complement when using the DH Formula.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Veterinary Diets"
                        withSelectOne:@"Hair and Skin"
                         withFoodName:@"DRM Dermatologic Management"
                            withImage:@"purinaVetDiets.jpg"
                          withWebPage:@"http://www.purinaveterinarydiets.com/Product/DRMDermatologicManagementDogFood.aspx"
                  withFoodDescription:@"Dietary Considerations\r\nPurina Veterinary Diets® DRM Dermatologic Management® Canine Formula provides complete and balanced nutrition for growth of puppies and maintenance of the adult dog. It has been formulated to achieve the following characteristics:\r\n\r\nLimited number of alternative protein ingredients\r\nAppropriate levels of omega-6 fatty acids\r\nHigh omega-3 fatty acid content\r\nIncreased antioxidant vitamins A and E\r\nGentle Snackers® Hypoallergenic Canine Treats is a perfect complement when using the DRM Formula.\r\n\r\nAsk your veterinarian if DRM Dermatologic Management® Canine Formula can help your dog.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Veterinary Diets"
                        withSelectOne:@"Stomach, "
                         withFoodName:@"EN Gastroenteric"
                            withImage:@"purinaVetDiets.jpg"
                          withWebPage:@"http://www.purinaveterinarydiets.com/Product/ENGastroentericDogFood.aspx"
                  withFoodDescription:@"Dietary Considerations\r\nPurina Veterinary Diets® EN® canine formulas provide complete and balanced nutrition for growth of puppies and maintenance of the adult dog and have been formulated to achieve the following characteristics:\r\n\r\nHigh digestibility\r\nSource of MCTs (22-34% of fat)\r\nModerate fat\r\nSource of omega-3 and omega-6 fatty acids\r\nLow fiber\r\nIncreased antioxidant vitamins E & C\r\nAdded Zinc\r\n\r\nGentle Snackers® are an excellent complement when using the EN formulas.\r\n\r\nFortiflora® Canine Nutritional Supplement is an excellent complement when using the EN Formulas.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Veterinary Diets"
                        withSelectOne:@"Allergic"
                         withFoodName:@"HA Hypoallergenic"
                            withImage:@"purinaVetDiets.jpg"
                          withWebPage:@"http://www.purinaveterinarydiets.com/Product/HAHypoallergenicDogFood.aspx"
                  withFoodDescription:@"Dietary Considerations\r\nPurina Veterinary Diets® HA® canine formula provides complete and balanced nutrition for the growth of puppies and maintenance of the adult dog and has been formulated to achieve the following characteristics:\r\n\r\nHydrolyzed protein source with an average molecular weight below 12,200 daltons\r\nSingle protein source\r\nSource of Medium Chain Triglycerides (MCTs)-23% of fat\r\nHigh digestibility\r\nVegetarian diet\r\nLow allergen carbohydrate source\r\nGentle Snackers™ is based on the successful HA Formula, and are a perfect complement when using the HA formula.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Veterinary Diets"
                        withSelectOne:@"Bones and Joints, Articular Mobility"
                         withFoodName:@"JM Joint Mobility"
                            withImage:@"purinaVetDiets.jpg"
                          withWebPage:@"http://www.purinaveterinarydiets.com/Product/JMJointMobilityDogFood.aspx"
                  withFoodDescription:@"Dietary Considerations\r\nPurina Veterinary Diets® JM Joint Mobility® Canine Formula has been formulated to provide complete and balanced nutrition for the growth of puppies and maintenance of adult and senior dogs, while providing the following characteristics:\r\n\r\nHigh EPA and omega-3 fatty acid content\r\nAppropriate levels of omega-6 fatty acids\r\nModerate fat content\r\nHigh levels of antioxidant vitamins E and C\r\nHigh protein: calorie ratio\r\nNatural source of glucosamine\r\nZxcellent palatability\r\nDental Chewz™ and Lite Snackers® Canine Treats are a perfect complement when using the JM Formula.\r\n\r\nIf your dog exhibits any of the following signs, contact your veterinarian to schedule a physical exam and ask if JM Joint Mobility® Canine Formula could help.\r\n\r\nHas difficulty getting up in the morning or lying down for a rest.\r\nLimps or appears stiff after exercise.\r\nTires easily or lags behind on walks.\r\nReluctant to climb steps or jump up.\r\nPants excessively when he doesn't seem hot.\r\n\r\nUSE ONLY AS DIRECTED BY YOUR VETERINARIAN\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Veterinary Diets"
                        withSelectOne:@"Renal, "
                         withFoodName:@"NF Kidney Function"
                            withImage:@"purinaVetDiets.jpg"
                          withWebPage:@"http://www.purinaveterinarydiets.com/Product/NFKidneyFunctionDogFood.aspx"
                  withFoodDescription:@"Dietary Considerations\r\nPurina Veterinary Diets® NF Kidney Function® Canine Formulas provide complete and balanced nutrition for adult dog maintenance and have been formulated to achieve the following characteristics:\r\n\r\nLow phosphorus\r\nReduced protein\r\nAdded potassium\r\nLow sodium\r\nSource of omega-3 and omega-6 fatty acids\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Veterinary Diets"
                        withSelectOne:@"Overweight"
                         withFoodName:@"OM Overweight Management"
                            withImage:@"purinaVetDiets.jpg"
                          withWebPage:@"http://www.purinaveterinarydiets.com/Product/OMOverweightManagementDogFood.aspx"
                  withFoodDescription:@"Dietary Considerations\r\nPurina Veterinary Diets® OM Overweight Management® and OM Select Blend Overweight Management™ canine formulas provide complete and balanced nutrition for safe and effective weight loss and weight maintenance and have been formulated to achieve the following characteristics:\r\n\r\nLow fat\r\nLow calorie\r\nOptimal level of natural fiber helps dogs feel full\r\nHigh protein to help maintain lean body mass\r\nLite Snackers® are a perfect complement when using the OM Formula.\r\n\r\nWith our new additions to our OM lineup we’re offering the options in texture and variety that pet owners, and pets, want.\r\n\r\nProven Results\r\n\r\nIn a groundbreaking 14-year study by Purina, dogs fed to a lean body condition throughout their lives had a median life span nearly two years longer than overweight dogs and a later onset of chronic conditions such as osteoarthritis.\r\n\r\nIt’s never too late to begin the lean-fed diet regimen. A recent study showed osteoarthritic dogs that lost weight through diet and exercise achieved increased mobility.\r\n\r\nAsk your veterinarian to help you score your dog’s body condition. After determining your dog’s score, you and your veterinarian can map a route to his ideal body condition and a longer, healthier life.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Veterinary Diets"
                        withSelectOne:@"Gastrointestinal, Stomach"
                         withFoodName:@"FortiFlora"
                            withImage:@"purinaVetDiets.jpg"
                          withWebPage:@"http://www.purinaveterinarydiets.com/Product/FortiFloraCanineNutritionalSupplements.aspx"
                  withFoodDescription:@"Dietary Considerations\r\nFortiFlora is a nutritional supplement for dogs and has been formulated to achieve the following characteristics:\r\n\r\nContains a special strain of probiotic that has been proven to promote intestinal health and balance\r\nContains a guaranteed amount of live active cultures\r\nPromotes a healthy immune system\r\nContains high levels of antioxidant Vitamins A, E, and C\r\nExcellent palatability\r\nProprietary mircoencapsulation process for enhanced stability\r\nShown to be safe for use in dogs\r\n\r\nHow does FortiFlora work?\r\nFortiFlora may help nutritionally manage dogs with diarrhea in many situations, including:\r\n\r\nStressful situations such as boarding or change in home environment\r\nDiet change or consumption of inappropriate foods\r\nSoft stool in puppies\r\nAntibiotic therapy\r\n\r\nAsk your veterinarian how FortiFlora can help your dog’s diarrhea.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Veterinary Diets"
                        withSelectOne:@"Oral Care"
                         withFoodName:@"Dental Chewz"
                            withImage:@"purinaVetDiets.jpg"
                          withWebPage:@"http://www.purinaveterinarydiets.com/Product/DentalChewzDogTreats.aspx"
                  withFoodDescription:@"Dietary Considerations\r\n\r\nDental Chewz™ have been formulated to achieve the following characteristics:\r\n\r\nProven to significantly reduce build up of tartar\r\nHigh protein\r\nLow fat\r\nExceptional palatability\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Veterinary Diets"
                        withSelectOne:@"Allergic, "
                         withFoodName:@"Gentle Snackers Hypoallergenic"
                            withImage:@"purinaVetDiets.jpg"
                          withWebPage:@"http://www.purinaveterinarydiets.com/Product/GentleSnackersHypoallergenicDogTreats.aspx"
                  withFoodDescription:@"Dietary Considerations\r\n\r\nGentle Snackers® brand Canine Treats have been formulated to achieve the following characteristics:\r\n\r\nLow molecular weight\r\nSingle hydrolyzed protein source\r\nExceptionally palatable\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, 12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Veterinary Diets"
                        withSelectOne:@"Ideal Weight, Fibre, "
                         withFoodName:@"Lite Snackers"
                            withImage:@"purinaVetDiets.jpg"
                          withWebPage:@"http://www.purinaveterinarydiets.com/Product/LiteSnackersCanineTreats.aspx"
                  withFoodDescription:@"Dietary Considerations\r\n\r\nPurina Veterinary Diets® Lite Snackers® brand Canine Treats have been formulated to achieve the following characteristics:\r\n\r\nLow calorie content\r\nLow fat\r\nHigh fiber\r\nExceptional palatability\r\nStay-fresh pouch\r\nHelps clean teeth and freshen breath\r\n"];
    
    








#pragma mark - Purina Pro Plan
        //6+13+2=21

    
    //Puppy
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Pro Plan"
                        withSelectOne:@"Puppy, Optimal Care, Pregnant or Nursing Dog"
                         withFoodName:@"Puppy Original"
                            withImage:@"purinaProPlan.jpg"
                          withWebPage:@"http://www.purina-proplan.co.uk/Dogs/Puppy/OriginalChickenAndRice.aspx"
                  withFoodDescription:@"Suitable for all pregnant bitches from 6 weeks of pregnancy\r\n\r\nPRO PLAN® PUPPY ORIGINAL with OPTISTART®* is complete nutrition for protection for all puppies. Contains DHA, naturally found in mothers’ milk, important for brain and vision development.\r\n\r\nComplete pet food for puppies.\r\n\r\nProduct Information\r\n\r\nFormulated with Colostrum, found in mother’s first milk, which helps support immune response and help sustain the protection his mother gave him. It also balances good and bad bacteria in the puppy’s gut to help him resist common puppy upsets\r\nContains DHA (an Omega 3 fatty acid) naturally found in mothers milk, important for brain and vision development\r\nContains key nutrients, such as Omega 3 and 6 fatty acids, which help shield puppies from environmental challenges and support the development of healthy skin and coat\r\n\r\n*Ishikawa H, Tabuchi H and Ohashi E (1998), Changes in the Serum immunoglobulin concentrations in puppies. J Vet Med Japan 51: 801 – 805.\r\n\r\nIs your dog pregnant?\r\n\r\nWe would suggest a gradual change over, from a normal food to a high energy food, which contains extra vitamins and minerals needed for the developing puppies, for the last trimester.\r\n\r\nA bitch's gestation period is approximately 9 weeks so this practically means, from about week 6 of pregnancy onwards, to support the development and growth of puppies, we would recommend the PRO PLAN puppy (except PRO PLAN Puppy large breed) products or performance as suitable according to your dog breed, size and lifestyle.\r\n\r\nYou should carefully monitor the body condition of your bitch because if she is only carrying one puppy she may be prone to put on weight and this could have an adverse affect on her ability to give birth.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Pro Plan"
                        withSelectOne:@"Puppy, Hair and Skin, Pregnant or Nursing Dog"
                         withFoodName:@"Puppy Sensitive Skin"
                            withImage:@"purinaProPlan.jpg"
                          withWebPage:@"http://www.purina-proplan.co.uk/Dogs/Puppy/SensitiveSalmonRice.aspx"
                  withFoodDescription:@"Suitable for small breed pregnant bitches from week 6 of pregnancy\r\n\r\nPRO PLAN® PUPPY SENSITIVE helps minimise skin and digestive discomfort that may be caused by common food sensitivities.\r\n\r\nComplete pet food for sensitive puppies.\r\n\r\nProduct Information\r\n\r\nFormulated with specific levels of Omega 3 fatty acids to help support sensitive skin. Helps reduce discomfort associated with skin sensitivity\r\nContains limited sources of protein† to help reduce the possible skin discomfort of sensitive puppies\r\nWith high levels of antioxidants, such as vitamin E & C, to help build a healthy immune system\r\n\r\n† Salmon, corn, rice and beet pulp.\r\n\r\nIs your dog pregnant?\r\n\r\nWe would suggest a gradual change over, from a normal food to a high energy food, which contains extra vitamins and minerals needed for the developing puppies, for the last trimester.\r\n\r\nA bitch's gestation period is approximately 9 weeks so this practically means, from about week 6 of pregnancy onwards, to support the development and growth of puppies, we would recommend the PRO PLAN puppy (except PRO PLAN Puppy large breed) products or performance as suitable according to your dog breed, size and lifestyle.\r\n\r\nYou should carefully monitor the body condition of your bitch because if she is only carrying one puppy she may be prone to put on weight and this could have an adverse affect on her ability to give birth.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"X-Small, Mini"
                        withFoodBrand:@"Purina Pro Plan"
                        withSelectOne:@"Puppy, Optimal Care, Pregnant or Nursing Dog"
                         withFoodName:@"Puppy Small Breed Original"
                            withImage:@"purinaProPlan.jpg"
                          withWebPage:@"http://www.purina-proplan.co.uk/Dogs/Puppy/SmallChickenRice.aspx"
                  withFoodDescription:@"Suitable for small breed pregnant bitches from week 6 of pregnancy\r\n\r\nPRO PLAN® PUPPY SMALL BREED with OPRISTART®* is specially developed to provide complete and balanced nutrition with optimal levels of protein and fat and vitamins, to meet the special energy needs of small breeds. Complete pet food for small breed puppies under 10kg at Maturity.\r\n\r\nProduct Information\r\n\r\nFormulated with Colostrum, found in mother’s first milk, which helps support immune response and help sustain the protection his mother gave him. It also balances good and bad bacteria in the puppy’s gut to help him resist common puppy upsets\r\nHigh quality chicken and a special coating, to satisfy small dogs’ fussy appetite\r\nContains DHA (an Omega 3 fatty acid) naturally found in mothers milk, important for brain and vision development\r\n\r\n*Ishikawa H, Tabuchi H and Ohashi E (1998), Changes in the Serum immunoglobulin concentrations in puppies. J Vet Med Japan 51: 801 – 805\r\n\r\nIs your dog pregnant?\r\n\r\nWe would suggest a gradual change over, from a normal food to a high energy food, which contains extra vitamins and minerals needed for the developing puppies, for the last trimester.\r\n\r\nA bitch's gestation period is approximately 9 weeks so this practically means, from about week 6 of pregnancy onwards, to support the development and growth of puppies, we would recommend the PRO PLAN puppy (except PRO PLAN Puppy large breed) products or performance as suitable according to your dog breed, size and lifestyle.\r\n\r\nYou should carefully monitor the body condition of your bitch because if she is only carrying one puppy she may be prone to put on weight and this could have an adverse affect on her ability to give birth.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Pro Plan"
                        withSelectOne:@"Puppy, Stomach, Pregnant or Nursing Dog"
                         withFoodName:@"Puppy Sensitive Digestion"
                            withImage:@"purinaProPlan.jpg"
                          withWebPage:@"http://www.purina-proplan.co.uk/Dogs/Puppy/DigestionLambRice.aspx"
                  withFoodDescription:@"Suitable for all pregnant bitches from 6 weeks of pregnancy\r\n\r\nPRO PLAN® PUPPY DIGESTION with OPTISTART® is made with high quality ingredients and a special pro-digest formula with egg, natural clay and a blend of fibres to help support intestinal health.\r\n\r\nComplete pet food for puppies with delicate digestion.\r\n\r\nProduct Information\r\n\r\nFormulated with Colostrum, found in mother’s first milk, which helps support immune response and help sustain the protection his mother gave him. It also balances good and bad bacteria in the puppy’s gut to help him resist common puppy upsets\r\nFormulated with specific ingredients, such as eggs, clay and a special blend of fibres to help support the intestinal health and stool quality of puppies with a more sensitive digestion\r\nContains DHA (an Omega 3 fatty acid) naturally found in mothers milk, important for brain and vision development\r\n\r\n*Ishikawa H, Tabuchi H and Ohashi E (1998), Changes in the Serum immunoglobulin concentrations in puppies. J Vet Med Japan 51: 801 – 805\r\n\r\nIs your dog pregnant?\r\n\r\nWe would suggest a gradual change over, from a normal food to a high energy food, which contains extra vitamins and minerals needed for the developing puppies, for the last trimester.\r\n\r\nA bitch's gestation period is approximately 9 weeks so this practically means, from about week 6 of pregnancy onwards, to support the development and growth of puppies, we would recommend the PRO PLAN puppy (except PRO PLAN Puppy large breed) products or performance as suitable according to your dog breed, size and lifestyle.\r\n\r\nYou should carefully monitor the body condition of your bitch because if she is only carrying one puppy she may be prone to put on weight and this could have an adverse affect on her ability to give birth.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@"Large, Giant"
                        withFoodBrand:@"Purina Pro Plan"
                        withSelectOne:@"Puppy, Optimal Care"
                         withFoodName:@"Puppy Large Breed Robust"
                            withImage:@"purinaProPlan.jpg"
                          withWebPage:@"http://www.purina-proplan.co.uk/Dogs/Puppy/LargeRobustChickenRice.aspx"
                  withFoodDescription:@"PRO PLAN® PUPPY LARGE BREED ROBUST with OPTISTART®* formulated with L-Carnitine in combination with appropriate protein and fat levels to compensate for the lower metabolic rate of large breed puppies and to help maintain lean body mass.\r\n\r\nComplete pet food for large breed puppies with a robust physique (over 25kg at maturity).\r\n\r\nProduct Information\r\n\r\nFormulated with Colostrum, found in mother’s first milk, which helps support immune response and helps sustain the protection his mother gave him. It also balances good and bad bacteria in the puppy’s gut to help him resist common puppy upsets\r\nA combination of L-Carnitine and appropriate protein and fat levels to help support uniform growth for healthy joint development in robust physique puppies, which have a tendency to gain excess weight easily\r\nContains DHA (an Omega 3 fatty acid) naturally found in mother's milk, important for brain and vision development\r\nFor Larger breed robust dogs such as St Bernard, Newfoundland, Labrador Retreiver\r\n\r\n*Ishikawa H, Tabuchi H and Ohashi E (1998), Changes in the Serum immunoglobulin concentrations in puppies. J Vet Med Japan 51: 801 – 805.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"0-12 months, "
                          withDogSize:@" Large, Giant"
                        withFoodBrand:@"Purina Pro Plan"
                        withSelectOne:@"Puppy, Optimal Care, Vitality"
                         withFoodName:@"Puppy Large Breed Athletic"
                            withImage:@"purinaProPlan.jpg"
                          withWebPage:@"http://www.purina-proplan.co.uk/Dogs/Puppy/LargeAthleticLambRice.aspx"
                  withFoodDescription:@"PRO PLAN® PUPPY LARGE BREED ATHLETIC with OPTISTART®* is formulated to provide the specific protein, fat and vitamin B levels to fulfil the high energy levels needed by athletic puppies.\r\n\r\nComplete pet food for large breed puppies with an athletic physique (over 25kg at maturity).\r\n\r\nProduct Information\r\n\r\nFormulated with Colostrum found in mother’s first milk, which helps support immune response and balance the good and bad bacteria in the gut to help him resist common puppy upsets\r\nIncreased** levels of protein, fat and B vitamins to fulfil the higher energy needs of athletic physique puppies, which naturally have a higher metabolism\r\nContains DHA (an Omega 3 fatty acid) naturally found in mother's milk, important for brain and vision development\r\n* Ishikawa H, Tabuchi H and Ohashi E (1998), changes in the Serum immunoglobulin concentrations in puppies. J Vet Med Japan 51: 801 – 805.\r\n** Compared to Puppy Large Breed Robust.\r\n"];
    
    // Senior

    
    
    [self insertFoodProductWithDogAge:@"+6 years, "
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Pro Plan"
                        withSelectOne:@"Optimal Care, Longevity"
                         withFoodName:@"Senior 7+ Original"
                            withImage:@"purinaProPlan.jpg"
                          withWebPage:@"http://www.purina-proplan.co.uk/Dogs/SeniorDog/SeniorOriginalChickenAndRice.aspx"
                  withFoodDescription:@"PRO PLAN® Senior 7+ Original is proven to enhance his alertness, mental sharpness and help him stay active for longer.\r\n\r\nPro Plan® Senior Original 7+ is the first physiological diet to contain ANTI AGE - a nutrient blend proven* to improve cognitive function and mental alertness in senior dogs. The brain is an extremely active and hungry organ requiring large amounts of energy. Brain cells need a constant supply of glucose in order to function effectively. At approximately 7 years of age, the dog’s brain cells start to lose their ability to use glucose as an energy source which ultimately affects the brains function. The initial changes will be subtle and may not be noticeable at this age, but as the dog becomes older the brain gradually becomes slower and less alert. Discover a unique new formula for dogs aged 7 and over.\r\n\r\nOwners feeding their senior dogs on PRO PLAN® Senior Original 7+ with ANTI AGE have noticed:\r\n\r\n•   A greater interest in; playtime, family activities and walks\r\n•   Improved brain function; the dog is brighter and more alert.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"+6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Pro Plan"
                        withSelectOne:@"Hair and Skin, "
                         withFoodName:@"Senior 7+ Sensitive Skin"
                            withImage:@"purinaProPlan.jpg"
                          withWebPage:@"http://www.purina-proplan.co.uk/Dogs/SeniorDog/SeniorSensitiveSalmonAndRice.aspx"
                  withFoodDescription:@"PRO PLAN® Senior Sensitive is specially formulated for more sensitive senior dogs. Made with salmon as the main ingredient, a highly palatable coating and formulated without any other source of animal protein, which is ideal for sensitive dogs.\r\n\r\nProduct Information\r\n\r\nSENSIDERMA - With specific levels of Omega 3 fatty acids to help support sensitive skin. Helps reduce discomfort associated with skin sensitivity\r\nHIGH TOLERANCE FORMULA - Contains limited sources of protein† to help reduce possible skin discomfort\r\nPRO IMMUNE - Enhanced levels of antioxidants to help fight the challenges of ageing.\r\n\r\n*Salmon, corn, rice and beet pulp.\r\n"];
    
    
    // Adult

    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Pro Plan"
                        withSelectOne:@"Optimal Care"
                         withFoodName:@"Adult Original"
                            withImage:@"purinaProPlan.jpg"
                          withWebPage:@"http://www.purina-proplan.co.uk/Dogs/AdultDog/OriginalChickenAndRice.aspx"
                  withFoodDescription:@"PRO PLAN® Adult ORIGINAL provides complete nutrition for protection for adult dogs.\r\n\r\nComplete pet food for adult dogs.\r\n\r\nProduct Information\r\nA natural source of prebiotics, that helps to increase bifidobacteria‡ in the intestine, encouraging a healthier digestive tract and promoting overall health\r\nWith high levels of antioxidants, such as vitamins E & C, to support a healthy immune system\r\nContains key nutrients, such as Omega 3 and 6 fatty acids, to help shield dogs from environmental challenges and help support healthy skin and coat\r\n\r\n‡ Middelbos et al., 2007. J. Anim. Sci. 85:3033-3044.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Minit"
                        withFoodBrand:@"Purina Pro Plan"
                        withSelectOne:@"Optimal Care"
                         withFoodName:@"Adult Small Breed Original"
                            withImage:@"purinaProPlan.jpg"
                          withWebPage:@"http://www.purina-proplan.co.uk/Dogs/AdultDog/SmallBreedChickenAndRice.aspx"
                  withFoodDescription:@"PRO PLAN® ADULT SMALL BREED is specially formulated for adult small dogs with a weight of 10kg or less.\r\n\r\nComplete pet food for small breed adult dogs.\r\n\r\nProduct Information\r\nA natural source of prebiotics, that help to increase bifidobacteria‡ in the intestine, encouraging a healthier digestive tract and promoting overall health\r\nHigh quality chicken and a special coating, to satisfy small dogs’ fussy appetite\r\nContains key nutrients, such as Omega 3 and 6 fatty acids, which help shield dogs from environmental challenges and support the development of healthy skin and coat\r\n\r\n‡ Middelbos et al., 2007. J. Anim. Sci. 85:3033-3044.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Pro Plan"
                        withSelectOne:@"Vitality, Pregnant or Nursing Dog"
                         withFoodName:@"Adult Performance Original"
                            withImage:@"purinaProPlan.jpg"
                          withWebPage:@"http://www.purina-proplan.co.uk/Dogs/AdultDog/PerformanceOriginalChickenAndRice.aspx"
                  withFoodDescription:@"Suitable for active and working dogs and pregnant bitches from week 6 of pregnancy\r\n\r\nPRO PLAN® PERFORMANCE is formulated to meet the specific energy needs of active and working dogs of all breed sizes. Performance provides a balance of carbohydrates, protein and fat to ensure a steady energy supply during extensive exercise which help delay the onset of fatigue. Made with high quality chicken and highly digestible rice as the main ingredients, it provides your dog with complete nutrition for a lifetime of natural protection.\r\n\r\nProduct Information\r\nHigh protein levels to help improve the oxygen metabolism of working dogs. This helps dogs use fat more efficiently during long lasting exercise, helping delay the onset of fatigue\r\nHelps replace amino acids used during exercise to facilitate rapid muscle recovery\r\nWith antioxidants to help neutralise free radicals that are produced by the increased oxygen metabolism of working dogs\r\n\r\nIs your dog pregnant?\r\n\r\nWe would suggest a gradual change over, from a normal food to a high energy food, which contains extra vitamins and minerals needed for the developing puppies, for the last trimester.\r\n\r\nA bitch's gestation period is approximately 9 weeks so this practically means, from about week 6 of pregnancy onwards, to support the development and growth of puppies, we would recommend the PRO PLAN puppy (except PRO PLAN Puppy large breed) products or performance as suitable according to your dog breed, size and lifestyle.\r\n\r\nYou should carefully monitor the body condition of your bitch because if she is only carrying one puppy she may be prone to put on weight and this could have an adverse affect on her ability to give birth.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, Giant"
                        withFoodBrand:@"Purina Pro Plan"
                        withSelectOne:@"Vitality, Optimal Care"
                         withFoodName:@"Adult Large Breed Athletic"
                            withImage:@"purinaProPlan.jpg"
                          withWebPage:@"http://www.purina-proplan.co.uk/Dogs/AdultDog/LargeAthleticLambAndRice.aspx"
                  withFoodDescription:@"PRO PLAN® ADULT LARGE BREED ATHLETIC has specifically adapted protein levels to help to fulfil the higher energy needs of athletic physique dogs.\r\nComplete pet food for adult large breed dogs with an athletic physique (over 25kg at maturity).\r\n\r\nProduct Information\r\nA natural source of prebiotics, that helps to increase bifidobacteria‡ in the intestine, encouraging a healthier digestive tract and promoting overall health\r\nIncreased* levels of protein, fat and B vitamins to fulfill the higher energy needs of athletic physique dogs, which naturally have a higher metabolism\r\n\r\n‡ Middelbos et al., 2007. J. Anim. Sci. 85:3033-3044.\r\n* Compared to Adult Large Breed Robust Dogs.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"Large, Giant"
                        withFoodBrand:@"Purina Pro Plan"
                        withSelectOne:@"Optimal Care"
                         withFoodName:@"Adult Large Breed Robust"
                            withImage:@"purinaProPlan.jpg"
                          withWebPage:@"http://www.purina-proplan.co.uk/Dogs/AdultDog/LargeRobustChickenAndRice.aspx"
                  withFoodDescription:@"PRO PLAN® ADULT LARGE BREED ROBUST is formulated for a lower metabolic rate and contains a special combination of L-Carnitine and appropriate fat levels to help maintain lean body mass.\r\n\r\nComplete Pet Food for Adult Large Breed Robust Dogs (Over 25KG at maturity).\r\n\r\nProduct Information\r\nA natural source of prebiotics, that helps to increase bifidobacteria‡ in the intestine, encouraging a healthier digestive tract and promoting overall health\r\nA combination of L-Carnitine with appropriate protein and fat levels to help control the deposit of fat and help reduce stress on joints, as large dogs of robust physique tend to put on weight\r\n\r\n‡ Middelbos et al., 2007. J. Anim. Sci. 85:3033-3044.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Pro Plan"
                        withSelectOne:@"Overweight"
                         withFoodName:@"Light Original"
                            withImage:@"purinaProPlan.jpg"
                          withWebPage:@"http://www.purina-proplan.co.uk/Dogs/AdultDog/LightChickenAndRice.aspx"
                  withFoodDescription:@"PRO PLAN® ADULT LIGHT is formulated to meet the nutritional needs of adult dogs of any breed size that are prone to gain weight with only 9% fat for slightly overweight adult dogs.\r\n\r\nComplete pet food for dogs with the tendancy to be overweight.\r\n\r\nProduct Information\r\nHigh protein, low fat formula (45% less fat on average compared to PRO PLAN® Adult formulas) PROVEN* to help reduce body weight by 8% in just 6 weeks, while maintaining lean body mass\r\nContains long chain Omega 3 fatty acids, to help support joint health and encourage mobility of overweight dogs. May help to reduce heart stress while walking and at rest\r\nHigh protein content, complex carbohydrates and adequate levels of fibre, to help promote a sense of fullness\r\nA healthy weight and a lean body condition are important to your dog's health and quality of life. We recommend that you keep your dog in ideal body condition and not allow him to become overweight\r\n\r\n*Results of a weight management programme on 15 overweight dogs of varying breeds fed PRO PLAN® LIGHT and given a 30 minute daily walk (Nestlé Purina PetCare PTC, 2008).\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Pro Plan"
                        withSelectOne:@"Stomach, "
                         withFoodName:@"Adult Digestion"
                            withImage:@"purinaProPlan.jpg"
                          withWebPage:@"http://www.purina-proplan.co.uk/Dogs/AdultDog/DigestionLambAndRice.aspx"
                  withFoodDescription:@"PRO PLAN® ADULT DIGESTION is made with high quality lamb with rice and a special pro-digest formula to help support intestinal health.\r\n\r\nComplete pet food for adult dogs with delicate digestion.\r\n\r\nProduct Information\r\nA natural source of prebiotics, that helps to increase bifidobacteria‡ in the intestine, encouraging a healthier digestive tract and promoting overall health\r\nFormulated with specific ingredients, such as eggs, clay and a special blend of fibres to help support the intestinal health and stool quality of dogs with a more sensitive digestion\r\nContains key nutrients, such as Omega 3 and 6 fatty acids, to help shield dogs from environmental challenges and help support healthy skin and coat\r\n\r\n‡ Middelbos et al., 2007. J. Anim. Sci. 85:3033-3044.\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Pro Plan"
                        withSelectOne:@"Overweight"
                         withFoodName:@"Light Digestion"
                            withImage:@"purinaProPlan.jpg"
                          withWebPage:@"http://www.purina-proplan.co.uk/Dogs/AdultDog/LightDigestionLambAndRice.aspx"
                  withFoodDescription:@"PRO PLAN® LIGHT DIGESTION is complete nutrition for protection with only 9% fat for slightly overweight adult dogs of any breed size that are prone to weight gain and have a sensitive digestion.\r\n\r\nProduct Information\r\nHigh protein, low fat formula (45% less fat on average compared to PRO PLAN® Adult formulas) PROVEN* to help reduce body weight by 8% in just 6 weeks, while maintaining lean body mass\r\nFormulated with specific ingredients, such as eggs, clay and a special blend of fibres to help support the intestinal health and stool quality of dogs with a more sensitive digestion\r\nContains long chain Omega 3 fatty acids, to help support joint health and encourage mobility of overweight dogs. May help to reduce heart stress while walking and at rest\r\nWe recommend that you keep your dog in ideal body condition and not allow him to become overweight\r\n\r\n*Results of a weight management programme on 15 overweight dogs of varying breeds fed PRO PLAN® LIGHT and given a 30 minute daily walk (Nestlé Purina PetCare PTC, 2008).\r\n"];
    
    
    
    
    [self insertFoodProductWithDogAge:@"12-24 months, 2-6 years, +6 years"
                          withDogSize:@"X-Small, Mini, Medium, Large, Giant"
                        withFoodBrand:@"Purina Pro Plan"
                        withSelectOne:@"Hair and Skin"
                         withFoodName:@"Adult Sensitive Skin"
                            withImage:@"purinaProPlan.jpg"
                          withWebPage:@"http://www.purina-proplan.co.uk/Dogs/AdultDog/SensitiveSalmonAndRice.aspx"
                  withFoodDescription:@"PRO PLAN® ADULT SENSITIVE is formulated with limited protein sources to help minimise skin and coat discomfort.\r\n\r\nComplete pet food for more sensitive adult dogs.\r\n\r\nProduct Information\r\nWith specific levels of Omega 3 fatty acids to help support sensitive skin. Helps reduce discomfort associated with skin sensitivity\r\nContains limited sources of protein† to help reduce the possible skin discomfort of sensitive dogs\r\nWith high levels of antioxidants, such as vitamin E & C, to help support a healthy immune system\r\n\r\n† Salmon, corn, rice and beet pulp.\r\n"];
    
   
  
    
    
    
// BRANDS NEXT VERSION  ////////////////////////
    
#pragma mark - Eukanuba Naturally Wild     
#pragma mark - Eukanuba Lamb & Rice    
#pragma mark - Hill's Science Plan VetEssentials    
#pragma mark - Hill's Nature's Best     
#pragma mark - Affinity Advance  
     
    
    /*
     [self insertFoodProductWithDogAge:@""
     withDogSize:@""
     withFoodBrand:@""
     withSelectOne:@""
     withFoodName:@""
     withImage:@""
     withWebPage:@""
     withFoodDescription:@"\r\n"];     
     */
    
    NSLog(@"Importing Core Data Default Values Completed!");
    NSLog(@"Wooooooooohhhhaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa! Yeaaaaa Yeaaaaa Yeaaaaaa");
}

@end


