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

#import "Logger.h"

/*
 empty the log at any graceful close of the application
 
 if the log exists at the startup: ask the user for sending it to LMIT as email attachment to support@hudson-mobi.com
 
 each line is of type:
 
 [timestamp] LEVEL method - msg
 */

@implementation Logger

#define DEBUG

static 	NSFileHandle* fout = nil;

//this function returns: 
//TRUE if the log file exists, that means the app has been terminated unexpectedly
//FALSE otherwise
+(BOOL)checkForUncleanShutdown{

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* path = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0], LOG_FILE_NAME];
	return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+(void)startLogger{

	if(fout==nil){
	
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString* path = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0], LOG_FILE_NAME];
		fout = [NSFileHandle fileHandleForWritingAtPath:path];
		
		if(fout==nil){
		
			//create it
			[[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
			fout = [NSFileHandle fileHandleForWritingAtPath:path];
		}else{
		
			//erase it
			[fout truncateFileAtOffset:0];
		}
		
		//write header with version informations
		[self info:[NSString stringWithFormat:@"Product name: %@",[[Configuration getInstance] productName]]];
		[self info:[NSString stringWithFormat:@"Product version: %@",[[Configuration getInstance] productVersion]]];
		
		UIDevice* device  = [UIDevice currentDevice];
		[self info:[NSString stringWithFormat:@"System name: %@",[device systemName]]];
		[self info:[NSString stringWithFormat:@"System version: %@",[device systemVersion]]];
		[self info:[NSString stringWithFormat:@"Device model: %@",[device model]]];
		[self info:[NSString stringWithFormat:@"Device localized model: %@",[device localizedModel]]];
		if([[Configuration getInstance] iOSVersion]>3){
			[self info:[NSString stringWithFormat:@"Multitasking supported: %@",
						[device isMultitaskingSupported] ? @"YES" : @"NO"]];
		}else{
			[self info:[NSString stringWithFormat:@"Multitasking supported: NO"]];
		}		
		
		[fout retain];
	}
}

//this function will remove the log file too, call this *only* at the very end of application
+(void)stopLogger{

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* path = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0], LOG_FILE_NAME];
	NSError* error=nil;
	[[NSFileManager defaultManager] removeItemAtPath:path error:&error];
	
	[fout release];
	fout = nil;
}

+(void)stopLoggerWithoutCleanup{
	
	if(fout!=nil){
		[fout closeFile];
	}
}

+(NSData*)getLoggerData{

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* path = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0], LOG_FILE_NAME];
	return [NSData dataWithContentsOfFile:path];
}

+(void)writeToFile:(NSString*) msg{
	
	[fout seekToEndOfFile];
	[fout writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
	
	//
	NSLog(@"%@",msg);
}

+(NSString*)formatMsg:(NSString*)msg :(NSString*)traceLevel{

	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"ddMMyyyy:hhmmss"];
	NSString* dateString = [formatter stringFromDate:[NSDate date]];
	
	[formatter release];
	
	return [NSString stringWithFormat:@"[%@] %@ - %@\n", dateString, traceLevel, msg];
}

+(void)debug:(NSString*)msg{

#ifdef DEBUG
	NSString* formattedMsg = [self formatMsg:msg :@"DEBUG"];
	[self writeToFile:formattedMsg];
#endif
}


+(void)warn:(NSString*)msg{
	NSString* formattedMsg = [self formatMsg:msg :@"WARN"];
	[self writeToFile:formattedMsg];
}

+(void)info:(NSString*)msg{
	NSString* formattedMsg = [self formatMsg:msg :@"INFO"];
	[self writeToFile:formattedMsg];
}

+(void)error:(NSString*)msg{
	NSString* formattedMsg = [self formatMsg:msg :@"ERROR"];
	[self writeToFile:formattedMsg];
}

@end
