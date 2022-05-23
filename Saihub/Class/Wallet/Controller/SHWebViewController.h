//
//  SHWebViewController.h
//  NewExchange
//
//  Created by 周松 on 2021/12/14.
//

#import "SHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHWebViewController : SHBaseViewController

@property (nonatomic,copy) NSString *fileUrl;
///标题
@property (nonatomic,copy) NSString *titleStr;
///是否需要获取web的标题
@property (nonatomic,assign) BOOL isNeedWebviewTitle;
///是否需要关闭按钮
@property (nonatomic,assign) BOOL isNeedCloseButton;

@end

NS_ASSUME_NONNULL_END
