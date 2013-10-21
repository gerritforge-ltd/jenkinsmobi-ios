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

#import "AbstractViewController.h"

@implementation AbstractViewController

@synthesize tableView;

-(void)viewDidLoad{

    [super viewDidLoad];
    
   // if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	//}

	[_refreshHeaderView refreshLastUpdatedDate];
    
    if(!keepBackButton){
        UIBarButtonItem* wallButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(onWallButtonClick:)];
        [wallButton setImage:[UIImage imageNamed:@"more_icon"]];
        [self.navigationItem setLeftBarButtonItem:wallButton];
        [wallButton release];
    }
    
    loadedData = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
	return YES;
}

-(IBAction)onWallButtonClick:(id)sender{
    
    [hudsonObjectToReload stopLoad];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma Deselect the eventually selected table row
- (void)viewWillAppear:(BOOL)animated
{
	// Unselect the selected row if any
    if(self.tableView!=nil){
        NSIndexPath*	selection = [self.tableView indexPathForSelectedRow];
        if (selection){
            [self.tableView deselectRowAtIndexPath:selection animated:YES];
        }
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    if(!_reloading){
        _reloading = YES;
        loadedData = NO;
        [hudsonObjectToReload loadHudsonObject];
    }
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
    if(_reloading){
        _reloading = NO;
        loadedData = YES;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (void)dealloc {
    
    [_refreshHeaderView release];
    
    [super dealloc];
}

@end
