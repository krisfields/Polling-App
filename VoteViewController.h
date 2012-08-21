//
//  VoteViewController.h
//  PollMaster3k
//
//  Created by Kris Fields on 8/17/12.
//  Copyright (c) 2012 Kris Fields. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *answerView;
@property (nonatomic, strong) NSString *question_id;
@property (nonatomic, strong) NSString *question;
@end
