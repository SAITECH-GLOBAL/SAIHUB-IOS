//
//  SHTextField.m
//  Saihub
//
//  Created by macbook on 2022/4/19.
//

#import "SHTextField.h"

@implementation SHTextField

-(void)deleteBackward {
    
    [super deleteBackward];
    if ([self.z_delegate respondsToSelector:@selector(zTextFieldDeleteBackward:)]) {
        [self.z_delegate zTextFieldDeleteBackward:self];
    }
    
}


@end
