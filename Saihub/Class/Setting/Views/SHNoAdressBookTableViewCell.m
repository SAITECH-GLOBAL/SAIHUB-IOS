//
//  SHNoAdressBookTableViewCell.m
//  Saihub
//
//  Created by macbook on 2022/2/28.
//

#import "SHNoAdressBookTableViewCell.h"
#import "SHAddAddressViewController.h"
@interface SHNoAdressBookTableViewCell()
@property (nonatomic, strong) JLButton *addAdressButton;
@end
@implementation SHNoAdressBookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setConstraints];
    }
    return self;
}
- (void)setConstraints {
    self.addAdressButton.sd_layout.centerXEqualToView(self.contentView).topSpaceToView(self.contentView, 16*FitHeight).widthIs(335*FitWidth).heightIs(78*FitHeight);
}
#pragma mark 按钮事件
-(void)addAdressButtonAction:(UIButton *)btn
{
    [[CTMediator sharedInstance].topViewController.navigationController pushViewController:[SHAddAddressViewController new] animated:YES];
}
#pragma mark 懒加载
-(JLButton *)addAdressButton
{
    if (_addAdressButton == nil) {
        _addAdressButton = [[JLButton alloc]init];
        [_addAdressButton setImage:[UIImage imageNamed:@"addIcon_draw"] forState:UIControlStateNormal];
        _addAdressButton.imagePosition = JLButtonImagePositionLeft;
        _addAdressButton.spacingBetweenImageAndTitle = 5;
        [_addAdressButton setTitle:GCLocalizedString(@"add_address") forState:UIControlStateNormal];
        [_addAdressButton setTitleColor:SHTheme.pageUnselectColor forState:UIControlStateNormal];
        _addAdressButton.titleLabel.font = kCustomMontserratMediumFont(12);
        [_addAdressButton setBackgroundImage:[UIImage imageNamed:@"addAddressCell_addAdressButton"] forState:UIControlStateNormal];
        [_addAdressButton addTarget:self action:@selector(addAdressButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addAdressButton];
    }
    return _addAdressButton;
}
@end
