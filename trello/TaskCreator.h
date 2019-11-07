//
//  TaskCreator.h
//  trello
//
//  Created by Юрий Нориков on 07.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

#import "UIKit/UIKit.h"

/**
 Describes task creation view interaction with VC
 */
@protocol TaskCreator <NSObject>

/**
 Calls to create new task
 
 @param title task title
 @param desc task description
 */
- (void)taskDidCreatedWithTitle: (NSString *)title desc: (NSString *)desc;

/**
 Calls when view is removed without task creation
 */
- (void)taskCreationDidCanceled;

@end
