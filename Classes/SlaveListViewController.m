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
#import "SlaveListViewController.h"

@implementation SlaveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	computerSetList = [[ComputerSetList alloc] init];
	
    hudsonObjectToReload = computerSetList;

	loadingView = [LoadingView loadingViewInView:[self view]];
	
	[computerSetList setDelegate:self];
	[computerSetList loadHudsonObject];
	
    [self.navigationItem setTitle:NSLocalizedString(@"Nodes",nil)];
}

-(void)onLoadFinisched{
			
	loadedData = YES;
	[self.tableView reloadData];
	
    if(loadingView!=nil){
        [loadingView removeFromSuperview];
        loadingView = nil;
    }
    
    [self doneLoadingTableViewData];
}

-(void)onLoadFinischedWithErrors{
	
	[loadingView removeFromSuperview];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [[computerSetList computers] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *ComputerCellIdentifier = @"ComputerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ComputerCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ComputerCellIdentifier] autorelease];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	
	if(loadedData){
        
        if([[computerSetList computers] count]>0){
            ComputerSet* computerSet = [[computerSetList computers] objectAtIndex:[indexPath row]];
            [[cell textLabel] setText:[computerSet displayName]];
            [[cell detailTextLabel] setText:[NSString stringWithFormat:NSLocalizedString(@"%d executors - %@",@"%d executors - %@"),[computerSet numExecutors],[computerSet architecture]]];

            NSString *computerImage = [computerSet colorName];
            [[cell imageView] setImage:[UIImage imageNamed:[computerImage stringByReplacingOccurrencesOfString: @"gif" withString: @"png"]]];
        }
	}
	
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if(!loadedData){
        return;
    }
    
	ComputerSet* computerSet = [[computerSetList computers] objectAtIndex:[indexPath row]];
	ComputerDetailTableViewController *anotherViewController = [[ComputerDetailTableViewController alloc] initWithStyle:UITableViewStylePlain andComputerSet:computerSet];
	[self.navigationController pushViewController:anotherViewController animated:YES];
	[anotherViewController release];
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
	
	[computerSetList release];
	
    [super dealloc];
}


@end
