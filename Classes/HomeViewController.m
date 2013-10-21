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

#import "HomeViewController.h"

#import "ProjectListViewController.h"
#import "HudsonView.h"
#import "Reachability.h"
#import "SimpleReachabiliyChecker.h"

@implementation HomeViewController

@synthesize background,instancesTableView,infoDarkButton;

- (void)viewDidLoad {
    [super viewDidLoad];

	firstScrolledToViewLastInstanceIndex = NO;

    [[self instancesTableView] setBackgroundView:nil];
    [[self instancesTableView] setBackgroundView:[[[UIView alloc] init] autorelease]];
    [[self instancesTableView] setBackgroundColor:[UIColor clearColor]];
    
    if([[[Configuration getInstance] targetCIProductName] isEqualToString:@"Hudson"]){
        [[self background] setImage:[UIImage imageNamed:@"home-background-hudson.png"]];
    }else if([[[Configuration getInstance] targetCIProductName] isEqualToString:@"Jenkins"]){
        [[self background] setImage:[UIImage imageNamed:@"home-background-jenkins.png"]];
    }
        
	Configuration* configuration = [Configuration getInstance];
	[configuration setViewToUpdateOnConnectionChange:self];
    forceNotCheckInstancesReachability = YES;
    
    if([configuration eulaAccepted]==NO){
    
        EulaViewer *controller = [[EulaViewer alloc] initWithNibName:@"EulaViewer" bundle:nil];
        [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [controller setDelegate:self];
        [self presentModalViewController:controller animated:YES];
        [controller release];
    }else{
    
        [configuration checkConnections];
    }
}

-(void)onEulaViewDismissed{
    
    Configuration* configuration = [Configuration getInstance];
    if([configuration eulaAccepted]==YES){

        [configuration checkConnections];
        
    }else{
        
        ;
    }
}

-(void) viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES];
    
    if(!forceNotCheckInstancesReachability){
        [self checkInstancesReachability];
    }
    
    forceNotCheckInstancesReachability = NO;
}

-(void)checkInstancesReachability{
    Configuration* configuration = [Configuration getInstance];
    int i=0;
    
    for (ConfigurationObject* confObject in [configuration hudsonInstances]) {
        
        [confObject setLastTimeWasOnline:@"U"];
        SimpleReachabiliyChecker* checker = [[[SimpleReachabiliyChecker alloc] init] autorelease];
        if([[confObject portNumber] length]!=0){
            [checker isHostAlive:[NSString stringWithFormat:@"%@://%@:%@",[confObject protocol],[confObject hudsonHostname],[confObject portNumber]]:@selector(onRemoteInstanceConnectionChanged::):self:i];
        }else{
            [checker isHostAlive:[NSString stringWithFormat:@"%@://%@",[confObject protocol],[confObject hudsonHostname]]
                                :@selector(onRemoteInstanceConnectionChanged::):self:i];
        }
        i++;
    }
}

//Called by Reachability whenever status changes.
-(void)onRemoteInstanceConnectionChanged:(NSString*)result:(int)instanceIdx{
	
	[Logger info:@"Network status change occurs"];
    
    UITableViewCell* cell = [self.instancesTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:instanceIdx inSection:0]];
    
    Configuration* conf = [Configuration getInstance];
    ConfigurationObject* confObject = [[conf hudsonInstances] objectAtIndex:instanceIdx];
    
    BOOL updated = NO;
    
    if([result isEqualToString:@"error"]){
        [Logger info:[NSString stringWithFormat:@"%@ is not alive",[confObject hudsonHostname]]];
        [confObject setLastTimeWasOnline:@"N"];
        [[cell imageView] setImage:[UIImage imageNamed:@"offline4.png"]];
        updated = YES;
        
    }else if([result isEqualToString:@"ok"]){

        [Logger info:[NSString stringWithFormat:@"%@ is alive",[confObject hudsonHostname]]];
        [confObject setLastTimeWasOnline:@"Y"];
        [[cell imageView] setImage:[UIImage imageNamed:@"connected4.png"]];
        updated = YES;
    }
    
    if(updated){
        [self.instancesTableView reloadData];
    }
}


- (void)viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];
}


-(void)onNetworkStatusChange{

    [self checkInstancesReachability];
}

- (void)flipsideViewControllerDidFinish:(ProductInfoViewController*) controller{
	
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)showInfo:(id)sender{
	
    forceNotCheckInstancesReachability = YES;
    
	ProductInfoViewController *controller = [[ProductInfoViewController alloc] initWithNibName:@"ProductInfoViewController" bundle:nil];
	[controller setDelegate:self];
	[controller setNavController:self.navigationController];
	[controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

- (IBAction) configButtonClick:(id)sender{
	
    forceNotCheckInstancesReachability = NO;
	HudsonInstancesTableViewController *anotherViewController = [[HudsonInstancesTableViewController alloc] initWithStyle:UITableViewStylePlain];
	[self.navigationController pushViewController:anotherViewController animated:YES];
	[anotherViewController release];    
}

-(IBAction) loginButtonClick:(id)sender{
	
	NSString* username=[[Configuration getInstance] username];
	NSString* password=[[Configuration getInstance] password];
	
    loadingView = [LoadingView loadingViewInView:[self view] andTitle:NSLocalizedString(@"Connecting...",nil)];
    //workaround to allow basic auth in other application layers
    [[Configuration getInstance] setPassword:password];
    
    loginObject = [[HudsonLoginObject alloc] init];
    [loginObject setDelegate:self];
    [loginObject doLoginWithUsernane:username andPassword:password];
}

-(void)onAuthorizationGranted{
	
	[loadingView removeView];
	[[Configuration getInstance] saveConfiguration];
	
    forceNotCheckInstancesReachability = YES;

    HudsonView* view = [[HudsonView alloc] init];
    [view setUrl:[[Configuration getInstance] url]]; 
    [view setName:@"All"];
    ProjectListViewController *anotherViewController = [[ProjectListViewController alloc] initWithNibName:@"ProjectListViewController" bundle:nil andView:view];
    [self.navigationController pushViewController:anotherViewController animated:YES];
    [anotherViewController release];
    [view release];
}

-(void)onAuthorizationDenied{
	
	if(loadingView!=nil){
		[loadingView removeView];
		loadingView=nil;
	}
	[loginObject release];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login error",nil) 
													message:NSLocalizedString(@"Authentication failed",nil)
												   delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
	[alert show];
	[alert release];
}

-(void)onLoadFinischedWithErrors{
	
	if(loadingView!=nil){
		[loadingView removeView];
		loadingView=nil;
	}
	[loginObject release];
}

-(void)onLoadFinisched{
	
	if(loadingView!=nil){
		[loadingView removeView];
		loadingView=nil;
	}
	[loginObject release];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	
    return [[[Configuration getInstance] hudsonInstances] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell* cell = nil;
	Configuration* configuration = [Configuration getInstance];
	static NSString *InstanceCellIdentifier = @"InstanceCell";

    cell = [tableView dequeueReusableCellWithIdentifier:InstanceCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InstanceCellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setFont:[UIFont boldSystemFontOfSize:15.f]];
    }
            
    ConfigurationObject* confObject = [[configuration hudsonInstances] objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[confObject description]];
    if([[confObject lastTimeWasOnline] isEqualToString:@"Y"]){
        [[cell imageView] setImage:[UIImage imageNamed:@"connected4.png"]];
    }else if([[confObject lastTimeWasOnline] isEqualToString:@"N"]){
        [[cell imageView] setImage:[UIImage imageNamed:@"offline4.png"]];
    }else if([[confObject lastTimeWasOnline] isEqualToString:@"U"]){
        [[cell imageView] setImage:[UIImage imageNamed:@"checking_connection.png"]];
    }
    
    return cell;
}
             
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    [self.instancesTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[Configuration getInstance] setSelectedConfigurationInstance:[indexPath row]];
    [self loginButtonClick:nil];
}


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


- (void)dealloc {
    [super dealloc];
}


@end
