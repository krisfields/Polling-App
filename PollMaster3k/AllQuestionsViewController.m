//
//  AllQuestionsViewController.m
//  PollMaster3k
//
//  Created by Kris Fields on 8/17/12.
//  Copyright (c) 2012 Kris Fields. All rights reserved.
//

#import "AllQuestionsViewController.h"
#import <Parse/Parse.h>
#import "VoteViewController.h"
#import "ResultsViewController.h"

@interface AllQuestionsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *allQuestions;
@end

@implementation AllQuestionsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
//    if([self.navigationController.title isEqualToString:@"vote"]){
//        self = [super initWithStyle:style];
//        if (self) {
//            // Get current tab bar item and set title and image
//            UITabBarItem *tbi = [self tabBarItem];
//            tbi.title = @"Answer Questions";
//            UIImage *i = [UIImage imageNamed:@"117-todo.png"];
//            [tbi setImage:i];
//        }
//    }
//    else if([self.navigationController.title isEqualToString:@"results"]){
//        self = [super initWithStyle:style];
//        if (self) {
//            // Get current tab bar item and set title and image
//            UITabBarItem *tbi = [self tabBarItem];
//            tbi.title = @"Poll Results";
//            UIImage *i = [UIImage imageNamed:@"17-bar-chart"];
//            [tbi setImage:i];
//        }
//    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    PFQuery *query = [PFQuery queryWithClassName:@"PollQuestions"];
    self.allQuestions = [query findObjects];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.allQuestions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    // Configure the cell...
    cell.textLabel.text = [[self.allQuestions objectAtIndex:[indexPath row]] objectForKey:@"question"];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
//pushing both the question and it's objectId

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.navigationController.title isEqualToString:@"Vote!"]) {
        VoteViewController *voteViewController = [[VoteViewController alloc] initWithNibName:@"VoteViewController" bundle:nil];
        voteViewController.question = cell.textLabel.text;
        voteViewController.question_id = [[self.allQuestions objectAtIndex:[indexPath row]] objectId];
        [self.navigationController pushViewController:voteViewController animated:YES];
    }
    else if ([self.navigationController.title isEqualToString:@"Results"]){
        ResultsViewController *resultsViewController = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:nil];
        resultsViewController.question = cell.textLabel.text;
        resultsViewController.question_id = [[self.allQuestions objectAtIndex:[indexPath row]] objectId];
        [self.navigationController pushViewController:resultsViewController animated:YES];
    }
}

@end
