//
//  JLAlertView.h
//  Test
//
//  Created by 周九龙 on 16/2/18.
//  Copyright © 2016年 Carlos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JLAlertViewDelegate;

/**
 *  the block to tell user whitch button is clicked
 *
 *  @param button button
 */
typedef void (^selectButtonIndexComplete)(NSInteger index);

@interface JLAlertView : UIView


/**
 *  show a alert view with title detailTitle and at least one button
 *
 *  @param title              titleString
 *  @param detailtext         detailStrng
 *  @param superView          the view that alertview will show
 *  @param cancelButtonTitle  cancel button's title
 *  @param otherButtonsTitles ohter button's titles
 *
 *  @return instance of alertview
 */
- (instancetype)initWithTitle:(NSString *)title
				   message:(nullable NSString *)message delegate:(nullable id)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ...;


/**
 *  dismiss the alertview
 */
- (void)hide;


/**
 *  show the alertview
 */
- (void)show;


/**
 *  show method with block to konw which button clicked
 *
 *  @param completeBlock
 */
- (void)showWithBlock:(selectButtonIndexComplete)completeBlock;


@property (nonatomic, weak)   id<JLAlertViewDelegate> delegate;

@property (nonatomic, copy)   selectButtonIndexComplete completeBlock;


/**
 * An optional short message to be displayed on the title label.
 * the entire text. If the text is too long it will get clipped by displaying "..." at the end.
 * set to @"", then no message is displayed.
 */
@property (nonatomic, copy)   NSString *titleText;

/**
 * An optional details message displayed below the titleText message.
 * property is also set and is different from an empty string (@""). The details text can span multiple lines.
 */
@property (nonatomic, copy)   NSString *message;

/**
 * The UIView (e.g., a UIImageView) to be shown when the AlertView is in HHAlertViewModeCustom.
 * For best results use a 60 by 60 pixel view.
 *
 */
@property (nonatomic, strong) UIView *customView;

/**
 * The x-axis offset of the AlertView relative to the centre of the superview.
 */
@property (nonatomic, assign) CGFloat xOffset;

/**
 * The y-axis offset of the AlertView relative to the centre of the superview.
 */
@property (nonatomic, assign) CGFloat yOffset;

/**
 *  the radius of the alertview
 *  default value is 5.0
 */
@property (nonatomic, assign) CGFloat radius;

/**
 * An optional short message to be displayed on the cancel button.
 * the entire text. If the text is too long it will get clipped by displaying "..." at the end. If left unchanged or
 * set to nil if have no cancel buttons.
 */
@property (nonatomic, copy)   NSString  *cancelButtonTitle;

/**
 *  An array of String of button's title
 *  set to nil if have no other buttons
 */
@property (nonatomic, strong) NSArray   *otherButtonTitles;

/**
 * Removes the HUD from its parent view when hidden.
 * Defaults to YES.
 */
@property (nonatomic, assign) BOOL removeFromSuperViewOnHide;

@end


@protocol JLAlertViewDelegate <NSObject>

@optional
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(JLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
