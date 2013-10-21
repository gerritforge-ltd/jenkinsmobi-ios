//
//  AccountKeysResponse.h
//  HudsonMobile
//
//  Created by simone on 5/28/11.
//  Copyright 2011 LMIT ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmlDataParser.h"

@interface AccountKeysResponse : XmlDataParser {
    
    NSString* key;
    NSString* secret;
}

@property (copy) NSString* key;
@property (copy) NSString* secret;

@end
