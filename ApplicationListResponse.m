//
//  ApplicationListResponse.m
//  HudsonMobile
//
//  Created by simone on 5/28/11.
//  Copyright 2011 LMIT ltd. All rights reserved.
//

#import "ApplicationListResponse.h"


@implementation ApplicationListResponse

@synthesize  applicationList;

- (id)init {
    self = [super init];
    if (self) {
        applicationList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict{
	 
	if(currentReadCharacters!=nil){
		
		[currentReadCharacters release];
		currentReadCharacters = nil;
	}
    
    if ([elementName caseInsensitiveCompare:@"applicationinfo"]==NSOrderedSame) {
        
        currentInfo = [[ApplicationInfo alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	if([elementName caseInsensitiveCompare:@"id"]==NSOrderedSame){
		
        [currentInfo setAppId:currentReadCharacters];
        
	}else if([elementName caseInsensitiveCompare:@"title"]==NSOrderedSame){
		
        [currentInfo setTitle:currentReadCharacters];
	}else if([elementName caseInsensitiveCompare:@"status"]==NSOrderedSame){
		
        [currentInfo setStatus:currentReadCharacters];
	}else if([elementName caseInsensitiveCompare:@"url"]==NSOrderedSame){
		
        [currentInfo setUrl:currentReadCharacters];
	}else if([elementName caseInsensitiveCompare:@"created"]==NSOrderedSame){
		
        //TODO
	}else if([elementName caseInsensitiveCompare:@"applicationinfo"]==NSOrderedSame){
		
        [applicationList addObject:currentInfo];
	}
}

@end
