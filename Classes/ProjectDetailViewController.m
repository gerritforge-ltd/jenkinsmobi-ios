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

#import "ProjectDetailViewController.h"

@implementation ProjectDetailViewController

@synthesize isMavenModuleDetail;

- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle andProject:(HudsonProject*)project {
    
    self = [super initWithNibName:nibName bundle:bundle];
    
    if (self) {
		
		isMavenModuleDetail=NO;
		currentProject = project;
		loadedData = NO;
		lastBuildLoadRequested = NO;
        hudsonObjectToReload = currentProject;
        keepBackButton = YES;
        buildStopOrStart = 1;
	}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	loadingView = [LoadingView loadingViewInView:[self view]];
	
	if(isMavenModuleDetail){
		[self.navigationItem setTitle:NSLocalizedString(@"Maven2 mod", nil)];
	}else{
		[self.navigationItem setTitle:NSLocalizedString(@"Build detail", nil)];
	}
    
    UIBarButtonItem* buildButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Start this build", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(onBuildButtonClick:)];
    [self.navigationItem setRightBarButtonItem:buildButton];
    [buildButton release];
    
    [[self.navigationItem backBarButtonItem] setTitle:@"Back"];
}

-(void) viewDidAppear:(BOOL)animated {

    loadedData = NO;
	lastBuildLoadRequested = NO;
	[currentProject setQueueDescriptor:nil];
	[currentProject setDelegate:self];
	[currentProject loadHudsonObject];
    
    [super viewDidAppear:animated];
}

-(void)onBuildButtonClick:(id)sender{
    
    NSString* commandUrl = nil;
    if(buildStopOrStart==1){
        //start
        commandUrl = [NSString stringWithFormat:@"%@/build?delay=0sec",[currentProject url]];
    }else{
        //stop
        commandUrl = [NSString stringWithFormat:@"%@/stop",[[currentProject lastBuild] url]];
    }
    
    if(getter!=nil){
        [getter release];
        getter = nil;
    }
    getter = [[SimpleHTTPGetter alloc] init];
    [getter httpGET:commandUrl :self];
    
    if(buildStopOrStart==1){
        //start
        loadingView = [LoadingView loadingViewInView:[self view] andTitle:NSLocalizedString(@"Starting build ...",@"Starting build ...")];
    }else{
        //stop
        loadingView = [LoadingView loadingViewInView:[self view] andTitle:NSLocalizedString(@"Stopping build ...",@"Stopping build ...")];
    }
}

- (void) receiveData:(NSData*) data{
    
	if(loadingView!=nil){
		[loadingView removeFromSuperview];
	}
	
	loadingView = [LoadingView loadingViewInView:[self view] andTitle:NSLocalizedString(@"Refreshing...",@"Refreshing...")];
	
	loadedData = NO;
	lastBuildLoadRequested = NO;
    neverRunJob = NO;
	[currentProject setDelegate:self];
	[currentProject reload];
}

-(void)onLoadFinisched{
	
    if(loadingLastTrend){
        
        if(loadingView!=nil){
            [loadingView removeFromSuperview];
            loadingView = nil;
        }
        
        loadingLastTrend = NO;
        loadedData = YES;
		[self.tableView reloadData];
        
        [self doneLoadingTableViewData];
        
    }else if(lastBuildLoadRequested==YES){
		
        if([[currentProject colorName] hasSuffix:@"_anime"]){
            
            [[self.navigationItem rightBarButtonItem] setTitle:NSLocalizedString(@"Stop this build", nil)];
            buildStopOrStart = 0;
        }else{
            [[self.navigationItem rightBarButtonItem] setTitle:NSLocalizedString(@"Start this build", nil)];
            buildStopOrStart = 1;
        }
        
        lastBuildLoadRequested = NO;
        loadingLastTrend = YES;
        [currentProject loadLastTrend]; //do it in background (very few bytes should be downloaded)
                
	}else{	
		lastBuildLoadRequested = YES;
        if([currentProject lastBuild]==nil){
            
            if(loadingView!=nil){
                [loadingView removeFromSuperview];
                loadingView = nil;
            }
            
            neverRunJob = YES;
            loadedData = YES;
            lastBuildLoadRequested = NO;
            [self.tableView reloadData];
            [self doneLoadingTableViewData];
        }else{
            [[currentProject lastBuild] setDelegate:self];
            [[currentProject lastBuild] loadHudsonObject];
        }
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	
    if(isMavenModuleDetail && loadedData && section==0){
    
        return 80.f;
    }else{
    
        return 30.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	
    UIView* result = nil;
    
    UILabel* label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[UIFont boldSystemFontOfSize:16.f]];
	[label setTextColor:[UIColor darkGrayColor]];
	[label setTextAlignment:UITextAlignmentCenter];
	[label setLineBreakMode:UILineBreakModeWordWrap];
	[label setNumberOfLines:0];
    
	if(loadedData){
		if(section==0){
			
            if(isMavenModuleDetail){
                
                Maven2DetailHeaderView* maven2DetailHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"Maven2DetailHeaderView" owner:self options:nil] objectAtIndex:0];
                [maven2DetailHeaderView.descLabel setText:[currentProject displayName]];
                result = maven2DetailHeaderView;
            }else{
                [label setText:[currentProject name]];
                result = label;
            }
		}else if(section==1){
			
            if(neverRunJob==NO){
                [label setText:NSLocalizedString(@"Details",@"Details")];
                result = label;
            }
		}
	}
	
	return result;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(neverRunJob){
        
        return 1;
    }else{
        
        return 2;
    }
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	int result = 0;
	
    if(!loadedData){
        return 0;
    }
    
    if(neverRunJob){
        
        return 1;//one row only
    }
    
	if(section==0){
        
        if([currentProject queueDescriptor]!=nil){
            result = 5;
        }else{
            
            result = 4;
        }
        
	}else if(section==1){
        
        result = 4;
	}
	
	return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(neverRunJob){
        return 43.f;
    }else{
        return 50.f;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *DetailsCellIdentifier = @"DetailsCells";
	static NSString *MainCellIdentifier = @"MainCells";
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:
            if(neverRunJob==NO){
                cell = [tableView dequeueReusableCellWithIdentifier:MainCellIdentifier];
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:DetailsCellIdentifier];
            }
            break;
        case 1:
            if(neverRunJob==NO){
                cell = [tableView dequeueReusableCellWithIdentifier:DetailsCellIdentifier];
            }
            break;         
        default:
            break;
    }
	
	if(loadedData){
		
        if(neverRunJob){
            
            if(indexPath.section==0){
            
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailsCellIdentifier] autorelease];                        
                }
                
                [[cell textLabel] setText:NSLocalizedString(@"This job was never built",@"This job was never built")];
                [[cell textLabel] setTextAlignment:UITextAlignmentCenter];
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
        }else{
            
            switch (indexPath.section) {
                case 0:
                {
                    if (cell == nil) {
                        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MainCellIdentifier] autorelease];
                    }
                    
                    [[cell textLabel] setText:@""];
                    [[cell textLabel] setTextAlignment:UITextAlignmentLeft];
                    [[cell imageView] setImage:nil];
                    
                    switch (indexPath.row) {
                        case 0:
                        {
                            if([[currentProject colorName] hasSuffix:@"_anime"]){
                                
                                AnimatedGif2* animatedGif = [[AnimatedGif2 alloc] initWithImageBasename:[currentProject colorName]];
                                [animatedGif storeAnimation:[cell imageView]];
                                [animatedGif release];
                                
                            }else{
                                [[cell imageView] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[currentProject colorName]]]];
                            }
                            
                            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:17.f]];
                            [[cell textLabel] setText:[NSString stringWithFormat:@"Build #%d",[[currentProject lastBuild] number]]];
                            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                        }    
                            break;
                        case 1:
                        {
                            if([[currentProject lastBuild] isBuilding]){
                                
                                [[cell textLabel] setText:[NSString stringWithFormat:NSLocalizedString(@"Build in progress since %@ ",@"Build in progress since %@ "),[[currentProject lastBuild] builtSinceHumanReadable]]];
                            }else{
                                
                                [[cell textLabel] setText:[NSString stringWithFormat:NSLocalizedString(@"Last build was %@ ago and took %@",@"Last build was %@ ago and took %@"),[[currentProject lastBuild] builtSinceHumanReadable],
                                                           [[currentProject lastBuild] durationeHumanReadable]]];
                            }
                            
                            [[cell imageView] setImage:nil];
                            [cell setAccessoryType:UITableViewCellAccessoryNone];
                            [[cell textLabel] setNumberOfLines:2];
                            [[cell textLabel] setFont:[UIFont systemFontOfSize:12.f]];
                            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        }
                            break;
                        case 2:
                        {
                            NSString *colorImg = [[currentProject buildStabilityReport] colorName];
                            [[cell imageView] setImage:[UIImage imageNamed:[colorImg stringByReplacingOccurrencesOfString:@"gif" withString:@"png"]]];
                            [[cell textLabel] setText:[[currentProject buildStabilityReport] description]];
                            [[cell textLabel] setFont:[UIFont systemFontOfSize:14.f]];
                            [[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
                            [[cell textLabel] setNumberOfLines:0];
                            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                        }
                            break;
                        case 3:
                        {
                            if([currentProject testStabilityReport]!=nil){
                                
                                NSString *colorImg = [[currentProject testStabilityReport] colorName];
                                [[cell imageView] setImage:[UIImage imageNamed:[colorImg stringByReplacingOccurrencesOfString:@"gif" withString:@"png"]]];
                                [[cell textLabel] setText:[[currentProject testStabilityReport] description]];
                                
                                if([[[currentProject trend] trendItemList] count]>0){
                                    HudsonProjectTrendItem* trendItem = [[[currentProject trend] trendItemList] objectAtIndex:0];                                
                                    if([trendItem totalFailed]>0){
                                            
                                        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                                    }
                                }else{
                                
                                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                                }
                                
                                [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                            }else{
                                [[cell textLabel] setText:NSLocalizedString(@"No test found",@"No test found")];
                                [[cell textLabel] setTextAlignment:UITextAlignmentCenter];
                                [cell setAccessoryType:UITableViewCellAccessoryNone];
                                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                                
                            }
                            
                            [[cell textLabel] setFont:[UIFont systemFontOfSize:14.f]];
                            [[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
                            [[cell textLabel] setNumberOfLines:0];
                        }
                            break;
                        case 4:
                        {
                            [[cell textLabel] setText:[NSString stringWithFormat:NSLocalizedString(@"This job is in queue: %@",@"This job is in queue: %@"),[[currentProject queueDescriptor] reasonInQueue]]];
                            [[cell textLabel] setFont:[UIFont systemFontOfSize:14.f]];
                            [[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
                            [[cell textLabel] setNumberOfLines:0];
                            [cell setAccessoryType:UITableViewCellAccessoryNone];
                            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case 1:
                {
                    if (cell == nil) {
                        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailsCellIdentifier] autorelease];
                    }
                    
                    [[cell textLabel] setTextAlignment:UITextAlignmentLeft];
                    
                    switch (indexPath.row) {
                        case 0:
                        {
                            [[cell textLabel] setText:NSLocalizedString(@"Output console",@"Output console")];
                            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];  
                        }
                            break;
                        case 1:
                        {
                            [[cell textLabel] setText:NSLocalizedString(@"Recent changes",@"Recent changes")];
                            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue]; 
                        }                        
                            break;
                        case 2:
                        {
                            [[cell textLabel] setText:NSLocalizedString(@"Modules",@"Modules")];
                            if([[currentProject mavenModules] count]==0){
                                
                                [cell setAccessoryType:UITableViewCellAccessoryNone];
                                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];     
                            }else{
                                [[cell textLabel] setText:[NSString stringWithFormat:NSLocalizedString(@"Modules(%d)",@"Modules(%d)"),[[currentProject mavenModules] count]]];
                                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                                [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];  
                            }
                        }                        
                            break;
                        case 3:
                        {
                            [[cell textLabel] setText:NSLocalizedString(@"Artifacts",@"Artifacts")];
                            if([[[currentProject lastBuild] artifacts] count]==0){
                                [cell setAccessoryType:UITableViewCellAccessoryNone];
                                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];     
                            }else{
                                
                                [[cell textLabel] setText:[NSString stringWithFormat:NSLocalizedString(@"Artifacts(%d)",@"Artifacts(%d)"),[[[currentProject lastBuild] artifacts] count]]];
                                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                                [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];  
                            }
                        }                        
                            break;                      
                        default:
                            break;
                    }
                    
                }
                    break;
                 default:
                    break;
            }
        }
	}
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MainCellIdentifier] autorelease];
    }
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(neverRunJob){
        return;
    }
    
    if(!loadedData){
        return;
    }
    
    if(indexPath.section==0){
        
        switch (indexPath.row) {
            case 0:
            {
                GenericHTMLViewer *anotherViewController = [[GenericHTMLViewer alloc] initWithNibName:@"GenericHTMLViewer" bundle:nil andFileName:nil andTitle:[[currentProject lastBuild]fullDisplayName] andURL:[[currentProject lastBuild] url] andData:nil];
                [self.navigationController pushViewController:anotherViewController animated:YES];
                [anotherViewController release];
            }
                break;
            case 2:
            {
                ProjectTrendViewController *anotherViewController = [[ProjectTrendViewController alloc] initWithNibName:@"ProjectTrendViewController" bundle:nil andProject:currentProject];
                [self.navigationController pushViewController:anotherViewController animated:YES];
                [anotherViewController release];
            }
                break;
            case 3:
            {
                if([currentProject testStabilityReport]!=nil){
                    if(![[currentProject colorName] hasSuffix:@"_anime"]){
                        
                        if(!loadingLastTrend && [[[currentProject trend] trendItemList] count] > 0){
                        
                            HudsonProjectTrendItem* trendItem = [[[currentProject trend] trendItemList] objectAtIndex:0];
                            
                            if([trendItem totalFailed]>0){
                            
                                FailedTestListTableViewController *anotherViewController = [[FailedTestListTableViewController alloc] initWithStyle:UITableViewStylePlain andProjectTrendItem:trendItem];
                                [self.navigationController pushViewController:anotherViewController animated:YES];
                                [anotherViewController release];
                            }
                        }else{
                            
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                                            message:NSLocalizedString(@"Test results is still loading",@"Test results is still loading")
                                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alert show];
                            [alert release];
                        }
                    }else{
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                                        message:NSLocalizedString(@"The build is running, no tests result available yet",@"The build is running, no tests result available yet")
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                    }
                }
            }
                break;
            default:
                break;
        }
        
    }else if(indexPath.section==1){
        
        switch (indexPath.row) {
            case 0:
            {
                BuildConsoleOutputViewController *anotherViewController = [[BuildConsoleOutputViewController alloc] initWithNibName:@"BuildConsoleOutputViewController" bundle:nil andBuild:[currentProject lastBuild]];
                [self.navigationController pushViewController:anotherViewController animated:YES];
                [anotherViewController release];
            }
                break;
            case 1:
            {
                HudsonBuildChangesListViewController *anotherViewController = [[HudsonBuildChangesListViewController alloc] initWithStyle:UITableViewStylePlain andHudsonProject:currentProject];
                [self.navigationController pushViewController:anotherViewController animated:YES];
                [anotherViewController release];
            }
                break;
            case 2:
            {
                if([[currentProject mavenModules] count]>0){
                    Maven2ModulesListViewController *anotherViewController = [[Maven2ModulesListViewController alloc] initWithNibName:@"Maven2ModulesListViewController" bundle:nil andProject:currentProject];
                    [self.navigationController pushViewController:anotherViewController animated:YES];
                    [anotherViewController release];
                }
            }
                break;
            case 3:
            {
                if([[[currentProject lastBuild] artifacts] count]>0){
                    BuildArtifactListViewController *anotherViewController = [[BuildArtifactListViewController alloc] initWithNibName:@"BuildArtifactListViewController" bundle:nil andProject:currentProject];
                    [self.navigationController pushViewController:anotherViewController animated:YES];
                    [anotherViewController release];
                }
            }
                break;
            default:
                break;
        }
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
	if(getter!=nil){
		[getter release];
	}
	
	[[currentProject mavenModules] removeAllObjects];
	[[currentProject recentBuilds] removeAllObjects];
    
    [super dealloc];
}


@end

