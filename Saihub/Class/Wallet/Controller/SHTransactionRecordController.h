//
//  SHTransactionRecordController.h
//  Saihub
//
//  Created by 周松 on 2022/2/28.
//

#import "SHBaseViewController.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SHTransactionRecordControllerType) {
    SHTransactionRecordControllerTypeAll,
    SHTransactionRecordControllerTypeOut,
    SHTransactionRecordControllerTypeIn,
    SHTransactionRecordControllerTypeFail
};

@protocol SHTransactionRecordControllerDelegate <NSObject>

/// 请求数据
- (void)requestRecordWithType:(SHTransactionRecordControllerType)controllerType;

/// 跳转到区块浏览器
- (void)pushBlockExpolor;

@end

@interface SHTransactionRecordController : SHBaseViewController <JXPagerViewListViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

/// 将刷新请求交给父控制器
@property (nonatomic, weak) id <SHTransactionRecordControllerDelegate> delegate;

/// 数据源
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) SHTransactionRecordControllerType controllerType;

@property (nonatomic, strong) SHWalletTokenModel *tokenModel;

@end

NS_ASSUME_NONNULL_END
