//
//  searchCollectionViewCell.m
//  PurchaseMate
//
//  Created by Jacob Banks on 4/23/16.
//  Copyright © 2016 Jacobanks. All rights reserved.
//

#import "searchCollectionViewCell.h"

@implementation searchCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, CGRectGetWidth(frame) - 20, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.titleLabel];
    }
    
    return self;
}

@end
