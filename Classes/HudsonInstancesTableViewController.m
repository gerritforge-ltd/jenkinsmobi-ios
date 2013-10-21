// Copyright (C) 2012 LMIT Limited
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and 
// limitations under the License.

#import "HudsonInstancesTableViewController.h"
#import "ChoiceWallViewController.h"

@implementation HudsonInstancesTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

	[Configuration getInstance];
    
    [[self navigationController] setNavigationBarHidden:NO];
    
	UIBarButtonItem* buttonAdd  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																				target:self action:@selector(onAddNewHudsonInstance:)];
    [self.navigationItem setRightBarButtonItem:buttonAdd];
	[buttonAdd release];
	
	[self.navigationItem setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@ instances",nil),[[Configuration getInstance] targetCIProductName]]];
    
    int viewControllersCount = [[self.navigationController viewControllers] count];
    if([[[self.navigationController viewControllers] objectAtIndex:viewControllersCount-2] isKindOfClass:[ChoiceWallViewController class]]){

        UIBarButtonItem* wallButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(onWallButtonClick:)];
        [wallButton setImage:[UIImage imageNamed:@"more_icon"]];
        [self.navigationItem setLeftBarButtonItem:wallButton];
        [wallButton release];
    }else{
        
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back",nil) style:UIBarButtonItemStyleBordered target:self action:@selector(onWallButtonClick:)];
        [self.navigationItem setLeftBarButtonItem:backButton];
        [backButton release];
    }
}

-(IBAction)onWallButtonClick:(id)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
}
	 
-(void)onAddNewHudsonInstance:(id)sender{
	
	ConfigurationObject* confObject = [[ConfigurationObject alloc] init];
	NSString* filename = [NSString stringWithFormat:@"%@.%d",CONFIGURATION_FILENAME,[[[Configuration getInstance] hudsonInstances] count]];
	[confObject setFilename:filename];
	
	[[[Configuration getInstance] hudsonInstances] addObject:confObject];
	[[Configuration getInstance] saveConfiguration];
	
	UIConfigurationViewController *anotherViewController = [[UIConfigurationViewController alloc] initWithNibName:@"UIConfigurationViewController" bundle:nil andConfigurationObject:confObject];
	[self.navigationController pushViewController:anotherViewController animated:YES];
	[anotherViewController release];
	
	[confObject release];
}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
	
	if([[[[Configuration getInstance] hudsonInstances] lastObject] hudsonHostname]==nil||
       [[[[[Configuration getInstance] hudsonInstances] lastObject] hudsonHostname] length]==0){
	
		[[[Configuration getInstance] hudsonInstances] removeLastObject];
		[[Configuration getInstance] saveConfiguration];
	}
	
	[self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

    return YES;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[Configuration getInstance] hudsonInstances] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    ConfigurationObject* confObject = [[[Configuration getInstance] hudsonInstances] objectAtIndex:indexPath.row];
	
	[[cell textLabel] setText:[confObject description]];
	
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	ConfigurationObject* confObject = [[[Configuration getInstance] hudsonInstances] objectAtIndex:indexPath.row];
	UIConfigurationViewController *anotherViewController = [[UIConfigurationViewController alloc] 
															initWithNibName:@"UIConfigurationViewController" bundle:nil andConfigurationObject:confObject];
	[self.navigationController pushViewController:anotherViewController animated:YES];
	[anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
}


@end

