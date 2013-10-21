//
//  BeesClient.m
//  HudsonMobile
//
//  Created by simone on 5/28/11.
//  Copyright 2011 LMIT ltd. All rights reserved.
//

#import "BeesClient.h"

#import "AccountKeysResponse.h"
#import "ApplicationListResponse.h"

@implementation BeesClient

@synthesize  delegate, onFinished;

- (id)init {
    self = [self initWithApiKey:nil andSecret:nil];
    if (self) {
                
    }
    return self;
}

-(id)initWithApiKey:(NSString*)_apikey andSecret:(NSString*)_secret{
    
    self = [self initWithApiUrl:@"https://api.cloudbees.com/api" andApiKey:_apikey 
                       andSecret:_secret andFormat:@"xml" andVersion:@"1.0"];
    if (self) {
        
    }
    return self;
}

-(void)sayHello:(NSString*)message{

    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:message forKey:@"message"];
    NSString* url = [super getRequestUrl:@"say.hello" andMethodParams:params];
    [params release];
    
    [self executeRequest: url withReceiver:self];
}

-(void) accountKeys:(NSString*) domain: (NSString*) user :(NSString*)password {

    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:user forKey:@"user"];
    [params setValue:password forKey:@"password"];
    if(domain!=nil){
        [params setValue:domain forKey:@"domain"];    
    }
    
    NSString* url = [super getRequestUrl:@"account.keys" andMethodParams:params];
    [params release];
    
    xmlDataParser = [[AccountKeysResponse alloc] init];
    [xmlDataParser setCaller:self];
    [xmlDataParser setOnLoadFinisched:@selector(onAccountKeyResponseLoadFinished)];
    
    [self executeRequest: url withReceiver:self];
}

-(void) applicationList{

    NSString* url = [super getRequestUrl:@"application.list" andMethodParams:nil];    
    
    xmlDataParser = [[ApplicationListResponse alloc] init];
    [xmlDataParser setCaller:self];
    [xmlDataParser setOnLoadFinisched:@selector(onApplicatonListResponseLoadFinished)];
    
    [self executeRequest: url withReceiver:self];
}

-(void)onAccountKeyResponseLoadFinished{
    
    if(delegate!=nil && onFinished!=nil){
    
        [delegate performSelector:onFinished withObject:xmlDataParser];
    }
}

-(void)onApplicatonListResponseLoadFinished{
    
    if(delegate!=nil && onFinished!=nil){
        
        [delegate performSelector:onFinished withObject:xmlDataParser];
    }
}

-(void)receiveData:(NSData *)data{	
	NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithData: data];
	[xmlParser setDelegate: xmlDataParser];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
	[xmlParser release];
}

/*
public SayHelloResponse sayHello(String message) throws Exception {

}

public ApplicationListResponse applicationList() throws Exception {

}

public ApplicationInfo applicationInfo(String appId) throws Exception {
    Map<String, String> params = new HashMap<String, String>();
    params.put("app_id", appId);
    String url = getRequestURL("application.info", params);
    trace("API call: " + url);
    
    ApplicationInfoResponse result = new ApplicationInfoResponse();
    executeRequest(url, result);
    return result.getApplicationInfo();
}

public AccountKeysResponse accountKeys(String domain, String user,
                                       String password) throws Exception {
    Map<String, String> params = new HashMap<String, String>();
    params.put("user", user);
    params.put("password", password);
    if (domain != null)
        params.put("domain", domain);
    String url = getRequestURL("account.keys", params);
    
    AccountKeysResponse result = new AccountKeysResponse();
    executeRequest(url, result);
    return result;
}

public AccountListResponse accountList() throws Exception {
    Map<String, String> params = new HashMap<String, String>();
    String url = getRequestURL("account.list", params);
    trace("API call: " + url);
    
    AccountListResponse result = new AccountListResponse();
    executeRequest(url,result);
    return result;
}
*/

@end
