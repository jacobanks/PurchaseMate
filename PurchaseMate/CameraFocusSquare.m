//
//  CameraFocusSquare.m
//  
//
//  Created by Jacob Banks on 3/5/16.
//
//

#import "CameraFocusSquare.h"
#import <QuartzCore/QuartzCore.h>

const float squareLength = 80.0f;

@implementation CameraFocusSquare

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code        
        [self setBackgroundColor:[UIColor clearColor]];
        [self.layer setBorderWidth:2.0];
        [self.layer setCornerRadius:4.0];
        [self.layer setBorderColor:[UIColor whiteColor].CGColor];
    }
    return self;
}

@end
