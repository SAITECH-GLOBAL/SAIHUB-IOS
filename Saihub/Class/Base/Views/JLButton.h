//
//  JLButton.h
//  AiDouVideo
//
//  Created by 周松 on 2019/8/21.
//  Copyright © 2019 zhaohong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 控制图片在UIButton里的位置，默认为GDTButtonImagePositionLeft
typedef NS_ENUM(NSUInteger, JLButtonImagePosition) {
    JLButtonImagePositionTop,             // imageView在titleLabel上面
    JLButtonImagePositionLeft,            // imageView在titleLabel左边
    JLButtonImagePositionBottom,          // imageView在titleLabel下面
    JLButtonImagePositionRight,           // imageView在titleLabel右边
};

@interface JLButton : UIButton


/**
 * 设置按钮里图标和文字的相对位置，默认为JLButtonImagePositionLeft
 * 可配合imageEdgeInsets、titleEdgeInsets、contentHorizontalAlignment、contentVerticalAlignment使用
 */
@property(nonatomic, assign) JLButtonImagePosition imagePosition;

/**
 * 设置按钮里图标和文字之间的间隔，会自动响应 imagePosition 的变化而变化，默认为0。<br/>
 * 系统默认实现需要同时设置 titleEdgeInsets 和 imageEdgeInsets，同时还需考虑 contentEdgeInsets 的增加（否则不会影响布局，可能会让图标或文字溢出或挤压），使用该属性可以避免以上情况。<br/>
 * @warning 会与 imageEdgeInsets、 imageEdgeInsets、 contentEdgeInsets 共同作用。
 */
@property(nonatomic, assign) CGFloat spacingBetweenImageAndTitle;

@property (nonatomic, assign, getter=isLoading) BOOL loading;

@end

NS_ASSUME_NONNULL_END
