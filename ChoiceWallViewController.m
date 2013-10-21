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

#import "ChoiceWallViewController.h"

@implementation ChoiceWallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[Configuration getInstance] setIsWallLoaded:YES];
    }
    return self;
}

- (void)dealloc
{
    if(loginObject!=nil){
        [loginObject release];
        loginObject = nil;
    }
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationItem setHidesBackButton:YES];
    
    [self.navigationItem setTitle:[[Configuration getInstance] productName]];
    
    UIBarButtonItem* logoutButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Logout", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(onLogoutClick:)];
    [self.navigationItem setRightBarButtonItem:logoutButton];
    [logoutButton release];
    
    UIBarButtonItem* settingsButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(onSettingsClick:)];
    [settingsButton setImage:[UIImage imageNamed:@"settings_new"]];
    [self.navigationItem setLeftBarButtonItem:settingsButton];
    [settingsButton release];
    
    bool isCloudBees = [[[Configuration getInstance] hudsonHostname] rangeOfString:@"cloudbees"].location != NSNotFound;
    
    if(!isCloudBees){
    
        [runAtCloudeWallItem setHidden:YES];
        [runAtCloudWallItemLabel setHidden:YES];
    }
    
    [usersWallItemLabel setText:NSLocalizedString(@"Users", nil)];
    [monitorWallItemLabel setText:NSLocalizedString(@"Monitor", nil)];
    [queueWallItemLabel setText:NSLocalizedString(@"Queue", nil)];
    [nodesWallItemLabel setText:NSLocalizedString(@"Nodes", nil)];
    [viewsWallItemLabel setText:NSLocalizedString(@"Views", nil)];
    [runAtCloudWallItemLabel setText:NSLocalizedString(@"run@cloud", nil)];
}

-(void)viewWillAppear:(BOOL)animated {
	[self performSelector:@selector(animateTransition:) withObject:[NSNumber numberWithFloat: TIME_FOR_SHRINKING]];
}


-(IBAction) onViewsClick:(id)sender{
    
    viewController = [[ViewListViewController alloc] initWithNibName:@"ViewListViewController" bundle:nil];
    [self performSelector:@selector(animateTransition:) withObject:[NSNumber numberWithFloat: TIME_FOR_EXPANDING]];
    
}

-(IBAction) onUsersClick:(id)sender{
    
    viewController = [[UserListViewController alloc] initWithNibName:@"UserListViewController" bundle:nil];
    [self performSelector:@selector(animateTransition:) withObject:[NSNumber numberWithFloat: TIME_FOR_EXPANDING]];
}

-(IBAction) onMonitorClick:(id)sender{
    
    //TODO
}

-(IBAction) onRunAtCloudClick:(id)sender{
  /*  
    viewController=[[CloudBeesApplicationListViewController alloc] initWithNibName:@"CloudBeesApplicationListViewController" bundle:nil];
    [self performSelector:@selector(animateTransition:) withObject:[NSNumber numberWithFloat: TIME_FOR_EXPANDING]];
   */
}

-(IBAction) onNodesClick:(id)sender{
    
    viewController=[[SlaveListViewController alloc] initWithNibName:@"SlaveListViewController" bundle:nil];
    [self performSelector:@selector(animateTransition:) withObject:[NSNumber numberWithFloat: TIME_FOR_EXPANDING]];
}

-(IBAction) onQueueClick:(id)sender{

    viewController=[[QueueListViewController alloc] initWithNibName:@"QueueListViewController" bundle:nil];
    [self performSelector:@selector(animateTransition:) withObject:[NSNumber numberWithFloat: TIME_FOR_EXPANDING]];
}

-(IBAction) onSettingsClick:(id)sender{
    viewController = [[HudsonInstancesTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self performSelector:@selector(animateTransition:) withObject:[NSNumber numberWithFloat: TIME_FOR_EXPANDING]];
}

-(IBAction) onLogoutClick:(id)sender{

    loadingView = [LoadingView loadingViewInView:[self view] andTitle:NSLocalizedString(@"Loggin out...",nil)];
    
    loginObject = [[HudsonLoginObject alloc] init];
    [loginObject setDelegate:self];
    [loginObject doLogout];
}

-(void)onAuthorizationGranted{

    if(loadingView!=nil){
        [loadingView removeView];
        loadingView = nil;
    }
    
    poppingToToRoot = YES;
    //viewController = [[[self navigationController] viewControllers] objectAtIndex:0];
    viewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    [self performSelector:@selector(animateTransition:) withObject:[NSNumber numberWithFloat: TIME_FOR_EXPANDING]];
}

- (void)viewDidUnload
{
    [[Configuration getInstance] setIsWallLoaded:NO];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
 
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma ANIMATION
-(void)animateTransition:(NSNumber *)duration{
    
    if(viewController==nil){
        return;
    }
    
	self.view.userInteractionEnabled=NO;
	[[self view] addSubview:viewController.view];
	if ((viewController.view.hidden==false) && ([duration floatValue]==TIME_FOR_EXPANDING)) {
		viewController.view.frame=[[UIScreen mainScreen] bounds];
		viewController.view.transform=CGAffineTransformMakeScale(SCALED_DOWN_AMOUNT, SCALED_DOWN_AMOUNT);
	}
	viewController.view.hidden=false;
	if ([duration floatValue]==TIME_FOR_SHRINKING) {
		[UIView beginAnimations:@"animationShrink" context:NULL];
		[UIView setAnimationDuration:[duration floatValue]];
		viewController.view.transform=CGAffineTransformMakeScale(SCALED_DOWN_AMOUNT, SCALED_DOWN_AMOUNT);
	}
	else {
		[UIView beginAnimations:@"animationExpand" context:NULL];
		[UIView setAnimationDuration:[duration floatValue]];
		viewController.view.transform=CGAffineTransformMakeScale(1, 1);
	}
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView commitAnimations];
}
-(void)animationDidStop:(NSString *)animationID finished:(BOOL)finished context:(void *)context{
	self.view.userInteractionEnabled=YES;
	
    if(poppingToToRoot){
       
        poppingToToRoot = NO;
        [self.navigationController popToRootViewControllerAnimated:NO];
    
    }else{
    
        if ([animationID isEqualToString:@"animationExpand"]) {
            [[self navigationController] pushViewController:viewController animated:NO];
        }
        else {
            viewController.view.hidden=true;
            [viewController release];
            viewController = nil;
        }
    }
}

@end
