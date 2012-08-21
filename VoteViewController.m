//
//  VoteViewController.m
//  PollMaster3k
//
//  Created by Kris Fields on 8/17/12.
//  Copyright (c) 2012 Kris Fields. All rights reserved.
//

#import "VoteViewController.h"
#import <Parse/Parse.h>

@interface VoteViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *questionWithAnswers;
@property (nonatomic) BOOL answerWasSubmitted;
@end

@implementation VoteViewController
@synthesize answerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.answerWasSubmitted = NO;
    self.answerView.delegate = self;
    self.answerView.dataSource = self;
    PFQuery *query = [PFQuery queryWithClassName:@"PollResults"];
    [query whereKey:@"question_id" equalTo:self.question_id];
    self.questionWithAnswers = [query findObjects];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setAnswerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.questionWithAnswers count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = [[self.questionWithAnswers objectAtIndex:[indexPath row]]objectForKey:@"answer"];
//    cell.textLabel.text = [NSString stringWithFormat:@"Testing, row %d",[indexPath row]];

    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [UILabel new];
    label.text = self.question;
    label.textAlignment = UITextAlignmentCenter;
    [label setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    return label;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 100;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIButton *submit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
////    [submit setOpaque:YES];
//    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
//    
//    submit.titleLabel.text = @"Submit";
//    return submit;
//}

//- (IBAction)submit:(id)sender
//{
//    PFQuery *query = [PFQuery queryWithClassName:@"PollResults"];
////   po self.allQuestions = [query findObjects];
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.answerWasSubmitted = YES;
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    PFObject *answer = [self.questionWithAnswers objectAtIndex:[indexPath row]];
    int new_tally_int = [[answer objectForKey:@"tally"] intValue] +1;
    
    [answer setObject:[NSString stringWithFormat:@"%d", new_tally_int] forKey:@"tally"];
    
    
    [answer save];    
        
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Vote saved!" message:@"Go ahead... TRY to vote again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.answerWasSubmitted) {
        return indexPath;
    }
    
    return nil;
}
@end
