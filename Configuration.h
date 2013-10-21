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

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "Logger.h"

#define WWW_HUDSON_MOBI_COM @"www.hudson-mobi.com"
#define WWW_GOOGLE_COM @"www.google.com"
#define LOG_FILE_NAME @"hudsonmobi.log"
#define SUPPORT_MAIL_ADDRESS @"support@hudson-mobi.com"

//#define FORCE_CI_TARGET @"Jenkins"
//#define FORCE_CI_TARGET @"Hudson"

#define CONFIGURATION_FILENAME @"hudsonmobile.conf"
#define KEY_SERVICE_HOSTNAME @"service.hostname"
#define KEY_SERVICE_HOSTNAME_SUFFIX @"service.suffix"
#define KEY_SERVICE_PROTOCOL @"service.protocol"
#define KEY_SERVICE_PORT @"service.port"
#define KEY_SERVICE_URL @"service.url"
#define KEY_USERNAME @"username"
#define KEY_PASSWORD @"password"
#define KEY_PASSWORD_SAVE @"password.save"
#define KEY_DESCRIPTION @"description"
#define KEY_USE_XPATH @"use.xpath"
#define KEY_PRODUCT_NAME @"product.name"
#define KEY_PRODUCT_VERSION @"product.version"
#define KEY_API_VERSION @"api.version"
#define KEY_SYNC_TIMEOUT @"sync.timeout"
#define KEY_CONNECTION_TIMEOUT @"connection.timeout"
#define KEY_LAST_UPDATE @"last.update"
#define KEY_HUDSON_INSTANCES_NUM @"hudson.instances.number"
#define KEY_LAST_SELECTED_HUDSON_INSTANCE @"last.hudson.index"
#define KEY_OVERRIDE_HUDSON_URL @"override.hudson.url"
#define KEY_MAX_LOAD_OBJECTS_NUMBER @"load.max.objects.num"
#define KEY_MAX_CONSOLE_LOG_SIZE @"max.console.log.size"
#define KEY_EULA_ACCEPTED @"eula.accepted"
#define KEY_AUDIT_ACCEPTED @"audit.accepted"

@class SimpleHTTPGetter;
@class ConfigurationObject;

@interface Configuration : NSObject {

    NSString* targetCIProductName;
	NSString* url;
	NSString* hudsonHostname;
	NSString* username;
	NSString* password;
    BOOL auditAccepted;
    BOOL eulaAccepted;
	BOOL useXpath;
	BOOL savePassword;
	BOOL connected;
    BOOL overrideHudsonURLWithConfiguredOne;
	NSString* portNumber;
	NSString* description;
	int syncTimeout;
	int connectionTimeout;
	int maxBuildsNumberToLoadAtTime;
    int maxConsoleOutputSize;
	NSString* hudsonVersion;
	NSString* productVersion;
	NSString* productName;
	double lastUpdate;
	id viewToUpdateOnConnectionChange;
	
	int hudsonInstancesNumber;
	
	NSMutableArray* hudsonInstances; //an array of ConfigurationObject objects
	int selectedConfigurationInstance;
	ConfigurationObject* currentConfigurationObject;
	
	SimpleHTTPGetter* shg;
	BOOL sendAliveConnection;
	BOOL isWallLoaded;
	int iOSVersion;
    BOOL isIPhone;
}

@property (nonatomic,retain) NSString* targetCIProductName;
@property (copy) NSString* url;
@property (copy) NSString* portNumber;
@property (copy) NSString* username;
@property (copy) NSString* password;
@property (copy) NSString* description;
@property (assign) BOOL isWallLoaded;
@property (assign) BOOL auditAccepted;
@property (assign) BOOL eulaAccepted;
@property (assign) BOOL useXpath;
@property (assign) BOOL savePassword;
@property (assign) BOOL connected;
@property (assign) BOOL overrideHudsonURLWithConfiguredOne;
@property (assign) int syncTimeout;
@property (assign) int maxBuildsNumberToLoadAtTime;
@property (assign) int connectionTimeout;
@property (assign) int maxConsoleOutputSize;
@property (assign) double lastUpdate;
@property (copy) NSString* hudsonVersion;
@property (copy) NSString* hudsonHostname;
@property (copy) NSString* productVersion;
@property (copy) NSString* productName;
@property (copy) NSString* suffix;
@property (assign) id viewToUpdateOnConnectionChange;
@property (readonly) int iOSVersion;
@property (readonly) BOOL isIPhone;

@property (assign) NSMutableArray* hudsonInstances;
@property (assign) int selectedConfigurationInstance;

+ (Configuration*) getInstance;

-(void)checkConnections;

-(void)loadConfiguration;

-(void)saveConfiguration;

-(void)saveAllConfiguration;

-(void)setSelectedConfigurationInstanceByHostname:(NSString*)hostname;

@end
