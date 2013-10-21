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

#import "UserDetailViewController.h"


@implementation UserDetailViewController


- (id)initWithStyle:(UITableViewStyle)style andUser:(HudsonUser*)user {

    self = [super initWithStyle:style];
    
    if (self) {
    
		currentUser = user;
	}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	[self.navigationItem setTitle:NSLocalizedString(@"User detail",nil)];
	loadingView = [LoadingView loadingViewInView:[self view]];
	loaded=NO;
	[currentUser setDelegate:self];
	[currentUser loadHudsonObject];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	
	return YES;
}

-(void)onLoadFinisched{
	
	loaded=YES;
	[self.tableView reloadData];
	[loadingView removeFromSuperview];	
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
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
	if(section==0){
	
		return 3;
	}else{
	
		return 1;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	static NSString *CopyMailCellIdentifier = @"CopyMailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		[[cell textLabel] setFont:[UIFont systemFontOfSize:14.f]];
		[[cell detailTextLabel] setFont:[UIFont systemFontOfSize:14.f]];	
    }
	
	NSString* cellText=nil;
	NSString* detailText=nil;

	if(loaded && indexPath.section==0){
		
		switch (indexPath.row) {
			case 0:
				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
				cellText = NSLocalizedString(@"Username:",nil);
				detailText = [currentUser userId];
				break;
			case 1:
				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
				cellText = NSLocalizedString(@"Full Name:",nil);
				detailText = [currentUser name];
				break;
			case 2:
				cellText = NSLocalizedString(@"E-Mail:",nil);
				detailText = [currentUser mailAddress];
                if(detailText!=nil){
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                }else{
                    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
                }
				break;
			default:
				break;
		}
		
		[[cell textLabel] setText:cellText];
		[[cell detailTextLabel] setText:detailText];
	}else if(loaded && indexPath.section==1){
	
	    cell = [tableView dequeueReusableCellWithIdentifier:CopyMailCellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CopyMailCellIdentifier] autorelease];
		}
		
		[[cell textLabel] setTextAlignment:UITextAlignmentCenter];
		[[cell textLabel] setText:NSLocalizedString(@"Add to contacts",nil)];
	}
		
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(indexPath.section==1 && indexPath.row==0){
		
		//try to split first name and last name
		NSRange firstSpaceOccurrence = [[currentUser name] rangeOfString:@" "];

		if(firstSpaceOccurrence.location==NSNotFound){
			firstSpaceOccurrence = [[currentUser name] rangeOfString:@"."];
		}
		
		NSString* firstName = nil;
		NSString* lastName = nil;
		
		if(firstSpaceOccurrence.location!=NSNotFound){
			firstName =  [[currentUser name] substringToIndex:firstSpaceOccurrence.location];
			lastName = [[currentUser name] substringFromIndex:firstSpaceOccurrence.location+1];
		}else{
			
			firstName = [currentUser name];
			lastName = @"";
		}

		ABMutableMultiValueRef mailaddress = ABMultiValueCreateMutable(kABMultiStringPropertyType);
		if([currentUser mailAddress]!=nil){
			ABMultiValueAddValueAndLabel(mailaddress, [currentUser mailAddress], kABWorkLabel, NULL);
		}else{
			
			CFRelease(mailaddress);
			mailaddress = nil;
		}

		CFErrorRef error;
		ABAddressBookRef addressBookRef = ABAddressBookCreate();

        /////////
		//check if already existent: if so reuse it
        BOOL createNewAccount = YES;
        ABRecordRef newUserRef = NULL;
		CFArrayRef cfPersons = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
		NSArray* persons = [[NSArray alloc] initWithArray:(NSArray*)cfPersons];
		NSUInteger i, count = [persons count];
		for (i = 0; i < count; i++) {
			ABRecordRef person = (ABRecordRef)[persons objectAtIndex:i];
			
			NSString* __firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
			NSString* __lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
			if([__firstName isEqualToString:firstName] && [__lastName isEqualToString:lastName]){
			
                createNewAccount = NO;
                newUserRef = person;
			}
            
            if(newUserRef!=NULL){
                [__firstName release];
                [__lastName release];
                break;
            }
			
		}
		
        [persons release];
        CFRelease(cfPersons);
		
        if(newUserRef==NULL){
            newUserRef = ABPersonCreate();
            ABRecordSetValue(newUserRef,kABPersonFirstNameProperty, firstName, &error);//first name
            ABRecordSetValue(newUserRef,kABPersonLastNameProperty, lastName, &error);//last name
        }

		if(mailaddress!=nil){
			ABRecordSetValue(newUserRef, kABPersonEmailProperty, mailaddress, &error);//mail
			CFRelease(mailaddress);
		}
		
        if(createNewAccount){
        	ABAddressBookAddRecord(addressBookRef, newUserRef, &error);
        }

		if(ABAddressBookSave (addressBookRef, &error)){
		
			UIAlertView *alert = nil;
            
            if(createNewAccount){
                alert=[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"%@ has been added to the address book",nil),
                                                                         [currentUser name]] 
                                                                message:nil
                                                               delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            }else{
                alert=[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"%@ email address has been added to the address book",nil),
                                                          [currentUser name]] 
                                                 message:nil
                                                delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            }
			[alert show];
			[alert release];
		}else{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"An error occurred while adding %@ to the address book",nil),
																	 [currentUser name]] 
															message:nil
														   delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
			[alert show];
			[alert release];
		}
        
        if(createNewAccount){
            CFRelease(newUserRef);
        }
        CFRelease(addressBookRef);
        
	}else if(indexPath.section==0 && indexPath.row==2){
        
        if([currentUser mailAddress]!=nil){
        
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setSubject:NSLocalizedString(@"New message",nil)];
            [controller setToRecipients:[NSMutableArray arrayWithObjects:[currentUser mailAddress],nil]];
            [self presentModalViewController:controller animated:YES];
            [controller release];
        }
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	[self dismissModalViewControllerAnimated:YES];
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

