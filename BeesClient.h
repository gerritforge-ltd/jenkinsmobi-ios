//
//  BeesClient.h
//  HudsonMobile
//
//  Created by simone on 5/28/11.
//  Copyright 2011 LMIT ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeesClientBase.h"
#import "IWSDataReceiver.h"
#import "CloudBeesWebUtility.h"
#import "XmlDataParser.h"

@interface BeesClient : BeesClientBase <IWSDataReceiver> {
    
    XmlDataParser* xmlDataParser;
    id delegate;
    SEL onFinished;
}

@property (assign) id delegate;
@property (assign) SEL onFinished;

-(id)initWithApiKey:(NSString*)_apikey andSecret:(NSString*)_secret;

-(void)sayHello:(NSString*)message;
-(void) accountKeys:(NSString*) domain: (NSString*) user :(NSString*)password;

@end
