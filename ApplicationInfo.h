//
//  ApplicationInfo.h
//  HudsonMobile
//
//  Created by simone on 5/28/11.
//  Copyright 2011 LMIT ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ApplicationInfo : NSObject {
    
    NSString* appId;
    NSString* title;
    NSString* created;
    NSString* status;
    NSString* url;
}

@property (copy) NSString* appId;
@property (copy) NSString* title;
@property (copy) NSString* created;
@property (copy) NSString* status;
@property (copy) NSString* url;

@end
