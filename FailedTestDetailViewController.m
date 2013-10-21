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

#import "FailedTestDetailViewController.h"



@implementation FailedTestDetailViewController

- (id)initWithStyle:(UITableViewStyle)style andTest:(HudsonTest*)test
{
    self = [super initWithStyle:style];
    if (self) {

        currentTest = test;
    }
    return self;
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
    
    [self.navigationItem setTitle:NSLocalizedString(@"Test detail",nil)];
    
    loadingView = [LoadingView loadingViewInView:self.tableView];
    
    [currentTest setDelegate:self];
    [currentTest loadHudsonObject];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.tableView.tableFooterView = view;
}

-(void)onLoadFinisched{
	
    loadedData = YES;
    
	[self.tableView reloadData];
    
    if(loadingView!=nil){
    
        [loadingView removeView];
        loadingView = nil;
    }
}

-(void)onLoadFinischedWithErrors{
	
	//[navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(loadedData){
    
        return 4;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int result = 0;

    if(loadedData){
        switch (section) {
            case 0:
            case 1:
            case 2:
                result = 1;
                break;
            case 3:
                result = 4;
                break;            
            default:
                break;
        }
    }
    
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	
    if(!loadedData){
        
        return nil;
    }
    
    UILabel* label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	[label setBackgroundColor:[UIColor lightGrayColor]];
	[label setFont:[UIFont boldSystemFontOfSize:15.f]];
	[label setTextColor:[UIColor whiteColor]];
	
    switch (section) {
        case 0:
            [label setText:NSLocalizedString(@"Name",nil)];
            break;
        case 1:
            [label setText:NSLocalizedString(@"Class-name",nil)];
            break;
        case 2:
            [label setText:NSLocalizedString(@"Error message",nil)];
            break;
        case 3:
            [label setText:NSLocalizedString(@"Details",nil)];
            break;            
        default:
            break;
    }
    
	return label;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        [[cell textLabel] setFont:[UIFont systemFontOfSize:14.f]];
        [[cell textLabel] setNumberOfLines:3];
        [[cell textLabel] setLineBreakMode:UILineBreakModeMiddleTruncation];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];        
    }
    
    if(loadedData){
    
        switch (indexPath.section) {
            case 0:
                [[cell textLabel] setText:[currentTest name]];
                break;
            case 1:
                [[cell textLabel] setText:[currentTest className]];
                break;
            case 2:
                if([currentTest errorDetails]==nil){
                
                    [[cell textLabel] setText:NSLocalizedString(@"No error message specified",nil)];
                }else{
                    [[cell textLabel] setText:[currentTest errorDetails]];
                }
                break;
            case 3:
                [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:17.f]];
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                switch (indexPath.row) {
                    case 0:
                        if([currentTest errorDetails]!=nil){
                            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                        }
                        [[cell textLabel] setText:NSLocalizedString(@"Complete error message",nil)];
                        break;
                    case 1:
                        if([currentTest errorStackTrace]!=nil){
                            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                        }
                        [[cell textLabel] setText:NSLocalizedString(@"Stacktrace",nil)];
                        break;
                    case 2:
                        if([currentTest errorStdOut]!=nil){
                            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                        }
                        [[cell textLabel] setText:NSLocalizedString(@"Standard output",nil)];
                        break;
                    case 3:
                        if([currentTest errorStdErr]!=nil){
                            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                        }
                        [[cell textLabel] setText:NSLocalizedString(@"Standard error",nil)];
                        break;                        
                    default:
                        break;
                }
                break;
            default:
                break;
        }
    }
    
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

    GenericHTMLViewer *anotherViewController=nil;
    
    if(indexPath.section==3){
    
        switch (indexPath.row) {
            case 0:
                if([currentTest errorDetails]!=nil){
                    anotherViewController = [[GenericHTMLViewer alloc] initWithNibName:@"GenericHTMLViewer" bundle:nil andFileName:nil andTitle:NSLocalizedString(@"Error message",nil) andURL:nil andData:[currentTest errorDetails]];
                }
                break;
            case 1:
                if([currentTest errorStackTrace]!=nil){
                anotherViewController = [[GenericHTMLViewer alloc] initWithNibName:@"GenericHTMLViewer" bundle:nil andFileName:nil andTitle:NSLocalizedString(@"Stacktrace",nil) andURL:nil andData:[currentTest errorStackTrace]];
                }
                break;
            case 2:
                if([currentTest errorStdOut]!=nil){
                    anotherViewController = [[GenericHTMLViewer alloc] initWithNibName:@"GenericHTMLViewer" bundle:nil andFileName:nil andTitle:NSLocalizedString(@"Standard output",nil) andURL:nil andData:[currentTest errorStdOut]];
                }
                break;
            case 3:
                if([currentTest errorStdErr]!=nil){
                    anotherViewController = [[GenericHTMLViewer alloc] initWithNibName:@"GenericHTMLViewer" bundle:nil andFileName:nil andTitle:NSLocalizedString(@"Standard error",nil) andURL:nil andData:[currentTest errorStdErr]];
                }
                break;            
            default:
                break;
        }
        
        if(anotherViewController!=nil){
            [anotherViewController setShowReloadButton:NO];
            [self.navigationController pushViewController:anotherViewController animated:YES];
            [anotherViewController release];
        }
    }
}

@end
