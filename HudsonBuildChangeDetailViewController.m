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

#import "HudsonBuildChangeDetailViewController.h"


@implementation HudsonBuildChangeDetailViewController

- (id)initWithStyle:(UITableViewStyle)style andHudsonChange:(HudsonChange*)change{
	
    if (self = [super initWithStyle:style]) {
		
		currentChange = change;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.navigationItem setTitle:NSLocalizedString(@"Build change detail",nil)];
	
	loadingView = [LoadingView loadingViewInView:[self view]];
	
	loadedData = NO;
	
	[self onLoadFinisched];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	
	return YES;
}

-(void)onLoadFinischedWithErrors{
	
	if(loadingView!=nil){
		[loadingView removeFromSuperview];
		loadingView = nil;
	}
}

-(void)onLoadFinisched{
	
	loadedData=YES;
	
	[self.tableView reloadData];
	
	if(loadingView!=nil){
		[loadingView removeFromSuperview];
		loadingView = nil;
	}
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


#pragma mark Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	
	return 20.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	CGFloat result = 0.f;

    switch (indexPath.section) {
        case 0:
            if(indexPath.row==0){
                result =  60.f;
            }else if(indexPath.row==1){
                result =  70.f;
            }else if(indexPath.row==2){
                result =  70.f;
            }
            break;
        case 1:
        case 2:
        case 3:
            result = 60;
            break;			
        default:
            break;
    }
    return result;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 
	UILabel* label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	[label setBackgroundColor:[UIColor lightGrayColor]];
	[label setFont:[UIFont boldSystemFontOfSize:15.f]];
	[label setTextColor:[UIColor whiteColor]];
		
	switch (section) {
		case 0:
			[label setText:NSLocalizedString(@"Details",nil)];
			break;
        case 1:
			[label setText:NSLocalizedString(@"Modified file list",nil)];
			break;
		case 2:
			[label setText:NSLocalizedString(@"Added file list",nil)];
			break;
		case 3:
			[label setText:NSLocalizedString(@"Removed file list",nil)];
			break;
		default:
			break;
	}
	
	return label;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	NSInteger result = 0;
	
	switch (section) {
		case 0:
			result = 3;
			break;
        case 1:
			result = [[currentChange modifiedFiles] count];
			break;
		case 2:
			result = [[currentChange addedFiles] count];
			break;
		case 3:
			result = [[currentChange removedFiles] count];
			break;
		default:
			break;
	}
	
	if(result==0){
		result = 1;
	}
	
	return result;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
	if(loadedData){
		
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:17.f]];
		}
		
		if([indexPath section]==0){
			
			[[cell imageView] setImage:nil];
			
			if([indexPath row]==0){
				
				[[cell textLabel] setText:[NSString stringWithFormat:NSLocalizedString(@"Changeset by %@",nil), [currentChange user]]];
				[[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
				[[cell textLabel] setNumberOfLines:2];
				
			}else if([indexPath row]==1){
				
				[[cell textLabel] setText:[currentChange message]];
				[[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
				[[cell textLabel] setNumberOfLines:3];
			}else if([indexPath row]==2){
            
                [[cell textLabel] setText:[NSString stringWithFormat:NSLocalizedString(@"Commit: #%@",nil),[currentChange revision]]];
                [[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
                [[cell textLabel] setNumberOfLines:4];
            }
			
		}else if([indexPath section]==1){
			
			[[cell imageView] setImage:[UIImage imageNamed:@"document_edit"]];
			
			if([[currentChange modifiedFiles] count]>0){
				[[cell textLabel] setText:[[currentChange modifiedFiles] objectAtIndex:[indexPath row]]];
				[[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
				[[cell textLabel] setNumberOfLines:3];
			}else{
				[[cell textLabel] setText:NSLocalizedString(@"No edited files",nil)];
			}
			
		}else if([indexPath section]==2){
			
			[[cell imageView] setImage:[UIImage imageNamed:@"document_add"]];
			
			if([[currentChange addedFiles] count]>0){
				[[cell textLabel] setText:[[currentChange addedFiles] objectAtIndex:[indexPath row]]];
				[[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
				[[cell textLabel] setNumberOfLines:3];
			}else{
				[[cell textLabel] setText:NSLocalizedString(@"No added files",nil)];
			}
			
		}else if([indexPath section]==3){
			
			[[cell imageView] setImage:[UIImage imageNamed:@"document_delete"]];
			
			if([[currentChange removedFiles] count]>0){
				[[cell textLabel] setText:[[currentChange removedFiles] objectAtIndex:[indexPath row]]];
				[[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
				[[cell textLabel] setNumberOfLines:3];
			}else{
				[[cell textLabel] setText:NSLocalizedString(@"No removed files",nil)];
			}
		}
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	/*
	 HudsonProjectTrendItem* trendItem = [[[currentProject trend] trendItemList] objectAtIndex:[indexPath row]];
	 FailedTestListTableViewController *anotherViewController = [[FailedTestListTableViewController alloc] initWithStyle:UITableViewStylePlain andProjectTrendItem:trendItem];
	 [self.navigationController pushViewController:anotherViewController animated:YES];
	 [anotherViewController release];
	 
	 */
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

    [super dealloc];
}


@end

