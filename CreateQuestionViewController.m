//
//  CreateQuestionViewController.m
//  PollMaster3k
//
//  Created by Kris Fields on 8/17/12.
//  Copyright (c) 2012 Kris Fields. All rights reserved.
//

#import "CreateQuestionViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface CreateQuestionViewController () <UITextFieldDelegate, UITableViewDelegate>

@end

@implementation CreateQuestionViewController
@synthesize answer1TextField;
@synthesize answer2TextField;
@synthesize answer3TextField;
@synthesize answer4TextField;
@synthesize answer5TextField;
@synthesize questionTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Get current tab bar item and set title and image
        UITabBarItem *tbi = [self tabBarItem];
        tbi.title = @"Create Question";
        UIImage *i = [UIImage imageNamed:@"187-pencil.png"];
        [tbi setImage:i];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.questionTextView.layer.cornerRadius = 5;
    self.questionTextView.clipsToBounds = YES;
    [self.questionTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.questionTextView.layer setBorderWidth:2.0];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    // For selecting cell.
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    // Do any additional setup after loading the view from its nib.
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}

- (void)viewDidUnload
{
    [self setQuestionTextView:nil];
    [self setAnswer1TextField:nil];
    [self setAnswer2TextField:nil];
    [self setAnswer3TextField:nil];
    [self setAnswer4TextField:nil];
    [self setAnswer5TextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)submitQuestion:(id)sender {
    PFObject *aQuestion = [PFObject objectWithClassName:@"PollQuestions"];
    [aQuestion setObject:questionTextView.text forKey:@"question"];
    [aQuestion save];
    questionTextView.text = @"";
    for (int i=1; i<=5; i++) {
        UITextField *textField =(UITextField*) [self.view viewWithTag:i];
        if(![textField.text isEqualToString:@""]){
            PFObject *anAnswer = [PFObject objectWithClassName:@"PollResults"];
            [anAnswer setObject:textField.text forKey:@"answer"];
            [anAnswer setObject:aQuestion.objectId forKey:@"question_id"];
            [anAnswer setObject:@"0" forKey:@"tally"];
            [anAnswer save];
            textField.text = @"";
        }
    }
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Submitted Question"
                          message: @"Thank you."
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//Next 3 methods used to animate and move the frame using CGRectOffset when text field is being edited.
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}


- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    int animatedDistance;
    int moveUpValue = textField.frame.origin.y+ (textField.frame.size.height*3)+10;
    NSLog(@"%d", moveUpValue);
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        
        animatedDistance = 216-(460-moveUpValue-5);
    }
    else
    {
        animatedDistance = 162-(320-moveUpValue-5);
    }
    
    if(animatedDistance>0)
    {
        const int movementDistance = animatedDistance;
        const float movementDuration = 0.3f;
        int movement = (up ? -movementDistance : movementDistance);
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }   
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 25) ? NO : YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return (newLength > 50) ? NO : YES;
}
@end
