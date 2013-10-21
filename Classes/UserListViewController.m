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

#import "UserListViewController.h"


@implementation UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	userList = [[HudsonUserList alloc] init];
    
    hudsonObjectToReload = userList;
    
	loadingView = [LoadingView loadingViewInView:[self view]];
	
	[userList setDelegate:self];
	[userList loadHudsonObject];
    
    [self.navigationItem setTitle:NSLocalizedString(@"Users",nil)];
    
    /*
    UIBarButtonItem* showMoreBuildsButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Load more",nil)
                                                                             style:UIBarButtonItemStyleBordered target:self 
																			action:@selector(onShowUsersButtonClick:)];
	[self.navigationItem setRightBarButtonItem:showMoreBuildsButton];
	[showMoreBuildsButton release];
     */
     
    searchDisplayController = [[UISearchDisplayController alloc]
							   initWithSearchBar:searchBar contentsController:self];
	searchDisplayController.searchResultsDataSource = self;
	searchDisplayController.searchResultsDelegate = self;
    [[searchDisplayController searchBar] setHidden:YES];
	self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
}

-(void)onShowUsersButtonClick:(id)sender{

    [Logger debug:@"Loading more users"];
	/*
	loadingView = [LoadingView loadingViewInView:[self view] andTitle:
				   [NSString stringWithFormat:NSLocalizedString(@"Loading %d more users...",nil),
					[[Configuration getInstance] maxBuildsNumberToLoadAtTime]]];
	loadedData = NO;
	[userList setDelegate:self];
	[userList loadNextUsers:
    [[Configuration getInstance] maxBuildsNumberToLoadAtTime]];
     */
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

	endSearchBarEditing=NO;
	[userList setFilter:nil];
	[tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	
	if(endSearchBarEditing==NO){
		[userList setFilter:searchText];
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
	
    [userList setFilter:nil];
	endSearchBarEditing=YES;
}

-(void)onLoadFinisched{
	
	loadedData = YES;		
	[self.tableView reloadData];
	
    if(loadingView!=nil){
        [loadingView removeFromSuperview];
        loadingView = nil;
    }
    
    [self doneLoadingTableViewData];
    
     self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
    [[searchDisplayController searchBar] setHidden:NO];
}

-(void)onLoadFinischedWithErrors{
	
	[loadingView removeFromSuperview];
}

#pragma mark Table view methods

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [[userList userList] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		[[cell imageView] setImage:[UIImage imageNamed:@"user.png"]];
	}
	
	if(loadedData){
		
		if([indexPath row] >= [[userList userList] count]){
			[userList setFilter:nil];
		}
		
        if([[userList userList] count]>0){
            HudsonUser* user = [[userList userList] objectAtIndex:[indexPath row]];
            [[cell textLabel] setText:[user name]];
        }
	}
	
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if(!loadedData){
        return;
    }
    
	endSearchBarEditing=YES;
	[searchDisplayController setActive:NO animated:YES];
	
	HudsonUser* user = [[userList userList] objectAtIndex:[indexPath row]];
	UserDetailViewController *anotherViewController = [[UserDetailViewController alloc] initWithStyle:UITableViewStyleGrouped andUser:user];
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
	
	[userList release];
    [searchDisplayController release];
    [super dealloc];
}


@end
