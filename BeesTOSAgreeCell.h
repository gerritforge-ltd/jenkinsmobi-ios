//
//  BeesTOSAgreeCell.h
//  HudsonMobile
//
//  Created by simone on 5/26/11.
//  Copyright 2011 LMIT ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeesTOSAgreeCell : UITableViewCell {
    
    IBOutlet UISwitch* onoffSwitch;
    IBOutlet UILabel* descLabel;
    IBOutlet UIButton* showTOSButton;
    SEL inputCellUpdateSelector;
    id parent;
}

@property (nonatomic,retain) IBOutlet UISwitch* onoffSwitch;
@property (nonatomic,retain) IBOutlet UILabel* descLabel;
@property (nonatomic,retain) IBOutlet UIButton* showTOSButton;
@property (assign) SEL inputCellUpdateSelector;
@property (nonatomic,retain) id parent;

@end
