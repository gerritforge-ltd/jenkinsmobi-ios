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

#import "AbstractHudsonObject.h"

@implementation AbstractHudsonObject

@synthesize delegate, url, colorName, description, xPathQueryString, name,displayName, silentMode;

- (id) init
{
    self = [super init];
    
	if (self) {
		httpGetter = [[SimpleHTTPGetter alloc] init];
	}
	return self;
}

-(void)stopLoad{

    if(httpGetter!=nil){
    
        [httpGetter stop];
    }
}

-(void)loadHudsonObject{
	
	if(httpGetter==nil){
		httpGetter = [[SimpleHTTPGetter alloc] init];
	}
	
	if(xPathQueryString!=nil){
		
		[httpGetter httpGET:[NSString stringWithFormat:@"%@/api/xml?%@", url, xPathQueryString]: self];
	}else{
	
		[httpGetter httpGET:[NSString stringWithFormat:@"%@/api/xml", url]: self];
	}
	
}

-(void)setUrl:(NSString*)_url{
	
	url = [_url retain];
	
	Configuration* configurationInstance = [Configuration getInstance];
	
    if([configurationInstance overrideHudsonURLWithConfiguredOne]){
        
        //do nothing
        return;
    }
    
	//try to understand used protocol: needed for further substring calls
	int protocolType = -1;
	bool applyHostnameFix = FALSE;
	if([url hasPrefix:@"http://"]){
		protocolType = 0;
	}else if([url hasPrefix:@"https://"]){
		protocolType = 1;
	}
	//apply if a protocol has been detected into the url string
	applyHostnameFix = protocolType > -1; 
	
	if(applyHostnameFix){
		
		//check now if the url does not contain the configured hudson hostname
		NSString* hudsonCompleteURL = [configurationInstance url];
		if([url hasPrefix:hudsonCompleteURL]==NO){

			[Logger debug:@"Need to apply hostname fix"];
			
			//replace it with the configured one
			//look for (in the order): suffix, port, hostname
			NSRange range;
			if([configurationInstance suffix] != nil && [[configurationInstance suffix] length] > 0){
				
				[Logger debug:@"Getting suffix range"];
				//get suffix range
				range = [url rangeOfString:[NSString stringWithFormat:@"/%@/",[configurationInstance suffix]]];
			}else if(![[configurationInstance portNumber] isEqualToString:@"-1"]){
				
				[Logger debug:@"Getting port number range"];
				//get port number range
				range = [url rangeOfString:[NSString stringWithFormat:@":%@/",[configurationInstance portNumber]]];				
			}else{
				
				[Logger debug:@"Getting base hostname range"];
				//get hostname range
				range = [url rangeOfString:[NSString stringWithFormat:@"%@/",[configurationInstance url]]];				
			}
			
			if(range.location != NSNotFound) {
				
				[Logger debug:@"Replacing"];
				//replace it!
				NSString* subString = [url substringFromIndex:range.location + range.length];
				url = [[NSString stringWithFormat:@"%@/%@",[configurationInstance url],subString] retain];
				[Logger debug:[NSString stringWithFormat:@"Replaced. New url is '%@' Old one was '%@'",url,_url]];
				[_url release];
			}
		}
	}
}

- (void) receiveData:(NSData*)data{
	
	downloadedData = data;
	
	if(downloadedData==nil){

		[Logger debug:@"No data received"];
		[self onLoadFinisched];
		return;
	}
	
	NSString* response = [[NSString alloc] initWithBytes: [downloadedData bytes] length:[downloadedData length] encoding:NSUTF8StringEncoding];
	
	if(response==nil){
		
		[Logger error:@"Response null"];
		[self onLoadFinisched];
		
		if(silentMode==NO){
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil) 
								message:NSLocalizedString(@"Hudson query failed: you may be not authorized to access the resource.\nSometimes this error is due to some Hudson bugs",nil)
								delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
			[alert show];
			[alert release];
		}
		return;
	}else {
		//[Logger debug:[NSString stringWithFormat:@"Response from Hudson:\n%@",response]];
	}

	
	if([response isEqualToString:@"403"]){

		[response release];
		[Logger error:@"Load finished with errors: 403"];
		[self onLoadFinischedWithErrors];
		
		if(silentMode==NO){
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil) 
															message:[SimpleHTTPGetter getLastHttpStatusMsg]
														   delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
			[alert show];
			[alert release];
		}
		return;		
	}
	
	[response release];
	[xmlDataParser setOnLoadFinisched:@selector(onLoadFinisched)];
	
	NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithData: downloadedData];
	[xmlParser setDelegate: xmlDataParser];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
	[xmlParser release];
}

-(void)onLoadFinischedWithErrors{
	
	[delegate onLoadFinischedWithErrors];
	[httpGetter release];
	httpGetter = nil;
}

-(void)onLoadFinisched{

	[delegate onLoadFinisched];
	[httpGetter release];
	httpGetter = nil;
}

- (void) dealloc
{
	if(xmlDataParser!=nil){
		[xmlDataParser release];
	}
	
	if(name!=nil){
		[name release];
	}
	
	if(displayName!=nil){
		[displayName release];
	}
	
	if(url!=nil){
		[url release];
	}
	
	if(colorName!=nil){
		[colorName release];
	}
	
	if(description!=nil){
		[description release];
	}
	
	if(httpGetter!=nil){
		[httpGetter release];
	}
	
	[super dealloc];
}


@end
