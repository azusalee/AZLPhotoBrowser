//
//  AZLAlbumTableViewCell.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/21.
//

#import "AZLAlbumTableViewCell.h"

@implementation AZLAlbumTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self; 
}

- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.lastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    [self.contentView addSubview:self.lastImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(79, 0, [UIScreen mainScreen].bounds.size.width-94, 64)];
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel];
    
    self.sepLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63, [UIScreen mainScreen].bounds.size.width, 1)];
    self.sepLineView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.sepLineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
