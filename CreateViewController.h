//
//  CreateViewController.h
//  Muise
//
//  Created by Phillip Ou on 10/3/14.
//  Copyright (c) 2014 Phillip Ou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateViewController : UIViewController<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

@end
