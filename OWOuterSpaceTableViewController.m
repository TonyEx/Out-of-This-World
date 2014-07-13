//
//  OWOuterSpaceTableViewController.m
//  Out of this World
//
//  Created by Tony Angelo on 6/19/14.
//  Copyright (c) 2014 Tony Angelo. All rights reserved.
//

#import "OWOuterSpaceTableViewController.h"
#import "AstronomicalData.h"
#import "OWSpaceObject.h"
#import "OWSpaceImageViewController.h"
#import "OWSpaceDataViewController.h"


@interface OWOuterSpaceTableViewController ()

@end

@implementation OWOuterSpaceTableViewController


#pragma mark - Lazy Instantiation of properties

-(NSMutableArray *) planets
{
	if (!_planets) {
		_planets = [[NSMutableArray alloc] init];
	}
	
	return _planets;
}


-(NSMutableArray *)addedSpaceObjects
{
	if(!_addedSpaceObjects)
		_addedSpaceObjects = [[NSMutableArray alloc] init];
	
	return _addedSpaceObjects;
}


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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	
	for(NSMutableDictionary *planetData in [AstronomicalData allKnownPlanets])
	{
		NSString *imageName = [NSString stringWithFormat:@"%@.jpg", planetData[PLANET_NAME]];
		
		OWSpaceObject *planet = [[OWSpaceObject alloc] initWithData:planetData andImage:[UIImage imageNamed:imageName]];
		[self.planets addObject:planet];
	}
	
//	NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc ] init];
//	
//	NSString *firstColor = @"red";
//	
//	[myDictionary setObject:firstColor forKey: @"Firetruck Color"];
//	[myDictionary setObject:@"blue" forKey:@"oceanColor"];
//	[myDictionary setObject:@"yellow" forKey:@"starColor"];
//	NSLog(@"%@", myDictionary);
//	
//	NSString *blueString = [myDictionary objectForKey:@"oceanColor"];
//	NSLog(@"%@", blueString);
	
//	NSNumber *myNumber = [ NSNumber numberWithInt:5];
//	NSLog(@"%@", myNumber);
//	
//	NSNumber *floatNumber = [ NSNumber numberWithFloat:3.141592654];
//	NSLog(@"%@", floatNumber);
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([sender isKindOfClass:[UITableViewCell class]])
	{
		if ([segue.destinationViewController isKindOfClass:[OWSpaceImageViewController class]])
		{
			OWSpaceImageViewController *nextViewController = segue.destinationViewController;
			NSIndexPath *path = [self.tableView indexPathForCell:sender];
			
			OWSpaceObject *selectedObject;
			
			if(path.section == 0)
				selectedObject = self.planets[path.row];
			else if (path.section == 1)
				selectedObject = self.addedSpaceObjects[path.row];
			
			
			nextViewController.spaceObject = selectedObject;
			
		}
	}
	
	
	if ([sender isKindOfClass:[NSIndexPath class]])
	{
		if ([segue.destinationViewController isKindOfClass:[OWSpaceDataViewController class]])
		{
			OWSpaceDataViewController *targetViewController = segue.destinationViewController;
			NSIndexPath *path = sender;
			OWSpaceObject *selectedObject;
			
			if(path.section == 0)
				selectedObject = self.planets[path.row];
			else if (path.section == 1)
				selectedObject = self.addedSpaceObjects[path.row];
			
			targetViewController.spaceObject = selectedObject;
		}
	}
	
	
	if ([segue.destinationViewController isKindOfClass:[OWAddSpaceObjectViewController class]])
	{
		OWAddSpaceObjectViewController *addSpaceObjectVC = segue.destinationViewController;
		addSpaceObjectVC.delegate = self;
	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - OWAddSpaceObjectViewController Delegate

-(void)didCancel
{
	NSLog(@"didCancel");
	[self dismissViewControllerAnimated:YES completion:nil];
}


-(void)addSpaceObject:(OWSpaceObject *)spaceObject
{
	NSLog(@"addSpaceObject");
	
	[self.addedSpaceObjects addObject:spaceObject];
	[self.tableView reloadData];
	
	[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
	
	if ([self.addedSpaceObjects count])
		return 2;
	else
	    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
	
	if (section == 0)
		return [self.planets count];
	else
		return [self.addedSpaceObjects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
	if(indexPath.section == 0)
	{
		OWSpaceObject *planet = [self.planets objectAtIndex:indexPath.row];
	
		cell.textLabel.text = planet.name;
		cell.detailTextLabel.text = planet.nickname;
		cell.imageView.image = planet.spaceImage;
	}
	else
	{
		OWSpaceObject *planet = self.addedSpaceObjects[indexPath.row];
		cell.textLabel.text = planet.name;
		cell.detailTextLabel.text = planet.nickname;
		cell.imageView.image = planet.spaceImage;
		
	}
	
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
	cell.backgroundColor = [UIColor clearColor];
	
    return cell;
}


#pragma mark UITableView Delegagte

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"Accessory button is working %i", indexPath.row);
	[self performSegueWithIdentifier:@"pushToSpaceData" sender:indexPath];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
