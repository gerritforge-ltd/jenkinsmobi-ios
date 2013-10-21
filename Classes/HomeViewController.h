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

#import <UIKit/UIKit.h>
#import "InputTableViewCell4.h"
#import "ViewListViewController.h"
#import "EulaViewer.h"

@class LoadingView;
@class Configuration;
@class HudsonLoginObject;
@class ProductInfoViewController;
@class HudsonInstancesTableViewController;
@class ConfigurationObject;
@class Logger;

@interface HomeViewController : UIViewController {

	IBOutlet UITableView* instancesTableView;	
	IBOutlet UIImageView* background;
	IBOutlet UIButton* infoDarkButton;
	LoadingView* loadingView;
	bool firstScrolledToViewLastInstanceIndex;
	HudsonLoginObject* loginObject;
    BOOL forceNotCheckInstancesReachability;
    
}

@property(nonatomic, retain) IBOutlet UITableView* instancesTableView;
@property(nonatomic, retain) IBOutlet UIImageView* background;
@property(nonatomic, retain) IBOutlet UIButton* infoDarkButton;

- (IBAction) loginButtonClick:(id)sender;
- (IBAction) configButtonClick:(id)sender;
- (IBAction) showInfo:(id)sender;


@end
