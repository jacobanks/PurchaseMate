//
//  searchViewCell.m
//  PurchaseMate
//
//  Created by Jacob Banks on 4/23/16.
//  Copyright © 2016 Jacobanks. All rights reserved.
//

#import "searchViewCell.h"

@implementation searchViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 95.0, 106.0, 20)];
        self.titleLabel.text = @"";
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self.titleLabel setBackgroundColor:[UIColor redColor]];
        [self addSubview:self.titleLabel];
    }
    return self;
}

@end

