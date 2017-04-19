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
#define kWCSChatViewDefaultFont [UIFont systemFontOfSize:14.0f]
#define kWCSChatViewDefaultPadding 20

#pragma mark - WCSChatData

@interface WCSChatData ()

@end

@implementation WCSChatData

- (NSString*)description {
    return [NSString stringWithFormat:@"<<WCSChatData: > Frames=<timestamp:%@, icon:%@, content:%@>, model=%@>",
            NSStringFromCGRect(self.timestampFrame),
            NSStringFromCGRect(self.iconFrame),
            NSStringFromCGRect(self.contentFrame),
            self.model            
            ];
}


- (NSDictionary*)dictionary {
    return @{
             @"timestamp":self.model.timestamp,
             @"message":self.model.message,
             @"type":@(self.model.type)
             };
}

- (void)setModel:(WCSChatModel *)model
{
    _model = model;
    
    CGFloat padding = 10;
    
    if ( model.hasTimestamp == true )
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
    
    
    CGFloat textX = 0.0;
    CGFloat textY = iconY + padding;
    
    CGSize textMaxSize = CGSizeMake(300, MAXFLOAT);
    CGSize textRealSize = [model.message boundingRectWithSize:textMaxSize
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:kWCSChatViewDefaultFont} context:nil].size;
    
    CGSize contentSize = CGSizeMake(textRealSize.width + 40, textRealSize.height + 40);
    switch ( model.type ) {
        case WCSMessageTypeSent: {
            textX = kWCSChatViewScreenWidth - iconW - padding * 2 - contentSize.width;
            break;
        }
        case WCSMessageTypeReceived: {
            textX = padding + iconW;
            break;
        }
    }
    _contentFrame = (CGRect){{textX, textY}, contentSize};
    
    
    CGFloat iconMaxY = CGRectGetMaxY(_iconFrame);
    CGFloat textMaxY = CGRectGetMaxY(_contentFrame);
    _cellHeight = MAX(iconMaxY, textMaxY);
}

@end

#pragma mark - WCSChatCell

@interface WCSChatCell ()
@property (nonatomic, strong) UIImageView * imageIcon;
@property (nonatomic, strong) UILabel * labelDate;
@property (nonatomic, strong) UIButton * buttonMessage;
@end

@implementation WCSChatCell

+ (instancetype)messageCellWithTableView:(UITableView *)tableview
{
    static NSString * cellIdentifier = @"WCSChatCell";
    WCSChatCell * cell = [tableview dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        self.imageIcon = [[UIImageView alloc]init];
        [self addSubview:self.imageIcon];
        
        self.labelDate = [[UILabel alloc]init];
        self.labelDate.textAlignment = NSTextAlignmentCenter;
        self.labelDate.font = [UIFont boldSystemFontOfSize:13.0f];
        self.labelDate.textColor = [UIColor lightGrayColor];
        [self addSubview:self.labelDate];
        
        self.buttonMessage = [[UIButton alloc]init];
        self.buttonMessage.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        self.buttonMessage.titleLabel.numberOfLines = 0;
        self.buttonMessage.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
        [self.buttonMessage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:self.buttonMessage];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setChatData:(WCSChatData *)chatData
{
    _chatData = chatData;
    
    WCSChatModel * model = chatData.model;
    
    self.labelDate.frame = chatData.timestampFrame;
    self.labelDate.text = [NSString stringWithFormat:@"%@", [model.timestamp timeAgo]];
    
    
    self.imageIcon.frame = chatData.iconFrame;
    self.imageIcon.image = model.icon;
    self.imageIcon.layer.cornerRadius = chatData.iconFrame.size.width/2;
    self.imageIcon.layer.masksToBounds = true;

    
    self.buttonMessage.frame = chatData.contentFrame;
    [self.buttonMessage setTitle:model.message forState:UIControlStateNormal];
    switch ( model.type ) {
        case WCSMessageTypeSent: {
            self.imageIcon.backgroundColor = [UIColor clearColor];
            [self.buttonMessage setBackgroundImage:[UIImage resizeWithImageName:@"chat-type-sent"] forState:UIControlStateNormal];
            break;
        }
        case WCSMessageTypeReceived: {
            self.imageIcon.backgroundColor = [UIColor clearColor];
            [self.buttonMessage setBackgroundImage:[UIImage resizeWithImageName:@"chat-type-received"] forState:UIControlStateNormal];
            break;
        }
    }
}


@end
