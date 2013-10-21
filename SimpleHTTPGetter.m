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

#import "SimpleHTTPGetter.h"
#import "IWSDataReceiver.h"
#import "Configuration.h"
#import "QueryStringNormalizer.h"
#include "HttpStatusCodes.h"

/*
 * HUDSONMOBI-12 [Ardissone] this code allows to trust any certificate
 */
@implementation NSURLRequest(NSHTTPURLRequest)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end

@implementation SimpleHTTPGetter

static int lastHttpStatusCode;
static NSString* lastHttpStatusMsg;
static NSMutableURLRequest* urlRequestInstance;

+(NSMutableURLRequest*) getURLRequestInstance{
    
    //if(urlRequestInstance==nil){
        
        urlRequestInstance = [[[NSMutableURLRequest alloc] init] autorelease];
        [urlRequestInstance setCachePolicy:NSURLRequestUseProtocolCachePolicy];
        [urlRequestInstance setTimeoutInterval:60.0];
        [urlRequestInstance setHTTPShouldHandleCookies:YES];
    //}
    
    return urlRequestInstance;
}

@synthesize receivedData, receiver, checkOnlyStatusCode,forceNotUseCredentials, ignore404Error,allHeaderFields;

+(int)getLastHttpStatusCode{
    
	return lastHttpStatusCode;
}

+(NSString*)getLastHttpStatusMsg{
    
	return lastHttpStatusMsg;
}

- (NSUInteger) httpGETNoAuth:(NSString*)url:(id <IWSDataReceiver>)caller{
    
    return [self httpGenericRequest:GET_REQUEST_NO_AUTH toURL:url withUsername:nil andPassword:nil andParams:nil andHeaders:nil andDataReceiver:caller];
}

- (NSUInteger) httpPOSTNoAuth:(NSString*)url:(id <IWSDataReceiver>) caller andParams:(NSString*)params{
    
    return [self httpGenericRequest:POST_REQUEST_NO_AUTH toURL:url withUsername:nil andPassword:nil andParams:params andHeaders:nil andDataReceiver:caller];
}

- (NSUInteger) httpPOST:(NSString*)url:(id <IWSDataReceiver>) caller andParams:(NSString*)params{
    return [self httpGenericRequest:POST_REQUEST toURL:url withUsername:nil andPassword:nil andParams:params andHeaders:nil andDataReceiver:caller];    
}

- (NSUInteger) httpPOST:(NSString*)url withUsername:(NSString*)user andPassword:(NSString*)password andDataReceiver:(id <IWSDataReceiver>) caller andParams:(NSString*)params{
    return [self httpGenericRequest:POST_REQUEST toURL:url withUsername:user andPassword:password andParams:params andHeaders:nil andDataReceiver:caller];    
}

- (NSUInteger) httpGET:(NSString*)url:(id <IWSDataReceiver>) caller{
	
    return [self httpGenericRequest:GET_REQUEST toURL:url withUsername:nil andPassword:nil andParams:nil andHeaders:nil andDataReceiver:caller];
}

- (NSUInteger) httpGET:(NSString*)url withUsername:(NSString*)user andPassword:(NSString*)password andDataReceiver:(id <IWSDataReceiver>) caller{
    
    return [self httpGenericRequest:GET_REQUEST toURL:url withUsername:user andPassword:password andParams:nil andHeaders:nil andDataReceiver:caller];
}

- (NSUInteger) httpGET:(NSString*)url withUsername:(NSString*)user andPassword:(NSString*)password andDataReceiver:(id <IWSDataReceiver>) caller andHeaders:(NSDictionary*)headers{
    
    return [self httpGenericRequest:GET_REQUEST toURL:url withUsername:user andPassword:password andParams:nil andHeaders:headers andDataReceiver:caller];
}

- (NSUInteger) httpGenericRequest:(int)reqType toURL:(NSString*)url withUsername:(NSString*)user andPassword:(NSString*)password andParams:(NSString*)params  andHeaders:(NSDictionary*)headers andDataReceiver:(id <IWSDataReceiver>) caller{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	//normalize the request with blank-removal
	normalizedUrl = [QueryStringNormalizer normalizeBlanks:url];
    
    [Logger info:[NSString stringWithFormat:@"Try to contact url %@",normalizedUrl]];
	
	authChallengeAlreadyReceived = NO;
	// create the request
    NSMutableURLRequest* request = [SimpleHTTPGetter getURLRequestInstance];
    [request setURL:[NSURL URLWithString:normalizedUrl]];
    
    
    if((user==nil || [user length]==0) || 
        (password==nil || [password length]==0)){
        
        if(reqType!=GET_REQUEST_NO_AUTH && reqType!=POST_REQUEST_NO_AUTH){
            NSString* __username = [[Configuration getInstance] username];
            NSString* __password = [[Configuration getInstance] password];
            if(__username != nil && [__username length] > 0) {
                
                [self fillNSRequest:request withUsername:__username andPassword:__password];
            }
        }
    }else{
        
        [self fillNSRequest:request withUsername:user andPassword:password]; 
    }
    
    if(headers!=nil){
    
        //set headers
        NSEnumerator* keyEnumerator = [headers keyEnumerator];
        id key = [keyEnumerator nextObject];
        while(key!=nil){
        
            id value = [headers objectForKey:key];
            [request addValue:value forHTTPHeaderField:key];
            key = [keyEnumerator nextObject];
        }
    }
    
    
    if(reqType==POST_REQUEST_NO_AUTH || reqType == POST_REQUEST){
        
        [request setHTTPMethod:@"POST"];
        if(params!=nil){
            [request addValue:[NSString stringWithFormat:@"%d",[params length]] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        }
    }else{
            [request setHTTPMethod:@"GET"];
    }
	
	receiveingData = NO;
	// create the connection with the request
	// and start loading the data
	currentConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[self fireTimer];
	
	if (currentConnection) {
		
		if(receivedData==nil){
			receivedData=[[NSMutableData alloc] init];
		}
		[self setReceiver:caller];
		return 0;
	}else{
		[Logger error:@"Connection failed"];
		[self stopTimer];
		return 1;
	}
}

-(void)fireTimer{
	int timeout = [[Configuration getInstance] connectionTimeout];
	timeoutTimer = [NSTimer timerWithTimeInterval:timeout target:self selector:@selector(timeoutOccurred:) userInfo:nil repeats:NO];
	[[NSRunLoop currentRunLoop] addTimer:timeoutTimer forMode:NSDefaultRunLoopMode];
}

-(void)stopTimer{
    
	if(timeoutTimer!=nil){
		[timeoutTimer invalidate];
		timeoutTimer = nil;
	}
}

-(void)timeoutOccurred:(NSTimer*)theTimer{
	
	if(currentConnection != nil && receiveingData==NO){
		
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
		[Logger error:[NSString stringWithFormat:@"Connection timeout occurred: %d seconds",
					   [[Configuration getInstance] connectionTimeout]]];
        
        NSData* responseData = [[NSString stringWithString:@"408"] dataUsingEncoding:NSUTF8StringEncoding];
		lastHttpStatusCode=408;
		lastHttpStatusMsg=NSLocalizedString(@"Connection timeout occurred",nil);
        
        [self cancelConnecton:currentConnection];
        
		if(receiver!=nil){
            if([(id)receiver respondsToSelector:@selector(receiveData:)]){
                
                [receiver receiveData:responseData];
            }else if([(id) receiver respondsToSelector:@selector(receiveData:andHeaders:)]){
                
                [receiver receiveData:responseData andHeaders:nil];
            }
		}
	}
    
	timeoutTimer = nil;
}

-(void)stop{
   
    if(currentConnection != nil){
		
        [self stopTimer];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
		[Logger info:@"Connection stopped"];
        
        [self cancelConnecton:currentConnection];
	}
    
	timeoutTimer = nil;
}

-(void)fillNSRequest:(NSMutableURLRequest*)request withUsername:(NSString*)username andPassword:(NSString*)password{
    
	if(forceNotUseCredentials==NO){
		NSMutableString *dataStr = (NSMutableString*)[@"" stringByAppendingFormat:@"%@:%@", username, password];
        
		NSData *encodeData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
		char encodeArray[512];
		
		memset(encodeArray, '\0', sizeof(encodeArray));
		
		// Base64 Encode username and password
		b64encode([encodeData length], (char *)[encodeData bytes], sizeof(encodeArray), encodeArray);
		
		dataStr = [NSString stringWithCString:encodeArray encoding:NSUTF8StringEncoding];
		NSString* authenticationString = [[NSString  alloc] initWithFormat:@"Basic %@", dataStr];
		[request addValue:authenticationString forHTTPHeaderField:@"Authorization"];		
		[Logger debug:[NSString stringWithFormat:@"Authentication string: %@",authenticationString]];
        [authenticationString release];        
	}
}

//HUDSONMOBI-27: this method handles the authentication challenge received from a server configured for web basic authentication
//Please note that this is *not Hudson authentication* this is the authentication challenge required from the web server
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
	
	[Logger debug:@"Received HTTP Basic Auth challenge. Sending credentials"];
	
	receiveingData = YES;
	[self stopTimer];
	
	if(authChallengeAlreadyReceived==NO){
		authChallengeAlreadyReceived = YES;
		NSString* connectionUsername=[[Configuration getInstance] username];
		NSString* connectionPassword=[[Configuration getInstance] password];	
		
		if(connectionUsername!=nil && connectionPassword!=nil){
			NSURLCredential* credentials = [[NSURLCredential alloc] initWithUser:connectionUsername 
																		password:connectionPassword 
                                                                     persistence:NSURLCredentialPersistenceForSession];
			[[challenge sender] useCredential:credentials forAuthenticationChallenge:challenge];
			[credentials release];
		}else {
			
            [self cancelConnecton:currentConnection];
            
			[Logger error:@"Connection cancelled as no creadentials available"];
			NSData* responseData = [[NSString stringWithString:@"403"] dataUsingEncoding:NSUTF8StringEncoding];
			lastHttpStatusCode=403;
			lastHttpStatusMsg=NSLocalizedString(@"Authentication denied:\nmissing credentials",nil);
			if(receiver!=nil){
                if([(id)receiver respondsToSelector:@selector(receiveData:)]){
                    
                    [receiver receiveData:responseData];
                }else if([(id) receiver respondsToSelector:@selector(receiveData:andHeaders:)]){
                    
                    [receiver receiveData:responseData andHeaders:allHeaderFields];
                }
			}
            
			return;
		}
	}else{
    
        [self cancelConnecton:currentConnection];
        
		[Logger error:@"Too many auth challenge received, giving up as i'm not authenticated"];
		NSData* responseData = [[NSString stringWithString:@"403"] dataUsingEncoding:NSUTF8StringEncoding];
		lastHttpStatusCode=403;
		lastHttpStatusMsg=NSLocalizedString(@"Authentication denied:\ninvalid credentials",nil);
		if(receiver!=nil){
            if([(id)receiver respondsToSelector:@selector(receiveData:)]){
                
                [receiver receiveData:responseData];
            }else if([(id) receiver respondsToSelector:@selector(receiveData:andHeaders:)]){
                
                [receiver receiveData:responseData andHeaders:allHeaderFields];
            }
		}
    
		return;
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	
	receiveingData = YES;
	[self stopTimer];
	
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
	
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
	
	NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    [self setAllHeaderFields:[httpResponse allHeaderFields]];
	NSEnumerator* keysEnum = [allHeaderFields keyEnumerator];
	NSString* value = [keysEnum nextObject];
	int statusCode = [httpResponse statusCode];
	lastHttpStatusCode = statusCode;
    
	[Logger debug:[NSString stringWithFormat:@"Key [HTTP_ERR_CODE]: [%d]",statusCode]];
	while(value!=nil){
        
		[Logger debug:[NSString stringWithFormat:@"Key [%@]: [%@]",value,[allHeaderFields valueForKey:value]]];
		value = [keysEnum nextObject];
	}
	
	int result = 200;
	//check for X-Hudson key or X-Jenkins key
	if([allHeaderFields valueForKey:@"X-Jenkins"]!=nil){
        
		[[Configuration getInstance] setHudsonVersion:[allHeaderFields valueForKey:@"X-Jenkins"]];
		result = 200;
	}else if([allHeaderFields valueForKey:@"X-Hudson"]!=nil){
        
		[[Configuration getInstance] setHudsonVersion:[allHeaderFields valueForKey:@"X-Hudson"]];
		result = 200;
	}else{
		result = statusCode;
	}
	
	NSString* errmsg=nil;
	if(statusCode!=200){
		
		char* descMsg = NULL;
		
		if(statusCode>=400 && statusCode < (400+sizeof(HTTP_STATUS_CODE_ENUM))){
			descMsg = NSLocalizedString([NSString stringWithCString:HTTP_STATUS_CODE_ENUM[statusCode-400] encoding:NSUTF8StringEncoding],nil);
			errmsg = [NSString stringWithFormat:NSLocalizedString(@"HTTP Error: %d\n%@",nil), statusCode, [NSString stringWithCString:descMsg encoding:NSUTF8StringEncoding]];
		}else{
			errmsg = [NSString stringWithFormat:NSLocalizedString(@"HTTP Error: %d",nil),statusCode];
		}
	}
	lastHttpStatusMsg = errmsg;
	
	if(checkOnlyStatusCode==YES){

		[self cancelConnecton:currentConnection];
        
		NSData* responseData = [[NSString stringWithFormat:@"%d",result] dataUsingEncoding:NSUTF8StringEncoding];
		if(receiver!=nil){
            if([(id)receiver respondsToSelector:@selector(receiveData:)]){
                
                [receiver receiveData:responseData];
            }else if([(id) receiver respondsToSelector:@selector(receiveData:andHeaders:)]){
                
                [receiver receiveData:receivedData andHeaders:allHeaderFields];
            }
		}

		return;
	}else{
        
		if(statusCode!=200){
		
            [self cancelConnecton:currentConnection];
            
            if(statusCode==404 && ignore404Error==NO){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection error",nil) 
                                                                message:errmsg
                                                               delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
                [alert show];
                [alert release];
            }
        
			NSData* responseData = [[NSString stringWithFormat:@"%d",statusCode] dataUsingEncoding:NSUTF8StringEncoding];
			if(receiver!=nil){
                if([(id)receiver respondsToSelector:@selector(receiveData:)]){
                    
                    [receiver receiveData:responseData];
                }else if([(id) receiver respondsToSelector:@selector(receiveData:andHeaders:)]){
                    
                    [receiver receiveData:responseData andHeaders:allHeaderFields];
                }
			}
			return;
		}
	}
	
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	
	[self stopTimer];
    
	NSString* errorMsg=nil;
	
    // inform the user
	if([[Configuration getInstance] connected]){		
        
		errorMsg = [error localizedDescription];
		[Logger error:[NSString stringWithFormat:@"Connection failed! Error - %@ %@",
					   [error localizedDescription],
					   [[error userInfo] objectForKey:NSErrorFailingURLStringKey]]];
	}else{
        
		//if not connected at all
		errorMsg = NSLocalizedString(@"Nework is unreachable",nil);
		[Logger error:[NSString stringWithFormat:@"Connection failed! Error - %@",errorMsg]];
	}
    
	if(checkOnlyStatusCode==NO){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection error",nil) 
														message:errorMsg
													   delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		[alert show];
		[alert release];
	}else {
        
		if([[Configuration getInstance] connected]){
			lastHttpStatusMsg = [error localizedDescription];
			lastHttpStatusCode = [error code];
		}else{
			lastHttpStatusMsg = errorMsg;
			lastHttpStatusCode = 500;
		}
	}
	
	if(receiver!=nil){
		NSData* responseData = [[NSString stringWithFormat:@"%d",lastHttpStatusCode] dataUsingEncoding:NSUTF8StringEncoding];
       if([(id)receiver respondsToSelector:@selector(receiveData:)]){
            
            [receiver receiveData:receivedData];
        }else if([(id) receiver respondsToSelector:@selector(receiveData:andHeaders:)]){
            
            [receiver receiveData:receivedData andHeaders:allHeaderFields];
        }
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
	[self stopTimer];
    
	if(receivedData!=nil){
		[Logger info:[NSString stringWithFormat:@"Succeeded! Received %d bytes of data",[receivedData length]]];
	}
    
	if(receiver!=nil){
        
        if([(id)receiver respondsToSelector:@selector(receiveData:)]){
        
            [receiver receiveData:receivedData];
        }else if([(id) receiver respondsToSelector:@selector(receiveData:andHeaders:)]){
        
            [receiver receiveData:receivedData andHeaders:allHeaderFields];
        }
	}
}

- (void) dealloc
{
	if(currentConnection!=nil){
		[currentConnection release];
	}
	
	if(receivedData!=nil){
		[receivedData release];
	}
	
	[super dealloc];
}

-(void)cancelConnecton:(NSURLConnection*)connection{

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [connection cancel];
}


@end
