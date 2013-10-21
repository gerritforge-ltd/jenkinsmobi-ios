//
//  ApplicationListResponse.h
//  HudsonMobile
//
//  Created by simone on 5/28/11.
//  Copyright 2011 LMIT ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmlDataParser.h"
#import "ApplicationInfo.h"

@interface ApplicationListResponse : XmlDataParser{
    
    XmlDataParser* xmlDataParser;
    NSMutableArray* applicationList;
    ApplicationInfo* currentInfo;
}

@property (assign) NSMutableArray* applicationList;

@end
