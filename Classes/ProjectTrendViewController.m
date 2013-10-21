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

#import "ProjectTrendViewController.h"


@implementation ProjectTrendViewController

@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andProject:(HudsonProject*)project{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

		currentProject = project;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.navigationItem setTitle:NSLocalizedString(@"Build history",nil)];
	
	UIBarButtonItem* showMoreBuildsButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Load more",nil)
																		  style:UIBarButtonItemStyleBordered target:self 
																			action:@selector(onShowMoreBuildsButtonClick:)];
	[self.navigationItem setRightBarButtonItem:showMoreBuildsButton];
	[showMoreBuildsButton release];
	
	loadingView = [LoadingView loadingViewInView:[self view]];
	
	loadedData = NO;
	[currentProject setDelegate:self];
	[currentProject loadTrendUpToBuilds:5];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [self.tableView setTableFooterView:view];
    [view release];
}

#pragma Deselect the eventually selected table row
- (void)viewWillAppear:(BOOL)animated
{
    if(self.tableView!=nil){
        NSIndexPath*	selection = [self.tableView indexPathForSelectedRow];
        if (selection){
            [self.tableView deselectRowAtIndexPath:selection animated:YES];
        }
    }
}

-(void)onShowMoreBuildsButtonClick:(id)sender{
	
	[Logger debug:@"Loading more history builds"];
	
	loadingView = [LoadingView loadingViewInView:[self view] andTitle:
				   [NSString stringWithFormat:NSLocalizedString(@"Loading %d more builds...",nil),
					[[Configuration getInstance] maxBuildsNumberToLoadAtTime]]];
	loadedData = NO;
	[currentProject setDelegate:self];
	[currentProject loadTrendNextBuilds:
    [[Configuration getInstance] maxBuildsNumberToLoadAtTime]];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

	return YES;
}

-(void)onLoadFinisched{
	
	loadedData=YES;
	[tableView reloadData];
	
	if(loadingView!=nil){
		[loadingView removeFromSuperview];
		loadingView = nil;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	
	return 30.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	
	UILabel* label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	[label setBackgroundColor:[UIColor lightGrayColor]];
	[label setFont:[UIFont boldSystemFontOfSize:15.f]];
	[label setTextColor:[UIColor whiteColor]];
	
	if(section==0){
		[label setText:[NSString stringWithFormat:NSLocalizedString(@"History of: %@",nil),[currentProject name]]];
	}
	
	return label;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	return 1; 
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[currentProject trend] trendItemList] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	static NSString *CellNoDetailIdentifier = @"CellNoDetail";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
    
	if(loadedData){
		
		HudsonProjectTrendItem* trendItem = [[[currentProject trend] trendItemList] objectAtIndex:[indexPath row]];
		
		if([trendItem totalTests]>0 && ([trendItem totalFailed]>0 || [trendItem totalSkipped]>0)){
			
			[[cell textLabel] setText:[NSString stringWithFormat:@"Build #%d - %@",[trendItem number],[trendItem buildDate]]];
			[[cell detailTextLabel] setText:[NSString stringWithFormat:NSLocalizedString(@"Failed tests %d on %d (%d skipped)",nil),
											 [trendItem totalFailed],[trendItem totalTests],[trendItem totalSkipped]]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:16.f]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue]; 
		}else{
			
			cell = [tableView dequeueReusableCellWithIdentifier:CellNoDetailIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellNoDetailIdentifier] autorelease];         
				[[cell textLabel] setFont:[UIFont boldSystemFontOfSize:16.f]];
			}
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];            
			[[cell textLabel] setText:[NSString stringWithFormat:@"Build #%d - %@",[trendItem number],[trendItem buildDate]]];
            [[cell detailTextLabel] setText:NSLocalizedString(@"No failed tests",nil)];
		}
		
		if([[trendItem result] isEqualToString:@"FAILURE"]){
			[[cell imageView] setImage:[UIImage imageNamed:@"red.png"]];
		}else if([[trendItem result] isEqualToString:@"SUCCESS"]){
			[[cell imageView] setImage:[UIImage imageNamed:@"blue.png"]];
		}else if([[trendItem result] isEqualToString:@"UNSTABLE"]){
			[[cell imageView] setImage:[UIImage imageNamed:@"yellow.png"]];
		}else {
			[[cell imageView] setImage:[UIImage imageNamed:@"grey.png"]];
		}
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	HudsonProjectTrendItem* trendItem = [[[currentProject trend] trendItemList] objectAtIndex:[indexPath row]];
    
    if([trendItem totalTests]>0 && ([trendItem totalFailed]>0 || [trendItem totalSkipped]>0)){
        FailedTestListTableViewController *anotherViewController = [[FailedTestListTableViewController alloc] initWithStyle:UITableViewStylePlain andProjectTrendItem:trendItem];
        [self.navigationController pushViewController:anotherViewController animated:YES];
        [anotherViewController release];
    }
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


- (void)dealloc {
	
	[[[currentProject trend] trendItemList] removeAllObjects];
    [super dealloc];
}


@end
