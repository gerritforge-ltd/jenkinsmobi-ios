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

#import "ProjectListViewController.h"


@implementation ProjectListViewController

@synthesize inProgressFilterButton,filterBarView, searchBar, currentView;

- (id)initWithNibName:(NSString*)nib bundle:(NSBundle*) bundle andView:(HudsonView*)view {
    
    self = [super initWithNibName:nib bundle:bundle];
    if (self) {
		
		[self setCurrentView:view];
		loadedData = NO;
        keepBackButton = YES;
	}
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	
	//load now specific job data
    [[self navigationController] setNavigationBarHidden:NO];
	[self.navigationItem setTitle:NSLocalizedString(@"View detail",@"View detail")];
    
    [self.filterBarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"graybar.png"]]];

    int viewControllersCount = [[self.navigationController viewControllers] count];
    if(![[[self.navigationController viewControllers] objectAtIndex:viewControllersCount-2] isKindOfClass:[ViewListViewController class]]){
        [self.navigationItem setHidesBackButton:YES];
        UIBarButtonItem* wallButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(onWallButtonClick:)];
        [wallButton setImage:[UIImage imageNamed:@"more_icon"]];    
        [self.navigationItem setLeftBarButtonItem:wallButton];
        [wallButton release];
    }

    UIBarButtonItem* allButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"All",nil) style:UIBarButtonItemStyleBordered target:self action:@selector(onAllBuildTabButtonClick:)];
    [self.navigationItem setRightBarButtonItem:allButton];
    [allButton release];
    
	loadingView = [LoadingView loadingViewInView:[self view]];
	
    hudsonObjectToReload = currentView;
    
	[currentView setDelegate:self];
	[currentView loadHudsonObject];
	
	searchDisplayController = [[UISearchDisplayController alloc]
						initWithSearchBar:searchBar contentsController:self];
	searchDisplayController.searchResultsDataSource = self;
	searchDisplayController.searchResultsDelegate = self;
	
    self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [self.tableView setTableFooterView:view];
    [view release];
    
    AnimatedGif2* animatedGif = [[AnimatedGif2 alloc] initWithImageBasename:@"blue_anime"];
    [animatedGif storeAnimation:[inProgressFilterButton imageView]];
    [animatedGif release];
}

-(IBAction)onWallButtonClick:(id)sender{
    
    wallViewController = [[ChoiceWallViewController alloc] initWithNibName:@"ChoiceWallViewController" bundle:nil];
    [self performSelector:@selector(animateTransition:) withObject:[NSNumber numberWithFloat: TIME_FOR_EXPANDING]];
}

#pragma ANIMATION
-(void)animateTransition:(NSNumber *)duration{
	self.view.userInteractionEnabled=NO;
	[[self view] addSubview:wallViewController.view];
	if ((wallViewController.view.hidden==false) && ([duration floatValue]==TIME_FOR_EXPANDING)) {
		wallViewController.view.frame=[[UIScreen mainScreen] bounds];
		wallViewController.view.transform=CGAffineTransformMakeScale(SCALED_DOWN_AMOUNT, SCALED_DOWN_AMOUNT);
	}
	wallViewController.view.hidden=false;
    
    [UIView beginAnimations:@"animationExpand" context:NULL];
    [UIView setAnimationDuration:[duration floatValue]];
    wallViewController.view.transform=CGAffineTransformMakeScale(1, 1);

	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView commitAnimations];
}

-(void)animationDidStop:(NSString *)animationID finished:(BOOL)finished context:(void *)context{
	self.view.userInteractionEnabled=YES;
    [[self navigationController] pushViewController:wallViewController animated:NO];
    [wallViewController release];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	
	return YES;//interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation==UIInterfaceOrientationIsLandscape;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	
	endSearchBarEditing=NO;
	[currentView setFilter:nil];
	[tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	
	if(endSearchBarEditing==NO){
		[currentView setFilter:searchText];
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
	
    [currentView setFilter:nil];
	endSearchBarEditing=YES;
	[tableView reloadData];
}

-(void)onLoadFinisched{
			
	loadedData = YES;
	[self.tableView reloadData];
	
	if(loadingView!=nil){
		[loadingView removeFromSuperview];
		loadingView=nil;
	}
    
    [self doneLoadingTableViewData];
    
     self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
}

-(void)onLoadFinischedWithErrors{

	if(loadingView!=nil){
		[loadingView removeFromSuperview];
		loadingView=nil;
	}
	//[navigationController popViewControllerAnimated:YES];
}

-(IBAction)onInProgressBuldTabButtonClick:(id)sender{
	
	[currentView setFilter:@"inprogress"];
	[self onLoadFinisched];	
}

-(IBAction)onSuccessfulBuildTabButtonClick:(id)sender{

	[currentView setFilter:@"stable"];
	[self onLoadFinisched];
}

-(IBAction)onFailedBuildTabButtonClick:(id)sender{
	
	[currentView setFilter:@"failed"];
	[self onLoadFinisched];	
}

-(IBAction)onAllBuildTabButtonClick:(id)sender{
	
	[currentView setFilter:nil];	
	[self onLoadFinisched];	
}

-(IBAction)onUnstableBuildTabButtonClick:(id)sender{
	
	[currentView setFilter:@"unstable"];	
	[self onLoadFinisched];	
}

-(IBAction)onAbortedBuildTabButtonClick:(id)sender{
	
	[currentView setFilter:@"aborted"];	
	[self onLoadFinisched];	
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];


	if(loadedData){
		[self.tableView reloadData];
	}
}

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
	
	return 0.f;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[currentView jobs] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ProjectListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
	
	if(loadedData){
		
		if([indexPath row] >= [[currentView jobs] count]){
			
			[currentView setFilter:nil];
		}
		
        if([[currentView jobs] count]>0){
            HudsonProject* job = [[currentView jobs] objectAtIndex:[indexPath row]];
            [(ProjectListTableViewCell*)cell setCurrentProject:job];
        }
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if(!loadedData){
        return;
    }
    
	HudsonProject* job = [[currentView jobs] objectAtIndex:[indexPath row]];
	ProjectDetailViewController *anotherViewController = [[ProjectDetailViewController alloc] initWithNibName:@"ProjectDetailViewController" bundle:nil andProject:job];
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
	
    [searchDisplayController release];
	[[currentView jobs] removeAllObjects];
    [super dealloc];
}


@end

