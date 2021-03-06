//
//  GMDogBreedTableViewController.m
//  DogFood
//
//  Created by  on 06/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GMDogBreedTableViewController.h"

@interface GMDogBreedTableViewController ()

@end

@implementation GMDogBreedTableViewController
{
    NSArray *dogBreeds;
    NSUInteger selectedIndex;

    BOOL healthCarePressed;
    BOOL medicinePressed;
}

@synthesize delegate, dogBreed, firstLevel;
@synthesize labelSelectOne;
@synthesize healthCarePressed, medicinePressed, breedPressed;

@synthesize selectOne;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customView];    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PropertyList" ofType:@"plist"];    
    firstLevel = [[NSDictionary alloc] initWithContentsOfFile:path];    
    dogBreeds = [firstLevel objectForKey:@"DogBreed"];    

    selectedIndex = [dogBreeds indexOfObject:self.dogBreed];    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dogBreeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DogBreedCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Custom the cell
    cell.backgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"fg100.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ]; 
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    // Add text to cell
    cell.textLabel.text = [dogBreeds objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = @"";    
    
    // Checkmark dog breed selected    
    if (indexPath.row == selectedIndex)
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	else
		cell.accessoryType = UITableViewCellAccessoryNone; 
    
    // Uncheck - Uncheck if the user has selected the button Reset in the main view
    // or if the user has selected one of the other two options.
    if ((medicinePressed || healthCarePressed) || ([selectOne isEqualToString:@"Select One"]))
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Change the color in the row with the text 'None'
    if ( [cell.textLabel.text isEqualToString:@"None"]) 
    {            
        [cell.textLabel setTextColor:[UIColor blueColor]];
    }
    else 
    {
        [cell.textLabel setTextColor:[UIColor blackColor]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (selectedIndex != NSNotFound)
	{
		UITableViewCell *cell = [tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	selectedIndex = indexPath.row;
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
	NSString *theDogBreed = [dogBreeds objectAtIndex:indexPath.row];
	[self.delegate gMDogBreedTableViewController:self didSelectDogBreed:theDogBreed];
}

# pragma mark - stuff - Custom view

- (void) customView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 120, 24)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Didot-Bold" size:24.0];
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor =[UIColor whiteColor];
    label.text=@"Dog Breed";
    self.navigationItem.titleView = label;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.opaque = NO;
}

@end
