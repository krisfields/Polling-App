//
//  CreateQuestionViewController.h
//  PollMaster3k
//
//  Created by Kris Fields on 8/17/12.
//  Copyright (c) 2012 Kris Fields. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateQuestionViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
- (IBAction)submitQuestion:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *answer1TextField;
@property (weak, nonatomic) IBOutlet UITextField *answer2TextField;
@property (weak, nonatomic) IBOutlet UITextField *answer3TextField;
@property (weak, nonatomic) IBOutlet UITextField *answer4TextField;
@property (weak, nonatomic) IBOutlet UITextField *answer5TextField;

@end
