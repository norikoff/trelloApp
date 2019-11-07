//
//  TaskCreatorImpl.h
//  trello
//
//  Created by Юрий Нориков on 07.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCreator.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Task creation view (Pop-Up view) implementation
 */
@interface TaskCreatorImpl : UIView

@property (nonatomic, weak) id<TaskCreator> delegate;

/**
 Shows Pop-Up view
 */
- (void) makeViewVisible;

@end

NS_ASSUME_NONNULL_END
