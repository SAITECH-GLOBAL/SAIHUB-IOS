//
//  UIViewController+popBack.m
//  TokenOne
//
//  Created by macbook on 2020/10/22.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import "UIViewController+popBack.h"

@implementation UIViewController (popBack)

-(void)popBackWithClassArray:(NSArray *)classArray
{
    NSLog(@"%@",self.navigationController.viewControllers);
    for (UIViewController *controller in [[self.navigationController.viewControllers reverseObjectEnumerator] allObjects]) {
        if ([classArray containsObject:[controller class]]) {
            [self.navigationController popToViewController:controller animated:NO];
            return;
        }
    }
}
@end
