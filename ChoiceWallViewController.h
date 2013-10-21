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
#import "HomeViewController.h"
#import "QueueListViewController.h"
#import "SlaveListViewController.h"
#import "ViewListViewController.h"
#import "UserListViewController.h"
#import "HudsonInstancesTableViewController.h"
#import "HudsonLoginObject.h"
#import "Configuration.h"
#import "LoadingView.h"

#define TIME_FOR_SHRINKING 0.31f // Has to be different from SPEED_OF_EXPANDING and has to end in 'f'
#define TIME_FOR_EXPANDING 0.30f // Has to be different from SPEED_OF_SHRINKING and has to end in 'f'
#define SCALED_DOWN_AMOUNT 0.01  // For example, 0.01 is one hundredth of the normal size


@interface ChoiceWallViewController : UIViewController {

    IBOutlet UIButton* runAtCloudeWallItem;
    IBOutlet UILabel* runAtCloudWallItemLabel;
    IBOutlet UILabel* viewsWallItemLabel;
    IBOutlet UILabel* queueWallItemLabel;
    IBOutlet UILabel* monitorWallItemLabel;
    IBOutlet UILabel* usersWallItemLabel;
    IBOutlet UILabel* nodesWallItemLabel;    
    
    HudsonLoginObject* loginObject;
    LoadingView* loadingView;
    UIViewController* viewController;
    BOOL poppingToToRoot;
}

@property (nonatomic,retain) IBOutlet UIButton* runAtCloudeWallItem;
@property (nonatomic,retain) IBOutlet UILabel* runAtCloudWallItemLabel;
@property (nonatomic,retain) IBOutlet UILabel* viewsWallItemLabel;
@property (nonatomic,retain) IBOutlet UILabel* queueWallItemLabel;
@property (nonatomic,retain) IBOutlet UILabel* monitorWallItemLabel;
@property (nonatomic,retain) IBOutlet UILabel* usersWallItemLabel;
@property (nonatomic,retain) IBOutlet UILabel* nodesWallItemLabel;    

@end
