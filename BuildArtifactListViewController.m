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

#import "BuildArtifactListViewController.h"

@implementation BuildArtifactListViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andProject:(HudsonProject*)project
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        currentProject = project;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	// Unselect the selected row if any
	NSIndexPath*	selection = [self.tableView indexPathForSelectedRow];
	if (selection)
		[self.tableView deselectRowAtIndexPath:selection animated:YES];
    
	[self.tableView reloadData];
}

- (void)dealloc
{
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

    [self.navigationItem setTitle:NSLocalizedString(@"Artifact list",nil)];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [self.tableView setTableFooterView:view];
    [view release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[currentProject lastBuild] artifacts] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ArtifactCellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ArtifactCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ArtifactCellIdentifier] autorelease];
    }
    
    
    HudsonArtifact* artifact = [[[currentProject lastBuild] artifacts] objectAtIndex:indexPath.row];
    [[cell textLabel] setFont:[UIFont systemFontOfSize:14.f]];
    [[cell textLabel] setText:[artifact fileName]];
    [[cell imageView] setImage:[UIImage imageNamed:@"package.png"]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[[currentProject lastBuild] artifacts] count] > 0){
        
        selectedArtifact = [[[currentProject lastBuild] artifacts] objectAtIndex:indexPath.row];
        
        if([[selectedArtifact fileName] hasSuffix:@".txt"] ||
           [[selectedArtifact fileName] hasSuffix:@".xml"] ||
           [[selectedArtifact fileName] hasSuffix:@"log"]  ||
           [[selectedArtifact fileName] hasSuffix:@".trc"]){
			
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                            message:NSLocalizedString(@"Seems that this artifact can be viewed as text: do you want to download it and view?",nil)
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"No",nil) otherButtonTitles:NSLocalizedString(@"Yes",nil),nil];
            [alert show];
            [alert release];
        }else{
			
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                            message:NSLocalizedString(@"Seems that this artifact cannot be viewed as text: do you want to download it and view anyway?",nil)
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"No",nil) otherButtonTitles:NSLocalizedString(@"Yes",nil),nil];
            [alert show];
            [alert release];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	
	switch(buttonIndex) {
		case 1:
		{
			ArtifactViewerViewController *anotherViewController = [[ArtifactViewerViewController alloc] 
																   initWithNibName:@"ArtifactViewerViewController" bundle:nil
																   withBuild:[currentProject lastBuild] 
																   andArtifact:selectedArtifact];
			[self.navigationController pushViewController:anotherViewController animated:YES];
			[anotherViewController release];
		}
	}
}

@end
