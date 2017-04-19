//
//  WCSChatCell.m
//  WCSChatView
//
//  Created by Aaron Wright on 4/18/17.
//  Copyright © 2017 Wrights Creative Services, L.L.C. All rights reserved.
//

#import "WCSChatCell.h"

#define kWCSChatViewScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kWCSChatViewCellHeight 44
#define kWCSCHatViewIconSize 50
#define kWCSChatViewDefaultFont [UIFont systemFontOfSize:15.0f]
#define kWCSChatViewDefaultPadding 20

@interface WCSChatCell ()
@property (nonatomic, strong) UIImageView * imageIcon;
@property (nonatomic, strong) UILabel * labelDate;
@property (nonatomic, strong) UIButton * buttonMessage;
@end

@implementation WCSChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)messageCellWithTableView:(UITableView *)tableview
{
    static NSString *ID = @"WCSChatCell";
    WCSChatCell * cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        self.imageIcon = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imageIcon];
        
        self.labelDate = [[UILabel alloc]init];
        self.labelDate.textAlignment = NSTextAlignmentCenter;
        self.labelDate.font = [UIFont boldSystemFontOfSize:13.0f];
        [self.contentView addSubview:self.labelDate];
        
        self.buttonMessage = [[UIButton alloc]init];
        self.buttonMessage.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        self.buttonMessage.titleLabel.numberOfLines = 0;//自动换行
        self.buttonMessage.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
        [self.buttonMessage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.buttonMessage];
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)setModel:(WCSChatModel *)model
{
    _model = model;
    
    CGFloat padding = 10;
    
    if ( model.hasTimestamp == false )
    {
        CGFloat timeX = 0;
        CGFloat timeY = 0;
        CGFloat timeW = kWCSChatViewScreenWidth;
        CGFloat timeH = kWCSChatViewCellHeight;
        
        _timestampFrame = CGRectMake(timeX, timeY, timeW, timeH);
    }
    

    CGFloat iconX;
    CGFloat iconY = CGRectGetMaxY(_timestampFrame);
    CGFloat iconW = kWCSCHatViewIconSize;
    CGFloat iconH = kWCSCHatViewIconSize;
    switch ( model.type )
    {
        case WCSMessageTypeSent: {
            iconX = kWCSChatViewScreenWidth - iconW - padding;
            break;
        }
        case WCSMessageTypeReceived: {
            iconX = padding;
            break;
        }
    }
    _iconFrame =  CGRectMake(iconX, iconY, iconW, iconH);
    
    
    CGFloat textX;
    CGFloat textY = iconY + padding;
    
    CGSize textMaxSize = CGSizeMake(150, MAXFLOAT);
    CGSize textRealSize = [model.message boundingRectWithSize:textMaxSize
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:kWCSChatViewDefaultFont} context:nil].size;
    
    CGSize btnSize = CGSizeMake(textRealSize.width + 40, textRealSize.height + 40);
    switch ( model.type )
    {
        case WCSMessageTypeSent: {
            textX = kWCSChatViewScreenWidth - iconW - padding * 2 - btnSize.width;
            break;
        }
        case WCSMessageTypeReceived: {
            textX = padding + iconW;
            break;
        }
    }
    _contentFrame = (CGRect){{textX,textY},btnSize};
    
    
    CGFloat iconMaxY = CGRectGetMaxY(_iconFrame);
    CGFloat textMaxY = CGRectGetMaxY(_contentFrame);
    _cellHeight = MAX(iconMaxY, textMaxY);
}

@end
