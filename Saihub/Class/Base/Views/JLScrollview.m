//
//  JLScrollview.m
//  AiDouVideo
//
//  Created by 周松 on 2019/8/23.
//  Copyright © 2019 zhaohong. All rights reserved.
//

#import "JLScrollview.h"

@implementation JLScrollview

- (instancetype)init {
    if (self = [super init]) {
        self.delaysContentTouches = NO;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.delaysContentTouches = NO;
    }
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ([view isKindOfClass:[UIButton class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}
@end
