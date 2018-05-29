//
//  IAAPushNoteView.h
//  TLV Airport
//
//  Created by Aviel Gross on 1/29/14.
//  Copyright (c) 2014 NGSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGPushNote : NSObject

@property NSString* message; //message text
@property NSString* iconImageName; // icon to be shown on left
@property UIImage* iconImage;
@property UIImage* closeImage;
@property NSDictionary* userInfo; // to pass the actual user info if this is push notification triggered
@property UIColor *backgroundColor;
@property UIColor *textColor;
@property UIFont *textFont;
@property CGFloat messageHeight;
@property BOOL showAtBottom;
@property BOOL queue;

- (void) setDefaultUI;

@end

@protocol AGPushNoteViewDelegate <NSObject>
@optional
- (void)pushNoteDidAppear; // Called after the view has been fully transitioned onto the screen. (equel to completion block).
- (void)pushNoteWillDisappear; // Called before the view is hidden, after the message action block.
@end

@interface AGPushNoteView : UIView



+ (void)showNotification:(AGPushNote*)pushNote;
+ (void)showNotification:(AGPushNote *)pushNote completion:(void (^)(void))completion;
+ (void)closeWithCompletion:(void (^)(void))completion;

+ (void)setMessageAction:(void (^)(AGPushNote* pushNote))action;
+ (void) setCloseAction:(void (^)(void))completion;
+ (void)setDelegateForPushNote:(id<AGPushNoteViewDelegate>)delegate;

@property (nonatomic, weak) id<AGPushNoteViewDelegate> pushNoteDelegate;
@end
