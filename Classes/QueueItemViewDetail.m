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

#import "QueueItemViewDetail.h"

@implementation QueueItemViewDetail

- (id)initWithStyle:(UITableViewStyle)style andQueueItem:(HudsonQueueItem*)item{

    if (self = [super initWithStyle:style]) {
		
		queueItem = item;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];

	[self.navigationItem setTitle:NSLocalizedString(@"Queue item details",nil)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 
    return YES;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	if(section==0){
		return 4;
	}else{
	
		return 1;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	static NSString *ActionButtonCellIdentifier = @"ActionButtonCell";
    
    UITableViewCell *cell = nil;
	
	if(indexPath.section==0){
		
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			[[cell textLabel] setFont:[UIFont boldSystemFontOfSize:14.f]];
			[[cell detailTextLabel] setFont:[UIFont systemFontOfSize:14.f]];	
		}
		
		NSString* cellText=nil;
		NSString* detailText=nil;
		
		switch (indexPath.row) {
			case 0:
				cellText = NSLocalizedString(@"Blocked",nil);
				detailText = [queueItem blocked]==YES?NSLocalizedString(@"Yes",nil):NSLocalizedString(@"No",nil);
				break;
			case 1:
				cellText = NSLocalizedString(@"Stuck",nil);
				detailText = [queueItem stuck]==YES?NSLocalizedString(@"Yes",nil):NSLocalizedString(@"No",nil);
				break;
			case 2:
				cellText = NSLocalizedString(@"Reason",nil);
				detailText = [queueItem reasonInQueue];
				break;
			case 3:
				cellText = NSLocalizedString(@"Desc.",nil);
				detailText = [queueItem shortDescription];
				break;
			default:
				break;
		}
		
		[[cell textLabel] setText:cellText];
		[[cell detailTextLabel] setText:detailText];
		
	}else{
		
		//TODO: HUDSONMOBI-51
		cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:ActionButtonCellIdentifier];
		if (cell == nil) {
			
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ActionButtonCellIdentifier] autorelease];
			[cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
		}
		
		UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[[btn titleLabel ]setFont:[UIFont boldSystemFontOfSize:20.f]];
		[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[btn setFrame:CGRectMake(10.f, 0.f,302.f,43.f)];
		[btn setTitle:NSLocalizedString(@"Remove from the queue",nil) forState:UIControlStateNormal];
		[btn setBackgroundImage: [UIImage imageNamed: @"redbutton.png"] forState:UIControlStateNormal];
		[btn addTarget:self action:@selector(trashClick:) forControlEvents:UIControlEventTouchUpInside];
		[cell addSubview:btn];
	}
	
    return cell;
}

//TODO: HUDSONMOBI-51
-(void)trashClick:(id)sender{

	//http://hudson-mobi.com/hudson/queue/item/6/cancelQueue
	//NSString* commandUrl = [NSString stringWithFormat:@"%@/queue/item/",[queueItem i]];
	//SimpleHTTPGetter* getter = [[SimpleHTTPGetter alloc] init];
	//[getter httpGET:commandUrl :nil];
	//[self.navigationController popViewControllerAnimated:YES];
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
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

