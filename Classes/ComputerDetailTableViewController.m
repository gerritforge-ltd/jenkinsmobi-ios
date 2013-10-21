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

#import "ComputerDetailTableViewController.h"


@implementation ComputerDetailTableViewController


- (id)initWithStyle:(UITableViewStyle)style andComputerSet:(ComputerSet*)computerSet {

    self = [super initWithStyle:style];    
    if (self) {
		
		currentComputerSet = computerSet;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	[self.navigationItem setTitle:NSLocalizedString(@"Node status",nil)];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [self.tableView setTableFooterView:view];
    [view release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

	return YES;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
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

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	
	return 30.f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	
	UILabel* label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	[label setBackgroundColor:[UIColor lightGrayColor]];
	[label setFont:[UIFont boldSystemFontOfSize:15.f]];
	[label setTextColor:[UIColor whiteColor]];
	
	[label setText:[currentComputerSet displayName]];
	
	return label;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		[[cell textLabel] setFont:[UIFont boldSystemFontOfSize:14.f]];
		[[cell detailTextLabel] setFont:[UIFont boldSystemFontOfSize:14.f]];	
    }
    
	NSString* textCell=nil;
	NSString* detailTextCell=nil;	
	
	switch (indexPath.row) {
		case 0:
			textCell = NSLocalizedString(@"Node name",@"Node name");
			detailTextCell = [currentComputerSet displayName];
		break;
		case 1:
			textCell = NSLocalizedString(@"Operating System",@"Operating System");
			detailTextCell = [currentComputerSet architecture];
		break;
		case 2:
			textCell = NSLocalizedString(@"Status",@"Status");
			detailTextCell = ([currentComputerSet offline]||[currentComputerSet temporarilyOffline]) ? NSLocalizedString(@"OFF-LINE",@"OFF-LINE") : NSLocalizedString(@"ON-LINE",@"ON-LINE");
			if([currentComputerSet offline]||[currentComputerSet temporarilyOffline]){
				
				[[cell detailTextLabel] setTextColor:[UIColor redColor]];
			}else{
				[[cell detailTextLabel] setTextColor:[UIColor greenColor]];
			}
		break;
		case 3:
			textCell = NSLocalizedString(@"Number of executors",@"Number of executors");
			detailTextCell = [NSString stringWithFormat:@"%d",[currentComputerSet numExecutors]];
		break;
		case 4:
			textCell = NSLocalizedString(@"RAM available",@"RAM available");
			detailTextCell = [NSString stringWithFormat:NSLocalizedString(@"about %d MB",@"about %d MB"),[currentComputerSet availablePhysicalMemory]/(1024*1024)];
		break;
		case 5:
			textCell = NSLocalizedString(@"RAM total",@"RAM total");
			detailTextCell = [NSString stringWithFormat:NSLocalizedString(@"about %d MB",@"about %d MB"),[currentComputerSet totalPhysicalMemory]/(1024*1024)];			
		break;
		case 6:
			textCell = NSLocalizedString(@"SWAP available",@"SWAP total");
			detailTextCell = [NSString stringWithFormat:NSLocalizedString(@"about %d MB",@"about %d MB"),[currentComputerSet availableSwapSpace]/(1024*1024)];		
		break;
		case 7:
			textCell = NSLocalizedString(@"SWAP total",@"SWAP total");
			detailTextCell = [NSString stringWithFormat:NSLocalizedString(@"about %d MB",@"about %d MB"),[currentComputerSet totalSwapSpace]/(1024*1024)];				
		break;
		default:
			break;
	}

	[[cell textLabel] setText:textCell];
	[[cell detailTextLabel] setText:detailTextCell];	
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
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

