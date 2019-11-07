//
//  TaskCreatorImpl.m
//  trello
//
//  Created by Юрий Нориков on 07.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

#import "TaskCreatorImpl.h"

@interface TaskCreatorImpl ()

@property (nonatomic, strong) UITextField *titleText;
@property (nonatomic, strong) UITextView *descText;

@end

@implementation TaskCreatorImpl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Create translucent view to highlight the layer
        UIView *backgroundView = [[UIView alloc] initWithFrame:frame];
        backgroundView.alpha = 0.8;
        backgroundView.backgroundColor = UIColor.blackColor;
        
        // Pop-Up window view
        UIView *windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
        windowView.center = self.center;
        windowView.backgroundColor = UIColor.whiteColor;
        
        // Title field setup
        self.titleText = [[UITextField alloc] initWithFrame:CGRectMake(4, 4, windowView.frame.size.width - 8, 35)];
        self.titleText.backgroundColor = UIColor.lightGrayColor;
        self.titleText.placeholder = @"Title";
        
        // Description field setup
        UILabel * descLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 43, windowView.frame.size.width - 8, 20)];
        descLabel.text = @"Description:";
        self.descText = [[UITextView alloc] initWithFrame:CGRectMake(4,
                                                                     63,
                                                                     windowView.frame.size.width - 8,
                                                                     windowView.frame.size.height - 109)];
        descLabel.text = @"Description:";
        [self.descText setFont:self.titleText.font];
        self.descText.backgroundColor = UIColor.lightGrayColor;
        
        // Buttons setup
        UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(4,
                                                                        windowView.frame.size.height - 44,
                                                                        windowView.frame.size.width / 2 - 6,
                                                                        38)];
        [okButton setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        [okButton setTitle:@"OK" forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(okButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(windowView.frame.size.width / 2 + 2,
                                                                            windowView.frame.size.height - 44,
                                                                            windowView.frame.size.width / 2 - 6,
                                                                            38)];
        [cancelButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        // Add subviews to Pop-Up view
        [windowView addSubview:self.titleText];
        [windowView addSubview:descLabel];
        [windowView addSubview:self.descText];
        [windowView addSubview:okButton];
        [windowView addSubview:cancelButton];
        
        // Add subviews to the root view
        [self addSubview:backgroundView];
        [self addSubview:windowView];
    }
    return self;
}

- (void)makeViewVisible
{
    self.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished){
        self.alpha = 1;
    }];
}

/**
 When OK button is tapped, call delegate to create new task cell; close the view
 */
- (void)okButtonTapped
{
    [self.delegate taskDidCreatedWithTitle:self.titleText.text desc:self.descText.text];
    [self hideViewWithAnimation];
}

/**
 Remove the view without any data changes
 */
- (void)cancelButtonTapped
{
    [self hideViewWithAnimation];
    [self.delegate taskCreationDidCanceled];
}

/**
 Hide view with animation and remove from superview at the end
 */
- (void)hideViewWithAnimation
{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

@end
