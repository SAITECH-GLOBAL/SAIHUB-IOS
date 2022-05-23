//
//  SHRefreshFooter.m
//  Saihub
//
//  Created by 周松 on 2022/2/28.
//

#import "SHRefreshFooter.h"
#import "SHRefreshLoadingView.h"

@interface SHRefreshFooter ()

@property (nonatomic, strong) SHRefreshLoadingView *loadingView;

@end

@implementation SHRefreshFooter

- (SHRefreshLoadingView *)loadingView {
    if (_loadingView == nil) {
        _loadingView = [SHRefreshLoadingView animationNamed:@"loadingGif"];
        _loadingView.contentMode = UIViewContentModeScaleToFill;
        _loadingView.animationSpeed = 1.5;
        _loadingView.loopAnimation = YES;
        [self addSubview:_loadingView];
    }
    return _loadingView;
}

- (void)prepare {
    [super prepare];
    
}

-  (void)placeSubviews {
    [super placeSubviews];
    
    if (self.state == MJRefreshStateNoMoreData) {
        self.stateLabel.hidden = NO;
        self.loadingView.hidden = YES;

    } else {
        self.stateLabel.hidden = YES;
        self.loadingView.hidden = NO;
    }
    
    self.loadingView.frame = CGRectMake(kScreenWidth / 2 - 18, self.mj_h / 2 - 18, 36, 36);

}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    self.loadingView.hidden = NO;
    self.stateLabel.hidden = YES;
    
    // 根据状态做事情
    if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
        [self.loadingView play];
    } else if (state == MJRefreshStateIdle) {
        [self.loadingView stop];
    } else if (state == MJRefreshStateNoMoreData) {
        [self.loadingView stop];
        self.stateLabel.hidden = NO;
        self.loadingView.hidden = YES;
    }
}

@end
