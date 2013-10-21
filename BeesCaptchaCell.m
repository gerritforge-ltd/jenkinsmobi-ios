//
//  BeesCaptchaCell.m
//  HudsonMobile
//
//  Created by simone on 5/26/11.
//  Copyright 2011 LMIT ltd. All rights reserved.
//

#import "BeesCaptchaCell.h"


@implementation BeesCaptchaCell

@synthesize  descLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end
