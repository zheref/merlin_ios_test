//
//  IAAPushNoteView.m
//  TLV Airport
//
//  Created by Aviel Gross on 1/29/14.
//  Copyright (c) 2014 NGSoft. All rights reserved.
//

#import "AGPushNoteView.h"

#define APP [UIApplication sharedApplication].delegate
#define isIOS7 (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
#define PUSH_VIEW [AGPushNoteView sharedPushView]

#define CLOSE_PUSH_SEC 5
#define SHOW_ANIM_DUR 0.5
#define HIDE_ANIM_DUR 0.3
#define BOUNCE_HEIGHT 10.0

@implementation AGPushNote

- (void) setDefaultUI{
    
    self.iconImage = nil;
    self.closeImage = [UIImage imageNamed:@"close_message"];
    self.textColor = [UIColor blackColor];
    self.textFont = [UIFont systemFontOfSize:13.0];
    self.backgroundColor = [UIColor colorWithRed:(184.0 / 255.0) green:(233.0 / 255.0) blue:(134.0 / 255.0) alpha:1.0];
    self.messageHeight = 50.0;
}

@end

@interface AGPushNoteView()

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UIButton *dismissButton;
@property (strong, nonatomic) NSLayoutConstraint *thisViewBottomorUpConst;
@property (strong, nonatomic) NSLayoutConstraint *placeHolderViewBottomConst;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottomConst;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *containerViewUpConst;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iconImageWidthConst;
@property (nonatomic) BOOL isKeyboardVisible;
@property (nonatomic) CGRect keyRect;

@property (strong, nonatomic) NSTimer *closeTimer;
@property (strong, nonatomic) AGPushNote *currentPushNote;
@property (strong, nonatomic) NSMutableArray *pendingPushArr;

@property (strong, nonatomic) void (^messageTapActionBlock)(AGPushNote* pushNote);
@property (strong, nonatomic) void (^closeActionBlock)(void);

@end


@implementation AGPushNoteView

//Singleton instance
static AGPushNoteView *_sharedPushView;

+ (instancetype)sharedPushView{
    
    @synchronized([self class])
    {
        if (!_sharedPushView)
        {
            _sharedPushView = [[[NSBundle mainBundle] loadNibNamed:@"AGPushNoteView" owner:self options:nil] objectAtIndex:0];
            _sharedPushView.layer.zPosition = MAXFLOAT;
            
            [[NSNotificationCenter defaultCenter] addObserver:_sharedPushView
                                                     selector:@selector(keyboardWillShown: )
                                                         name:UIKeyboardWillShowNotification object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:_sharedPushView
                                                     selector:@selector(keyboardWillBeHidden: )
                                                         name:UIKeyboardWillHideNotification object:nil];
        }
        return _sharedPushView;
    }
    // to avoid compiler warning
    return nil;
}

+ (void)setDelegateForPushNote:(id<AGPushNoteViewDelegate>)delegate {
    [PUSH_VIEW setPushNoteDelegate:delegate];
}

//------------------------------------------------------------------------------------------

// Called when the UIKeyboardDidShowNotification is sent.
- (void) keyboardWillShown:(NSNotification*)aNotification{
    
    NSDictionary* info = [aNotification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyRect = keyboardRect;
    
    double duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration delay:.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
     {
         self.isKeyboardVisible = YES;
         self.placeHolderViewBottomConst.constant = -keyboardRect.size.height;
         [self layoutIfNeeded];
     } completion:^(BOOL finished) {
     }];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void) keyboardWillBeHidden:(NSNotification*)aNotification{
    
    NSDictionary* info = [aNotification userInfo];
    double duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
     {
         self.isKeyboardVisible = NO;
         self.placeHolderViewBottomConst.constant = 0;
         [self layoutIfNeeded];
     } completion:nil];
}

//------------------------------------------------------------------------------------------

#pragma mark - Lifecycle (of sort)

- (void) setVisibleFrame{
    
    self.hidden = NO;
    self.thisViewBottomorUpConst.constant = (PUSH_VIEW.currentPushNote.showAtBottom)  ? BOUNCE_HEIGHT : -BOUNCE_HEIGHT;
}

- (void) setHiddenFrame{
    
    self.thisViewBottomorUpConst.constant = ((PUSH_VIEW.currentPushNote.showAtBottom) ? -1 : 1) * (-BOUNCE_HEIGHT - PUSH_VIEW.frame.size.height);
//    self.thisViewBottomorUpConst.constant = - self.frame.size.height - BOUNCE_HEIGHT;
}

+(void)showNotification:(AGPushNote *)pushNote
{
    [AGPushNoteView showNotification:pushNote completion:^{
        
    }];
}

+ (void)showNotification:(AGPushNote *)pushNote completion:(void (^)(void))completion{
    
    PUSH_VIEW.currentPushNote = pushNote;
    [PUSH_VIEW removeFromSuperview];
    
    if (pushNote)
    {
        [[NSNotificationCenter defaultCenter] addObserver:PUSH_VIEW
                                                 selector:@selector(keyboardWillShown: )
                                                     name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:PUSH_VIEW
                                                 selector:@selector(keyboardWillBeHidden: )
                                                     name:UIKeyboardWillHideNotification object:nil];
        
        if (pushNote.queue)
        {
            [PUSH_VIEW.pendingPushArr addObject:pushNote];
            
            if (PUSH_VIEW.pendingPushArr.count > 1)
            {
                return;
            }
        }
        
        if (pushNote.showAtBottom)
        {
            PUSH_VIEW.containerViewUpConst.constant = 0;
            PUSH_VIEW.containerViewBottomConst.constant = 10;
        }
        else
        {
            PUSH_VIEW.containerViewUpConst.constant = 10;
            PUSH_VIEW.containerViewBottomConst.constant = 0;
        }
        
        PUSH_VIEW.messageLabel.text = pushNote.message;
        PUSH_VIEW.messageLabel.textColor = (pushNote.textColor) ? pushNote.textColor : PUSH_VIEW.messageLabel.textColor;
        PUSH_VIEW.messageLabel.font = (pushNote.textFont) ? pushNote.textFont : PUSH_VIEW.messageLabel.font;
        
        if (pushNote.iconImage)
        {
            PUSH_VIEW.iconImageView.image = pushNote.iconImage;
            PUSH_VIEW.iconImageWidthConst.constant = 40;
        }
        else
        {
            PUSH_VIEW.iconImageWidthConst.constant = 10;
        }
        
        PUSH_VIEW.backgroundColor = (pushNote.backgroundColor) ? pushNote.backgroundColor : PUSH_VIEW.backgroundColor;
        
        if (pushNote.closeImage)
        {
            [PUSH_VIEW.dismissButton setImage:pushNote.closeImage forState:UIControlStateNormal];
            [PUSH_VIEW.dismissButton setImage:pushNote.closeImage forState:UIControlStateHighlighted];
            [PUSH_VIEW.dismissButton setTitle:@"" forState:UIControlStateNormal];
        }
        
        if (!pushNote.showAtBottom)
        {
            APP.window.windowLevel = UIWindowLevelStatusBar;
        }
        
        if (!PUSH_VIEW.superview)
        {
            PUSH_VIEW.translatesAutoresizingMaskIntoConstraints = NO;
            [APP.window addSubview:PUSH_VIEW];
            
            [PUSH_VIEW addConstraint:[NSLayoutConstraint constraintWithItem:PUSH_VIEW
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:PUSH_VIEW.frame.size.height]];
            
            PUSH_VIEW.thisViewBottomorUpConst = [NSLayoutConstraint constraintWithItem:PUSH_VIEW
                                                                             attribute:(pushNote.showAtBottom) ? NSLayoutAttributeBottom : NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:APP.window
                                                                             attribute:(pushNote.showAtBottom) ? NSLayoutAttributeBottom : NSLayoutAttributeTop
                                                                            multiplier:1.0
                                                                              constant:0];
            PUSH_VIEW.thisViewBottomorUpConst.constant = ((pushNote.showAtBottom) ? -1 : 1) * (-BOUNCE_HEIGHT - PUSH_VIEW.frame.size.height);
            [APP.window addConstraint:PUSH_VIEW.thisViewBottomorUpConst];
            
            [APP.window addConstraint:[NSLayoutConstraint constraintWithItem:PUSH_VIEW
                                                                   attribute:NSLayoutAttributeLeading
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:APP.window
                                                                   attribute:NSLayoutAttributeLeading
                                                                  multiplier:1.0
                                                                    constant:0]];
            
            [APP.window addConstraint:[NSLayoutConstraint constraintWithItem:PUSH_VIEW
                                                                   attribute:NSLayoutAttributeTrailing
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:APP.window
                                                                   attribute:NSLayoutAttributeTrailing
                                                                  multiplier:1.0
                                                                    constant:0]];
        }
        
//        if (CGRectEqualToRect(PUSH_VIEW.keyRect, CGRectZero))
//        {
//            PUSH_VIEW.placeHolderViewBottomConst.constant = -PUSH_VIEW.keyRect.size.height;
//        }
        
        [PUSH_VIEW layoutIfNeeded];
        [APP.window layoutIfNeeded];
        
        [UIView animateWithDuration:SHOW_ANIM_DUR delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [PUSH_VIEW setVisibleFrame];
            [PUSH_VIEW layoutIfNeeded];
            [APP.window layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            completion();
            if ([PUSH_VIEW.pushNoteDelegate respondsToSelector:@selector(pushNoteDidAppear)]) {
                [PUSH_VIEW.pushNoteDelegate pushNoteDidAppear];
            }
        }];
        
        //Start timer (Currently not used to make sure user see & read the push...)
        //        PUSH_VIEW.closeTimer = [NSTimer scheduledTimerWithTimeInterval:CLOSE_PUSH_SEC target:[IAAPushNoteView class] selector:@selector(close) userInfo:nil repeats:NO];
    }
}

+ (void)closeWithCompletion:(void (^)(void))completion {
    
    if ([PUSH_VIEW.pushNoteDelegate respondsToSelector:@selector(pushNoteWillDisappear)]) {
        [PUSH_VIEW.pushNoteDelegate pushNoteWillDisappear];
    }
    
    [PUSH_VIEW.closeTimer invalidate];
    [UIView animateWithDuration:HIDE_ANIM_DUR delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [PUSH_VIEW setHiddenFrame];
    } completion:^(BOOL finished) {
        
        PUSH_VIEW.hidden = YES;
        APP.window.windowLevel = UIWindowLevelNormal;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.7 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            [PUSH_VIEW handlePendingPushJumpWitCompletion:completion];
        });
    }];
}

+ (void)close {
    [AGPushNoteView closeWithCompletion:^{
        //Nothing.
    }];
}

//------------------------------------------------------------------

#pragma mark - Pending push managment

- (void)handlePendingPushJumpWitCompletion:(void (^)(void))completion {
    
    id lastObj = [self.pendingPushArr firstObject]; //Get myself
    
    if (lastObj)
    {
        [self.pendingPushArr removeObject:lastObj]; //Remove me from arr
        AGPushNote* pendingPushNote = [self.pendingPushArr firstObject];
        
        if (pendingPushNote)//If got something - remove from arr, - than show it.
        {
            [self.pendingPushArr removeObject:pendingPushNote];
            [AGPushNoteView showNotification:pendingPushNote completion:completion];
        }
        else
        {
            APP.window.windowLevel = UIWindowLevelNormal;
            completion();
        }
    }
    else
    {
        completion();
    }
}

- (NSMutableArray *)pendingPushArr {
    if (!_pendingPushArr) {
        _pendingPushArr = [[NSMutableArray alloc] init];
    }
    return _pendingPushArr;
}

//------------------------------------------------------------------

#pragma mark - Actions

+ (void) setMessageAction:(void (^)(AGPushNote* pushNote))action {
    PUSH_VIEW.messageTapActionBlock = action;
}

+ (void) setCloseAction:(void (^)(void))completion {
    PUSH_VIEW.closeActionBlock = completion;
}

- (IBAction) messageTapAction {
    
    if (self.messageTapActionBlock)
    {
        self.messageTapActionBlock(self.currentPushNote);
        [AGPushNoteView close];
    }
}

- (IBAction) closeActionItem:(id)sender {
    
    self.closeActionBlock();
    [AGPushNoteView close];
}


@end
