//
//  SHBottomSelectViewController.m
//  Saihub
//
//  Created by macbook on 2022/6/20.
//

#import "SHBottomSelectViewController.h"
@class NESelectCell;
@interface SHBottomSelectViewController ()<HWPanModalPresentable,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) CGFloat contentHeight;
@end

@implementation SHBottomSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setSubviews];
}

- (void)setSubviews {
    UIImageView *lineView = [[UIImageView alloc]init];;
    [self.view addSubview:lineView];
    lineView.image = [UIImage imageNamed:@"align_center"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.centerX.mas_equalTo(0);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = SHTheme.appBlackColor;
    titleLabel.font = kCustomMontserratMediumFont(14);
    [self.view addSubview:titleLabel];
    if (self.bottomSelectType == SHBottomAddWalletSelectType) {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(40);
        }];
        titleLabel.text = GCLocalizedString(@"Select_type");
    }else
    {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.mas_equalTo(32);
        }];
        titleLabel.text = GCLocalizedString(@"Refill");
    }


    
    NSInteger count = self.titleArray.count;
    if (count > 8) {
        count = 8;
    }
    
    CGFloat topMargin = 80;
    
    self.contentHeight = count * 68 + topMargin + 10;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topMargin, kScreenWidth , count * 68) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[NESelectCell class] forCellReuseIdentifier:@"NESelectCellID"];
    tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    tableView.rowHeight = 68;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NESelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NESelectCellID" forIndexPath:indexPath];
    NSString *title = self.titleArray[indexPath.row];
    cell.titleLabel.text = title;
    if (self.bottomSelectType == SHBottomAddWalletSelectType) {
    cell.walletIcon.image = [UIImage imageNamed:indexPath.row == 0?@"btcWallet_icon":@"lnWallet_icon"];
    }else
    {
        cell.walletIcon.image = [UIImage imageNamed:@""];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = self.titleArray[indexPath.row];
//    [tableView reloadData];
    if (self.selectTitleBlock) {
        self.selectTitleBlock(title, indexPath.row);
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, self.contentHeight);
}

- (HWBackgroundConfig *)backgroundConfig {
    HWBackgroundConfig *backgroundConfig;
    backgroundConfig = [HWBackgroundConfig configWithBehavior:HWBackgroundBehaviorSystemVisualEffect];
    backgroundConfig.visualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    return backgroundConfig;
}

- (NSTimeInterval)dismissalDuration {
    return 0.2;
}

- (BOOL)showDragIndicator {
    return NO;
}

/// 顶部圆角
- (CGFloat)cornerRadius {
    return 10;
}


@end
@implementation NESelectCell
-(UIView *)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIView alloc]init];
        _bgView.layer.cornerRadius = 8;
        _bgView.layer.masksToBounds = YES;
        _bgView.backgroundColor = SHTheme.addressTypeCellBackColor;
        [self.contentView addSubview:_bgView];
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = SHTheme.appBlackColor;
        _titleLabel.font = kCustomMontserratRegularFont(14);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (UIImageView *)walletIcon {
    if (_walletIcon == nil) {
        _walletIcon = [[UIImageView alloc]init];
        [self.contentView addSubview:_walletIcon];
    }
    return _walletIcon;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = SHTheme.appWhightColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.bgView.sd_layout.centerXEqualToView(self.contentView).topEqualToView(self.contentView).widthIs(335*FitWidth).heightIs(52*FitHeight);
        self.titleLabel.sd_layout.centerXEqualToView(self.contentView).centerYEqualToView(self.bgView).heightIs(20);
        [self.titleLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];

        [self.walletIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.titleLabel.mas_left).mas_equalTo(-10);
            make.centerY.equalTo(self.titleLabel);
            make.width.height.mas_equalTo(20);
        }];
    }
    return self;
}

@end
