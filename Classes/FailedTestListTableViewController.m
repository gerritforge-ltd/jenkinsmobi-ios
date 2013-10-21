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

#import "FailedTestListTableViewController.h"

@implementation FailedTestListTableViewController

- (id)initWithStyle:(UITableViewStyle)style andProjectTrendItem:(HudsonProjectTrendItem*)trendItem{

    if (self = [super initWithStyle:style]) {
		
		currentProjectTrendItem = trendItem;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.navigationItem setTitle:NSLocalizedString(@"Failed tests",nil)];
	
	loadingView = [LoadingView loadingViewInView:[self view]];
	
	loadedData = NO;

	[currentProjectTrendItem setDelegate:self];
	[currentProjectTrendItem loadFailedTests:0:100];
	[currentProjectTrendItem loadHudsonObject];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.tableView.tableFooterView = view;
}
	 
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

	return YES;
}

-(void)onLoadFinischedWithErrors{
	
	if(loadingView!=nil){
		[loadingView removeFromSuperview];
		loadingView = nil;
	}
}

-(void)onLoadFinisched{
	
	loadedData=YES;
	
	[self.tableView reloadData];
	
	if(loadingView!=nil){
		[loadingView removeFromSuperview];
		loadingView = nil;
	}
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
    return 44.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    int result = 0;
    if(loadedData){
        result = [[currentProjectTrendItem failedTests] count];
        
        if(result == 0){
            
            result = 1;
        }
    }
        
    return result;
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *TestCellIdentifier = @"TestCell";	
    
    UITableViewCell *cell = nil;
    
	if(loadedData){
		
		if([[currentProjectTrendItem failedTests] count]==0){
		
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            
			[[cell textLabel] setTextAlignment:UITextAlignmentCenter];
			[[cell textLabel] setText:NSLocalizedString(@"No failed tests",nil)];
		}else{
			
			cell = [tableView dequeueReusableCellWithIdentifier:TestCellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TestCellIdentifier] autorelease];
				[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                [[cell textLabel] setLineBreakMode:UILineBreakModeHeadTruncation];
			}
			
			HudsonTest* test = [[currentProjectTrendItem failedTests] objectAtIndex:[indexPath row]];
            [[cell textLabel] setText:[test name]];
            [[cell detailTextLabel] setText:[NSString stringWithFormat:NSLocalizedString(@"Failed since #%d - %@",nil),[test failedSince], [test status]]];
		}
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.row < [[currentProjectTrendItem failedTests]count]){
        HudsonTest* test = [[currentProjectTrendItem failedTests] objectAtIndex:[indexPath row]];
        if([test url]==nil){
            [test setUrl:[NSString stringWithFormat:@"%@/testReport",[[currentProjectTrendItem parent] url]]];
        }
        FailedTestDetailViewController *anotherViewController = [[FailedTestDetailViewController alloc] initWithStyle:UITableViewStylePlain andTest:test];
        [self.navigationController pushViewController:anotherViewController animated:YES];
        [anotherViewController release];
    }
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
	
	[[currentProjectTrendItem failedTests] removeAllObjects];
    [super dealloc];
}


@end

