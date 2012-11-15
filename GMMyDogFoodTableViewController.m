//
//  GMMyDogFoodTableViewController.m
//  DogFood
//
//  Created by  on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GMMyDogFoodTableViewController.h"
#import "AppDelegate.h"

@interface GMMyDogFoodTableViewController ()

@end

@implementation GMMyDogFoodTableViewController

@synthesize dogAge, foodBrand, dogSize, healthCare, dogBreed, medicine, selectOne;
@synthesize fetchedResultsController, managedObjectContext;
@synthesize objects;
@synthesize queryingDogAge1, queryingFoodBrand1, queryingDogSize1, queryingSelectOne1;
@synthesize queryingDogAge2, queryingFoodBrand2, queryingDogSize2, queryingSelectOne2;
@synthesize foodProductsSegue;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
    
    // Alert if no data  for the parameters selected and go back
    
    if ([objects count]==0)
    {
        [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"fgg101.png"]]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@".DogFood" message:@"Sorry, no results were found. Go back and change your parameters." delegate:self cancelButtonTitle:@"Go back" otherButtonTitles:nil];
		
		[alert show];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customView];  
    
    [self prepareStringsForQuerying];   
         
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyDogFoodCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Custom the cell
    cell.backgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"fg100.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    UIImageView *imageV = (UIImageView *)[cell viewWithTag:200];
    UILabel *labelBrand = (UILabel *)[cell viewWithTag:300];
    
    // Fetch database
    FoodProducts *foodProducts = [self.fetchedResultsController objectAtIndexPath:indexPath];    
    
    // Add text to cell
    label.text = foodProducts.foodName;
    imageV.image = [UIImage imageNamed:foodProducts.image];
    labelBrand.text = foodProducts.foodBrand;    
    
    return cell;
}


# pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    
    if ([segue.identifier isEqualToString:@"detail"])
	{
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        GMDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.foodProductsSegue = [objects objectAtIndex:selectedRowIndex.row];        
	}
}

# pragma mark - AlertView Delegate and Go Back

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // the user click Go back
    if (buttonIndex == 0)
    {
        NSLog(@"Go Back");
        [self.navigationController popViewControllerAnimated:YES];
    }    
}

#pragma mark - Core Data

- (void)setupFetchedResultsController
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    
    
    // 1 - Decide what Entity you want
    NSString *entityName = @"FoodProducts"; // Put your entity name here
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    // 2 - Request that Entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 3 - Filter the database depending the data we've got    
    
    //0000
    if ( ([queryingDogAge1 isEqualToString:@"1"]) &&
        ([queryingDogSize1 isEqualToString:@"2"]) &&
        ([queryingFoodBrand1 isEqualToString:@"3"]) &&
        ([queryingSelectOne1 isEqualToString:@"4"]) )
        
    {
        NSLog(@"Predicate:  %@", request.predicate);
    }
    
    //1000
    else if  ( !([queryingDogAge1 isEqualToString:@"1"]) &&
              ([queryingDogSize1 isEqualToString:@"2"]) &&
              ([queryingFoodBrand1 isEqualToString:@"3"])  &&
              ([queryingSelectOne1 isEqualToString:@"4"])  )
    {
        request.predicate = [NSPredicate predicateWithFormat:@"(dogAge contains (%@))", dogAge];
        NSLog(@"Predicate:  %@", request.predicate);
    }
    
    //1100
    else if  ( ([queryingDogAge1 isEqualToString:@"dogAge"]) &&
              ([queryingDogSize1 isEqualToString:@"dogSize"]) &&
              ([queryingFoodBrand1 isEqualToString:@"3"])  &&
              ([queryingSelectOne1 isEqualToString:@"4"])  )
    {
        request.predicate = [NSPredicate predicateWithFormat:@"(dogAge contains (%@)) AND (dogSize contains (%@))",dogAge,  dogSize];
        NSLog(@"Predicate:  %@", request.predicate);
    }
    
    //0100
    else if  ( ([queryingDogAge1 isEqualToString:@"1"]) &&
              ([queryingDogSize1 isEqualToString:@"dogSize"]) &&
              ([queryingFoodBrand1 isEqualToString:@"3"])  &&
              ([queryingSelectOne1 isEqualToString:@"4"])  )
    {
        request.predicate = [NSPredicate predicateWithFormat:@" (dogSize contains (%@))",  dogSize];
        NSLog(@"Predicate:  %@", request.predicate);
    }
    
    //0010
    else if ( ([queryingDogAge1 isEqualToString:@"1"]) &&
             ([queryingDogSize1 isEqualToString:@"2"]) &&
             ([queryingFoodBrand1 isEqualToString:@"foodBrand"])  &&
             ([queryingSelectOne1 isEqualToString:@"4"])  )
    {
        request.predicate = [NSPredicate predicateWithFormat:@"(foodBrand==(%@))", foodBrand];
        NSLog(@"Predicate:  %@", request.predicate);
    }
    
    //1010
    else if  ( ([queryingDogAge1 isEqualToString:@"dogAge"]) &&
              ([queryingDogSize1 isEqualToString:@"2"]) &&
              ([queryingFoodBrand1 isEqualToString:@"foodBrand"])  &&
              ([queryingSelectOne1 isEqualToString:@"4"])  )
    {
        request.predicate = [NSPredicate predicateWithFormat:@"(dogAge contains (%@)) AND (foodBrand==(%@))", dogAge, foodBrand];
        NSLog(@"Predicate:  %@", request.predicate);
    }
    
    //1110
    else if  ( ([queryingDogAge1 isEqualToString:@"dogAge"]) &&
              ([queryingDogSize1 isEqualToString:@"dogSize"]) &&
              ([queryingFoodBrand1 isEqualToString:@"foodBrand"])  &&
              ([queryingSelectOne1 isEqualToString:@"4"])  )
    {
        request.predicate = [NSPredicate predicateWithFormat:@"(dogAge contains (%@)) AND (dogSize contains (%@))  AND (foodBrand==(%@)) ",dogAge,  dogSize, foodBrand];
        NSLog(@"Predicate:  %@", request.predicate);
    }
    
    //0110
    else if  ( ([queryingDogAge1 isEqualToString:@"1"]) &&
              ([queryingDogSize1 isEqualToString:@"dogSize"]) &&
              ([queryingFoodBrand1 isEqualToString:@"foodBrand"])  &&
              ([queryingSelectOne1 isEqualToString:@"4"])  )
    {
        request.predicate = [NSPredicate predicateWithFormat:@" (dogSize contains (%@))  AND (foodBrand==(%@))",  dogSize, foodBrand];
        NSLog(@"Predicate:  %@", request.predicate);
    }
    
    //0001
    else if ( ([queryingDogAge1 isEqualToString:@"1"]) &&
             ([queryingDogSize1 isEqualToString:@"2"]) &&
             ([queryingFoodBrand1 isEqualToString:@"3"])  &&
             (![queryingSelectOne1 isEqualToString:@"4"])  )
        
    {
        request.predicate = [NSPredicate predicateWithFormat:@"(selectOne contains (%@))", selectOne];
        NSLog(@"Predicate:  %@", request.predicate);
    }
    
    //1001
    else if  ( ([queryingDogAge1 isEqualToString:@"dogAge"]) &&
              ([queryingDogSize1 isEqualToString:@"2"]) &&
              ([queryingFoodBrand1 isEqualToString:@"3"])  &&
              (![queryingSelectOne1 isEqualToString:@"4"])  )
    {
        request.predicate = [NSPredicate predicateWithFormat:@"(dogAge contains (%@)) AND (selectOne contains (%@))", dogAge, selectOne];
        NSLog(@"Predicate:  %@", request.predicate);
    }
    
    //1101
    else if  ( ([queryingDogAge1 isEqualToString:@"dogAge"]) &&
              ([queryingDogSize1 isEqualToString:@"dogSize"]) &&
              ([queryingFoodBrand1 isEqualToString:@"3"])  &&
              (![queryingSelectOne1 isEqualToString:@"4"])  )
    {
        request.predicate = [NSPredicate predicateWithFormat:@"(dogAge contains (%@)) AND (dogSize contains (%@)) AND (selectOne contains (%@))",dogAge,  dogSize, selectOne];
        NSLog(@"Predicate:  %@", request.predicate);
    }
    
    //0101
    else if  ( ([queryingDogAge1 isEqualToString:@"1"]) &&
              ([queryingDogSize1 isEqualToString:@"dogSize"]) &&
              ([queryingFoodBrand1 isEqualToString:@"3"])  &&
              (![queryingSelectOne1 isEqualToString:@"4"])  )
    {
        request.predicate = [NSPredicate predicateWithFormat:@" (dogSize contains (%@)) AND (selectOne contains(%@))",  dogSize, selectOne];
        NSLog(@"Predicate:  %@", request.predicate);
    }
    
    //0011
    else if ( ([queryingDogAge1 isEqualToString:@"1"]) &&
             ([queryingDogSize1 isEqualToString:@"2"]) &&
             ([queryingFoodBrand1 isEqualToString:@"foodBrand"])  &&
             (![queryingSelectOne1 isEqualToString:@"4"])  )
    {
        request.predicate = [NSPredicate predicateWithFormat:@"(foodBrand==(%@)) AND (selectOne contains (%@))", foodBrand, selectOne];
        NSLog(@"Predicate:  %@", request.predicate);
    }
    
    //1011
    else if  ( ([queryingDogAge1 isEqualToString:@"dogAge"]) &&
              ([queryingDogSize1 isEqualToString:@"2"]) &&
              ([queryingFoodBrand1 isEqualToString:@"foodBrand"])  &&
              (![queryingSelectOne1 isEqualToString:@"4"])  )
    {
        request.predicate = [NSPredicate predicateWithFormat:@"(dogAge contains (%@)) AND (foodBrand==(%@)) AND (selectOne contains (%@))", dogAge, foodBrand, selectOne];
        NSLog(@"Predicate:  %@", request.predicate);
    }
    
    //1111
    else if  ( ([queryingDogAge1 isEqualToString:@"dogAge"]) &&
              ([queryingDogSize1 isEqualToString:@"dogSize"]) &&
              ([queryingFoodBrand1 isEqualToString:@"foodBrand"])  &&
              (![queryingSelectOne1 isEqualToString:@"4"])  )
    {
        request.predicate = [NSPredicate predicateWithFormat:@"(dogAge contains (%@)) AND (dogSize contains (%@))  AND (foodBrand==(%@))  AND (selectOne contains (%@))",dogAge,  dogSize, foodBrand, selectOne];
        NSLog(@"Predicate:  %@", request.predicate);
    }
    
    //0111
    else if  ( ([queryingDogAge1 isEqualToString:@"1"]) &&
              ([queryingDogSize1 isEqualToString:@"dogSize"]) &&
              ([queryingFoodBrand1 isEqualToString:@"foodBrand"])  &&
              (![queryingSelectOne1 isEqualToString:@"4"])  )
    {
        request.predicate = [NSPredicate predicateWithFormat:@" (dogSize contains (%@))  AND (foodBrand==(%@)) AND (selectOne contains (%@))",  dogSize, foodBrand, selectOne];
        NSLog(@"Predicate:  %@", request.predicate);
    }
    
    // 4 - Sort data
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"foodName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],
                               [NSSortDescriptor sortDescriptorWithKey:@"foodBrand" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],
                               [NSSortDescriptor sortDescriptorWithKey:@"dogAge" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]
                               , nil];
    
    // 5 - Fetch it
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    objects = [context executeFetchRequest:request error:&error];    
    
    [self performFetch];
}

#pragma mark - Core Data stuff - preparing strings for querying

- (void) prepareStringsForQuerying
{
    //preparing strings for querying
    if (([dogAge isEqualToString:@"Age"]) || ([dogAge isEqualToString:@"None"]))
    {
        queryingDogAge1 = @"1";
        queryingDogAge2 = @"1";
    }
    else
    {
        queryingDogAge1 = @"dogAge";
        
    }
    
    if (([dogSize isEqualToString:@"Size"]) || ([dogSize isEqualToString:@"None"]))
    {
        queryingDogSize1 = @"2";
        queryingDogSize2 = @"2";
    }
    else
    {
        queryingDogSize1 = @"dogSize";
    }
    
    if (([foodBrand isEqualToString:@"Brand"]) || ([foodBrand isEqualToString:@"None"]))
    {
        queryingFoodBrand1 = @"3";
        queryingFoodBrand2 = @"3";
    }
    else
    {
        queryingFoodBrand1 = @"foodBrand";
    }
    
    if (([selectOne isEqualToString:@"Select One"]) || ([selectOne isEqualToString:@"None"]))
    {
        queryingSelectOne1 = @"4";
        queryingSelectOne1 = @"4";
    }
    else
    {
        queryingSelectOne1 = @"selectOne";
    }
}

# pragma mark - stuff - Custom view

- (void) customView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 190, 24)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Didot-Bold" size:24.0];
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor =[UIColor whiteColor];
    label.text=@"Your .DogFoods ";
    self.navigationItem.titleView = label;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.opaque = NO;
    
    self.tableView.rowHeight=60;

}

@end