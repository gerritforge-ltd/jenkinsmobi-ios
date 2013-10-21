//
//  AccountKeysResponse.m
//  HudsonMobile
//
//  Created by simone on 5/28/11.
//  Copyright 2011 LMIT ltd. All rights reserved.
//

#import "AccountKeysResponse.h"


@implementation AccountKeysResponse

@synthesize  key, secret;

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict{
	
	if(currentReadCharacters!=nil){
		
		[currentReadCharacters release];
		currentReadCharacters = nil;
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	if([elementName caseInsensitiveCompare:@"key"]==NSOrderedSame){
		
        [self setKey:currentReadCharacters];
        
	}else if([elementName caseInsensitiveCompare:@"secret"]==NSOrderedSame){
		
        [self setSecret:currentReadCharacters];
	}
}

@end
