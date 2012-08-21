//
//  ResultsViewController.h
//  PollMaster3k
//
//  Created by Kris Fields on 8/20/12.
//  Copyright (c) 2012 Kris Fields. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) NSString *question_id;
@property (strong, nonatomic) NSString *question;
@end
