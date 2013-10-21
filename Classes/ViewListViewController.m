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

#import "ViewListViewController.h"

#import "ChoiceWallViewController.h"

@implementation ViewListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:NSLocalizedString(@"Views",@"Views")];
    
	loadingView = [LoadingView loadingViewInView:[self view]];
	
	viewList = [[HudsonViewList alloc] init];
    
    hudsonObjectToReload = viewList;
    
	[viewList setDelegate:self];
	[viewList loadHudsonObject];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [self.tableView setTableFooterView:view];
    [view release];
}

-(IBAction)onWallButtonClick:(id)sender{
    
    //check to see if we need to create a new choice view controller
    if([[Configuration getInstance] isWallLoaded]==YES){
        
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        ChoiceWallViewController *anotherViewController = [[ChoiceWallViewController alloc] initWithNibName:@"ChoiceWallViewController" bundle:nil];
        [self.navigationController pushViewController:anotherViewController animated:NO];
        [anotherViewController release];
    }
}

-(void)onLoadFinisched{

	if([SimpleHTTPGetter getLastHttpStatusCode]!=200){
        
        shouldDisappearOnError = YES;
        if(loadingView!=nil){
            [loadingView removeFromSuperview];
            loadingView = nil;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection error",@"Connection error") 
                                                        message:NSLocalizedString(@"A server error has occurred: try to disable \"Use XPATH\" from configuration and retry",nil)
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        [alert release];
        
		return;
	}
	//remove primaryView from views
	HudsonView* viewToRemove = [[HudsonView alloc] init];
	[viewToRemove setName:[[viewList primaryView] name]];
	[[viewList views] removeObject:viewToRemove];
	[viewToRemove release];
	
	loadedData = YES;
	[self.tableView reloadData];
	
    if(loadingView!=nil){
        [loadingView removeFromSuperview];
        loadingView = nil;
    }
    
    [self doneLoadingTableViewData];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onLoadFinischedWithErrors{
    
    if(loadingView!=nil){
        [loadingView removeFromSuperview];
        loadingView = nil;
    }
	[self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	
	return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	
	UILabel* label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	[label setBackgroundColor:[UIColor lightGrayColor]];
	[label setFont:[UIFont boldSystemFontOfSize:15.f]];
	[label setTextColor:[UIColor whiteColor]];
	
	if(section==0){
	
		[label setText:NSLocalizedString(@"Primary view",nil)];
	}else{
		
		[label setText:NSLocalizedString(@"Other views",nil)];
	}

	return label;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	if(section==0){
	
		return 1;
	}else{
		return [[viewList views] count];
	}
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
		HudsonView* view = nil;
		if(indexPath.section==0){
		
			view = [viewList primaryView];
		}else if(indexPath.section==1 && [[viewList views] count]>0){
			view = [[viewList views] objectAtIndex:[indexPath row]];
		}
		[[cell textLabel] setText:[view name]];			
	}
	
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if(!loadedData){
        return;
    }
    
	HudsonView* view = nil;
	
	if(indexPath.section==0){
	
		view = [viewList primaryView];
        
	}else{
		view = [[viewList views] objectAtIndex:[indexPath row]];
	}
	
	
	ProjectListViewController *anotherViewController = [[ProjectListViewController alloc] initWithNibName:@"ProjectListViewController" bundle:nil andView:view];
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
	
	[viewList release];
	
    [super dealloc];
}

@end
