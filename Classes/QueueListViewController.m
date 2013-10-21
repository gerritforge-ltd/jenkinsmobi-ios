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

#import "QueueListViewController.h"

@implementation QueueListViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
		queueList = [[HudsonQueue alloc] init];
		[queueList setDelegate:self];
        
        hudsonObjectToReload =  queueList;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	loadingView = [LoadingView loadingViewInView:[self view]];

	[queueList loadHudsonObject];

    [self.navigationItem setTitle:NSLocalizedString(@"Build queue",nil)];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [self.tableView setTableFooterView:view];
    [view release];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	
	return YES;//interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation==UIInterfaceOrientationIsLandscape;
}

- (void)viewShouldReload {

	if(loadedData==YES){
		[self onRefresh:nil];
	}
}

-(void)onRefresh:(id)sender{
	
	loadingView = [LoadingView loadingViewInView:[self view] andTitle:NSLocalizedString(@"Refreshing...",nil)];
	
	loadedData = NO;
	[queueList loadHudsonObject];
}
									  
-(void)onLoadFinisched{
	
	loadedData = YES;
	[tableView reloadData];
	
    if(loadingView!=nil){
        [loadingView removeFromSuperview];
        loadingView = nil;
    }
    
    [self doneLoadingTableViewData];
}

-(void)onLoadFinischedWithErrors{
	
	[loadingView removeFromSuperview];
}

#pragma mark Table view methods


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[queueList queueItems] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
	if(loadedData){
        if([[queueList queueItems] count]>0){
            HudsonQueueItem* queueItem = [[queueList queueItems] objectAtIndex:[indexPath row]];
            [[cell textLabel] setText:[queueItem name]];
        }
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if(!loadedData){
        return;
    }
    
	HudsonQueueItem* queueItem = [[queueList queueItems] objectAtIndex:[indexPath row]];
	QueueItemViewDetail *anotherViewController = [[QueueItemViewDetail alloc] initWithStyle:UITableViewStylePlain andQueueItem:queueItem];
	[self.navigationController pushViewController:anotherViewController animated:YES];
	[anotherViewController release];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[queueList release];
    [super dealloc];
}


@end
