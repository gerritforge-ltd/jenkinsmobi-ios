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

#import "HudsonBuildChangesListViewController.h"

@implementation HudsonBuildChangesListViewController

- (id)initWithStyle:(UITableViewStyle)style andHudsonProject:(HudsonProject*)project{
	
    if (self = [super initWithStyle:style]) {
		
		currentProject = project;
    }
    return self;
}

#pragma Deselect the eventually selected table row
- (void)viewWillAppear:(BOOL)animated
{
	// Unselect the selected row if any
	NSIndexPath*	selection = [self.tableView indexPathForSelectedRow];
	if (selection){
		[self.tableView deselectRowAtIndexPath:selection animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [self.tableView setTableFooterView:view];
    [view release];
    
	[self.navigationItem setTitle:NSLocalizedString(@"Recent changes",nil)];
	
	loadingView = [LoadingView loadingViewInView:[self view]];
	
	loadedData = NO;

    historyCounter = [[currentProject recentBuilds] count];
    int limit = [[Configuration getInstance] maxBuildsNumberToLoadAtTime];
    if(historyCounter>limit){
        historyCounter = limit;
    }
    
    changeSetList = [[NSMutableArray alloc] initWithCapacity:historyCounter];
    
    for (int i=0; i < historyCounter; i++) {
        
        HudsonBuild* b = [[currentProject recentBuilds] objectAtIndex:i];
        HudsonChangeSet* changeSet = [[HudsonChangeSet alloc] initWithBuild:b];
        [changeSet setDelegate:self];
        [changeSet loadHudsonObject];
        [changeSetList addObject:changeSet];
        [changeSet release];
    }
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
	
    historyCounter--;
    
    if(historyCounter==0){
    
        //now check for empty changeset
        NSMutableArray* changeSetToRemove = [[NSMutableArray alloc] init];
        for (HudsonChangeSet* changeset in changeSetList) {
            
            if([[changeset changeList] count]==0){
            
                [changeSetToRemove addObject:changeset];
            }
        }
        for (HudsonChangeSet* changeset in changeSetToRemove) {
            
            [changeSetList removeObject:changeset];
        }
        [changeSetToRemove release];
        
        
        loadedData=YES;
        [self.tableView reloadData];
        
        if(loadingView!=nil){
            [loadingView removeFromSuperview];
            loadingView = nil;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
    if(loadedData){
    
        return 60.f;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(loadedData){
        return [changeSetList count];
    }else{
    
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	
	return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	
    if(loadedData){
        UILabel* label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        [label setBackgroundColor:[UIColor lightGrayColor]];
        [label setFont:[UIFont boldSystemFontOfSize:15.f]];
        [label setTextColor:[UIColor whiteColor]];
        
        HudsonBuild* build = (HudsonBuild*)[[currentProject recentBuilds] objectAtIndex:section];
        [label setText:[NSString stringWithFormat:@"Build #%d",[build number]]];
        
        return label;
    }else{
    
        return nil;
    }
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	int result = 0;
    
    if(loadedData){
        result = [[(HudsonChangeSet*)[changeSetList objectAtIndex:section] changeList] count];
    }
	
	if(result>0){
		
		return result;
	}else{
		
		return 1;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *ChangeCellIdentifier = @"ChangeCell";	
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
	if(loadedData){
		
        HudsonChangeSet* changeSet = (HudsonChangeSet*)[changeSetList objectAtIndex:indexPath.section];
        
		if([[changeSet changeList] count]==0){
			
			[[cell textLabel] setTextAlignment:UITextAlignmentCenter];
			[[cell textLabel] setText:NSLocalizedString(@"No changes for this build",nil)];
		}else{
			
			cell = [tableView dequeueReusableCellWithIdentifier:ChangeCellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChangeCellIdentifier] autorelease];
				[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                [[cell textLabel] setFont:[UIFont systemFontOfSize:17.f]];
			}
			
			HudsonChange* change = [[changeSet changeList] objectAtIndex:[indexPath row]];
			[[cell textLabel] setText:[change message]];
		}
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    HudsonChangeSet* changeSet = (HudsonChangeSet*)[changeSetList objectAtIndex:indexPath.section];
    
	if([[changeSet changeList] count]>0){

		HudsonChange* change = [[changeSet changeList] objectAtIndex:[indexPath row]];
		HudsonBuildChangeDetailViewController *anotherViewController = [[HudsonBuildChangeDetailViewController alloc] initWithStyle:UITableViewStylePlain andHudsonChange:change];
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
	[changeSetList release];
    [super dealloc];
}



@end

