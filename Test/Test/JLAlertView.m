
//  Created by ChenHao on 2/11/15.
//  Modified by Zhou jiulong 2/19/16

//  Copyright (c) 2015 xxTeam. All rights reserved.
//

#import "JLAlertView.h"


static const CGFloat KDefaultRadius = 5.0;
static const CGFloat KHHAlertView_Width      = 270;
static const CGFloat KHHAlertView_Height      = 200;
static const CGFloat KHHAlertView_Padding     = 10;
static const NSInteger KbuttonTag = 18888;

@interface JLAlertView()

@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UILabel  *detailLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSArray  *otherButtons;

@property (nonatomic, strong) UIView   *maskView;
@property (nonatomic, strong) UIView   *mainAlertView; //main alert view

@end


@implementation JLAlertView

#pragma mark Lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.xOffset = 0.0;
        self.yOffset = 0.0;
        self.radius  = KDefaultRadius;
		self.alpha   = 0.0;
        self.removeFromSuperViewOnHide = YES;
		
    }
    return self;
}


- (instancetype)initWithTitle:(NSString *)title
                   detailText:(NSString *)detailtext
				   customView:(UIView *)customView
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonsTitles {
    
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.titleText = title;
        self.detailText = detailtext;
		self.customView = customView;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitles = otherButtonsTitles;
        [self layout];
        
    }
    return self;
}


#pragma mark UI

- (void)addView {
    [self addSubview:self.maskView];
    [self addSubview:self.mainAlertView];
	[self.mainAlertView addSubview:self.titleLabel];
    [self.mainAlertView addSubview:self.detailLabel];
	[self.mainAlertView addSubview:self.customView];
}

- (void)setupLabel {
    [self.titleLabel setText:self.titleText];
	self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.titleLabel sizeToFit];
	[self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.detailLabel setText:self.detailText];
    [self.detailLabel setTextColor:[UIColor blackColor]];
    [self.detailLabel setFont:[UIFont systemFontOfSize:13]];
    [self.detailLabel setNumberOfLines:0];
	[self.detailLabel setTextAlignment:NSTextAlignmentCenter];

}

- (void)setupButton {
    if (self.cancelButtonTitle == nil && self.otherButtonTitles ==nil) {
        NSAssert(NO, @"error");
    }
    
    if (self.cancelButtonTitle != nil) {
        self.cancelButton = [[UIButton alloc] init];
        [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
		[self.cancelButton setTitleColor:[UIColor colorWithRed:43/250.0 green:125/250.0 blue:1 alpha:1] forState:UIControlStateNormal];
		[self.cancelButton setBackgroundColor:[UIColor clearColor]];
		[self.cancelButton setBackgroundImage:[JLAlertView createImageWithColor:[UIColor colorWithRed:230/250.0 green:230/250.0 blue:230/250.0 alpha:1.0]] forState:UIControlStateHighlighted];
		[self.cancelButton setBackgroundImage:[JLAlertView createImageWithColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]] forState:UIControlStateNormal];

        [self.cancelButton setTag:KbuttonTag];
        [self.cancelButton addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [[self.cancelButton layer] setCornerRadius:5.0];
        [self.mainAlertView addSubview:self.cancelButton];
    }
    
    if (self.otherButtonTitles != nil) {
        NSMutableArray *tempButtonArray = [[NSMutableArray alloc] init];
        NSInteger i = 1;
        for (NSString *title in self.otherButtonTitles) {
            
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:title forState:UIControlStateNormal];
			[button setTitleColor:[UIColor colorWithRed:43/250.0 green:125/250.0 blue:1 alpha:1] forState:UIControlStateNormal];
			[button setBackgroundColor:[UIColor clearColor]];
			[button setBackgroundImage:[JLAlertView createImageWithColor:[UIColor colorWithRed:230/250.0 green:230/250.0 blue:230/250.0 alpha:1.0]] forState:UIControlStateHighlighted];
			[button setBackgroundImage:[JLAlertView createImageWithColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]] forState:UIControlStateNormal];
            [button setTag:KbuttonTag + i];
            [button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
            [[button layer] setCornerRadius:5.0];
            [tempButtonArray addObject:button];
            [self.mainAlertView addSubview:button];
            i++;
        }
        self.otherButtons = [tempButtonArray copy];
    }
}

#pragma mark Layout

- (void)layout {
    [self addView];
    [self setupLabel];
    [self setupButton];
     NSArray* windows = [UIApplication sharedApplication].windows;
    UIWindow *window = [windows objectAtIndex:0];
    [window addSubview:self];
}


- (void)layoutSubviews {
    [super layoutSubviews];
	CGFloat sumHeight = 0.0;
    [self.mainAlertView setBackgroundColor:[UIColor whiteColor]];
    [[self.mainAlertView layer] setCornerRadius:self.radius];
	
    //titleLabel frame
    CGPoint titleCenter = CGPointMake(CGRectGetWidth(self.mainAlertView.frame)/2, 20+CGRectGetHeight(self.titleLabel.frame)/2);
    [self.titleLabel setCenter:titleCenter];
    
    //detailLabel frame
    [self.detailLabel setFrame:CGRectMake(0, 0, CGRectGetWidth(self.mainAlertView.frame)-KHHAlertView_Padding*2, 0)];
    [self.detailLabel sizeToFit];
	
	
    CGPoint detailCenter = CGPointMake(CGRectGetWidth(self.mainAlertView.frame)/2, 10+CGRectGetHeight(self.detailLabel.frame)/2 + CGRectGetMaxY(self.titleLabel.frame));
    [self.detailLabel setCenter:detailCenter];
	
	
	//customView frame
	if (self.customView) {
		CGFloat width = CGRectGetWidth(self.customView.frame);
		CGFloat height = CGRectGetHeight(self.customView.frame);
		if (width>=KHHAlertView_Width) {
			width = KHHAlertView_Width-4;
		}
		if (self.customView.frame.size.height>350) {
			height = 350;
		}
		[self.customView setFrame:CGRectMake(CGRectGetMinX(self.customView.frame), CGRectGetMinY(self.customView.frame), width, height)];
		CGPoint customCenter = CGPointMake(CGRectGetWidth(self.mainAlertView.frame)/2, 10+CGRectGetHeight(self.customView.frame)/2 + CGRectGetMaxY(self.detailLabel.frame) );
		[self.customView setCenter:customCenter];
		sumHeight = CGRectGetMaxY(self.customView.frame)+20;
	}else{
		sumHeight = CGRectGetMaxY(self.detailLabel.frame)+20;
	}
	
    if (self.cancelButtonTitle != nil && self.otherButtonTitles ==nil){
        CGRect buttonFrame = CGRectMake(0, 0, KHHAlertView_Width, 40);
        [self.cancelButton setFrame:buttonFrame];
        
        CGPoint buttonCenter = CGPointMake(CGRectGetWidth(self.mainAlertView.frame)/2, sumHeight + CGRectGetHeight(self.cancelButton.frame)/2+1);
        [self.cancelButton setCenter:buttonCenter];
		sumHeight += CGRectGetHeight(self.cancelButton.frame);
		[self setLine:CGRectMake(0, self.cancelButton.frame.origin.y, KHHAlertView_Width, 1)];
		[JLAlertView drawCornerForView:self.cancelButton withRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    }
    
    if (self.cancelButtonTitle != nil && [self.otherButtonTitles count]==1) {
        CGRect buttonFrame = CGRectMake(0, 0, KHHAlertView_Width /2, 40);
        [self.cancelButton setFrame:buttonFrame];
        
        CGPoint leftButtonCenter = CGPointMake(CGRectGetWidth(self.cancelButton.frame)/2, sumHeight + CGRectGetHeight(self.cancelButton.frame)/2+1);
        [self.cancelButton setCenter:leftButtonCenter];
        
        UIButton *rightButton = (UIButton *)self.otherButtons[0];
        [rightButton setFrame:buttonFrame];
        
        CGPoint rightButtonCenter = CGPointMake(KHHAlertView_Width*3/4, sumHeight + CGRectGetHeight(self.cancelButton.frame)/2+1);
        [rightButton setCenter:rightButtonCenter];
		
		sumHeight +=CGRectGetHeight(self.cancelButton.frame);
 		[self setLine:CGRectMake(0, self.cancelButton.frame.origin.y, KHHAlertView_Width, 1)];
		[self setLine:CGRectMake(KHHAlertView_Width/2, self.cancelButton.frame.origin.y, 1, 40)];
		[JLAlertView drawCornerForView:self.cancelButton withRoundingCorners:UIRectCornerBottomLeft ];
		[JLAlertView drawCornerForView:rightButton withRoundingCorners:UIRectCornerBottomRight];
    }
	if (self.cancelButtonTitle == nil && [self.otherButtonTitles count]==1) {
		
		UIButton *rightButton = (UIButton *)self.otherButtons[0];
		CGRect buttonFrame = CGRectMake(0, 0, KHHAlertView_Width, 40);
		[rightButton setFrame:buttonFrame];
		
		CGPoint buttonCenter = CGPointMake(CGRectGetWidth(self.mainAlertView.frame)/2, sumHeight + 40/2);
		[rightButton setCenter:buttonCenter];
		sumHeight += 40;
		[self setLine:CGRectMake(0, rightButton.frame.origin.y, KHHAlertView_Width, 1)];
		[JLAlertView drawCornerForView:rightButton withRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
	}
    if (self.cancelButtonTitle != nil && [self.otherButtonTitles count]>1) {
        
        CGRect buttonFrame = CGRectMake(0, 0, KHHAlertView_Width, 40);
        
        for (NSInteger i = self.otherButtons.count-1; i>=0; i--) {
            UIButton *button = (UIButton *)self.otherButtons[i];
            [button setFrame:buttonFrame];
            
            CGPoint pointCenter = CGPointMake(CGRectGetWidth(self.mainAlertView.frame)/2, sumHeight + 40/2);
            [button setCenter:pointCenter];
			sumHeight += 40;
			[self setLine:CGRectMake(0, button.frame.origin.y, KHHAlertView_Width, 1)];
        }

        [self.cancelButton setFrame:buttonFrame];
        
        CGPoint leftButtonCenter = CGPointMake(CGRectGetWidth(self.mainAlertView.frame)/2, sumHeight+20);
        [self.cancelButton setCenter:leftButtonCenter];
		[self setLine:CGRectMake(0, self.cancelButton.frame.origin.y, KHHAlertView_Width, 1)];
		sumHeight += 40;
		[JLAlertView drawCornerForView:self.cancelButton withRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    }
	sumHeight +=2;
	CGRect frame = CGRectMake(CGRectGetMinX(self.mainAlertView.frame), CGRectGetMinY(self.mainAlertView.frame), KHHAlertView_Width, sumHeight);
	self.mainAlertView.frame = frame;
	UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	[self.mainAlertView setCenter:window.center];

}

#pragma mark Event Response

- (void)buttonTouch:(UIButton *)button {
    if (self.completeBlock) {
        self.completeBlock(button.tag - KbuttonTag);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JLAlertView:didClickButtonAnIndex:)]) {
        [self.delegate JLAlertView:self didClickButtonAnIndex:button.tag - KbuttonTag];
    }
    [self hide];
}


#pragma mark show & hide 

- (void)show {
    NSTimeInterval interval = 0.3;
    CGRect frame = self.mainAlertView.frame;
    if (self.enterMode) {
        switch (self.enterMode) {
            case JLAlertEnterModeTop:
            {
                frame.origin.y -= CGRectGetHeight([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case JLAlertEnterModeBottom:
            {
                frame.origin.y += CGRectGetHeight([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case JLAlertEnterModeLeft:
            {
                frame.origin.x -= CGRectGetWidth([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case JLAlertEnterModeRight:
            {
                frame.origin.x += CGRectGetWidth([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case JLAlertEnterModeFadeIn:
            {
           
            }
                break;
            
            default:
                break;
        }
    }
    [self.mainAlertView setFrame:frame];
    [UIView animateWithDuration:interval animations:^{
        [self setAlpha:1];
        [self.mainAlertView setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showWithBlock:(selectButtonIndexComplete)completeBlock {
    self.completeBlock = completeBlock;
    [self show];
}

- (void)hide {
    NSTimeInterval interval = 0.3;
    CGRect frame = self.mainAlertView.frame;
    if (self.leaveMode) {
        switch (self.leaveMode) {
            case JLAlertLeaveModeTop:
            {
                frame.origin.y -= CGRectGetHeight([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case JLAlertLeaveModeBottom:
            {
                frame.origin.y += CGRectGetHeight([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case JLAlertLeaveModeLeft:
            {
                frame.origin.y -= CGRectGetWidth([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case JLAlertLeaveModeRight:
            {
                frame.origin.x += CGRectGetWidth([[UIScreen mainScreen] bounds]);
                interval = 0.5;
            }
                break;
            case JLAlertLeaveModeFadeOut:
            {
                
            }
                break;
                
            default:
                break;
        }
    }
 
    [UIView animateWithDuration:interval animations:^{
        [self setAlpha:0];
        [self.mainAlertView setFrame:frame];
    } completion:^(BOOL finished) {
        if (self.removeFromSuperViewOnHide) {
            [self removeFromSuperview];
        }
    }];
}


#pragma mark getter and setter

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        [_maskView setBackgroundColor:[UIColor blackColor]];
        [_maskView setAlpha:0.3];
    }
    return _maskView;
}

- (UIView *)mainAlertView {
    if (!_mainAlertView) {
        _mainAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KHHAlertView_Width, KHHAlertView_Height)];
        [_mainAlertView setCenter:self.center];
    }
    return _mainAlertView;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
    }
    return _detailLabel;
}
- (void)setLine:(CGRect)frame
{
	UIView *line = [[UIView alloc] initWithFrame:frame];
	line.backgroundColor = [UIColor colorWithRed:219/250.0 green:219/250.0 blue:223/250.0 alpha:1.0];
	[self.mainAlertView addSubview:line];
}

- (void)setButtonTitleColor:(UIColor *)buttonTitleColor
{
	_buttonTitleColor = buttonTitleColor;
	if (self.cancelButton) {
		[self.cancelButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
	}
	for (UIButton *button in self.otherButtons) {
		[button setTitleColor:buttonTitleColor forState:UIControlStateNormal];
	}
}

- (void)setButtonBackgroundColor:(UIColor *)buttonBackgroundColor
{
	_buttonBackgroundColor = buttonBackgroundColor;
	if (self.cancelButton) {
		[self.cancelButton setBackgroundColor:buttonBackgroundColor];
	}
	for (UIButton *button in self.otherButtons) {
		[button setBackgroundColor:buttonBackgroundColor];
	}
}
- (void)setCancelButtonTitleColor:(UIColor *)cancelButtonTitleColor
{
	[self.cancelButton setTitleColor:cancelButtonTitleColor forState:UIControlStateNormal];
}

- (void)setOtherButtonsTitleColor:(NSArray *)otherButtonsTitleColor
{
	for (UIButton *button in self.otherButtons) {
		NSUInteger index = [self.otherButtons indexOfObject:button];
		[button setTitleColor:otherButtonsTitleColor[index]  forState:UIControlStateNormal];
	}
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
	CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);
	
	UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return theImage; 
}
+ (void)drawCornerForView:(UIView*)view withRoundingCorners:(UIRectCorner)corners
{
	UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(8, 8)];
	CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
	maskLayer.frame = view.bounds;
	maskLayer.path = maskPath.CGPath;
	view.layer.mask = maskLayer;
}
@end
