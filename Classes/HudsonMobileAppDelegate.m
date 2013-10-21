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

#import "HudsonMobileAppDelegate.h"

@implementation HudsonMobileAppDelegate

@synthesize window;
@synthesize navigationController;

@class Logger;

#pragma mark -
#pragma mark Application lifecycle

void internalExceptionHandler(NSException* exception){
	NSArray *stack = [exception callStackReturnAddresses];
	
	//dump stack into log
	[Logger error:@"*** Exception detected: ***"];
	[Logger error:[exception name]];
	[Logger error:[exception reason]];
	for (NSNumber* address in stack) {
		
		[Logger error:[NSString stringWithFormat:@"%d",[address integerValue]]];
	}

	exit(0);
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
	//show splash screen for at least 1 second
	//sleep(2);
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	
	//register HMAssertionHandler
	NSSetUncaughtExceptionHandler(&internalExceptionHandler);

	if([Logger checkForUncleanShutdown]){
	
		//alert the user
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
														message:NSLocalizedString(@"Crash report detected\nDo you want to report an incident ?",nil)
													   delegate:self cancelButtonTitle:NSLocalizedString(@"No",nil) otherButtonTitles:NSLocalizedString(@"Yes",nil),nil];
		[alert show];
		[alert release];
		
	}else{
	
		[Logger startLogger];
		[Logger info:@"Application started successfully"];
	}
	
	//register now for remote notifications
	//[application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];
	
	//[[[LMITServiceComm alloc] init] foo];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	
	switch(buttonIndex) {
		case 0:
		{
			[Logger startLogger];
			[Logger info:@"Application started successfully after an unclean shutdown"];
		}
			break;
		case 1:
		{
			//send to developer
			MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
			controller.mailComposeDelegate = self;
			[controller setSubject:[NSString stringWithFormat:@"%@ crash",[[Configuration getInstance] productName]]];
			[controller setToRecipients:[NSMutableArray arrayWithObjects:SUPPORT_MAIL_ADDRESS,nil]];
			[controller addAttachmentData:[Logger getLoggerData] mimeType:@"text/plain" fileName:@"hudsonmobi.log"];
            [controller setMessageBody:[NSString stringWithFormat:NSLocalizedString(@"Hi,\nmy %@ crashed when I was performing the following operations:\n[please specify]\nAttached the crash report.\n",nil),[[Configuration getInstance] productName]] isHTML:NO];
			[navigationController presentModalViewController:controller animated:YES];
			[controller release];
		}
		default:
			break;
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	if (result == MFMailComposeResultSent) {

		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Thank you",nil) 
														message:NSLocalizedString(@"Crash report has been posted",nil)
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	[navigationController dismissModalViewControllerAnimated:YES];

	[Logger startLogger];
	[Logger info:@"Application started successfully after an unclean shutdown"];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	//this code should only be called in the case of gracefull termination
	//comment the following line of code to simulate usage info sending
	[Logger stopLogger];
}

#pragma multitasking callback
- (void)applicationDidEnterBackground:(UIApplication *)application{

    [Logger stopLogger];
}

- (void)applicationWillEnterForeground:(UIApplication *)application{

    [Logger startLogger];
	[Logger info:@"Application is living again"];
}

- (void)applicationWillResignActive:(UIApplication *)application{

}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

