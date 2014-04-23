//
//  ITLabCollectionViewCellPercentage.m
//  CDF Labs
//
//  Created by Ishan Thukral on 2014-04-23.
//  Copyright (c) 2014 Ishan Thukral. All rights reserved.
//

#import "ITLabCollectionViewCellPercentage.h"
#import "UIColor+CDFLabs.h"
#import "ITLab.h"

@implementation ITLabCollectionViewCellPercentage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupCellWithLab:(ITLab *)lab {
    self.labName.text = lab.labName;
    self.labBusyPercentage.text = [NSString stringWithFormat:@"%@%%", lab.percentageBusy];
    self.labNameBackground.backgroundColor = [UIColor labCellBackgroundColor];
    self.topCellBackground.backgroundColor = ([lab.percentageBusy integerValue] > 80) ? [UIColor labCellRedColor] : [UIColor labCellGreenColor];
}


@end
