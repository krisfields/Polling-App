//
//  PMAppDelegate.m
//  PollMaster3k
//
//  Created by Kris Fields on 8/17/12.
//  Copyright (c) 2012 Kris Fields. All rights reserved.
//

#import "PMAppDelegate.h"

#import "CreateQuestionViewController.h"
#import "AllQuestionsViewController.h"
#import "ResultsViewController.h"
#import <Parse/Parse.h>

@implementation PMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"pf6yVfohe92QaVDNhy969Mel72tGKO7OzXT1QGH7"
                  clientKey:@"Hvk7kiw6OVTJ1ZnuGXBQKHiJL0xXqjV67Mkxx0CO"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.viewController = [[CreateQuestionViewController alloc] initWithNibName:@"CreateQuestionViewController" bundle:nil];
//    self.window.rootViewController = self.viewController;
    
    
    CreateQuestionViewController *createQuestionViewController = [[CreateQuestionViewController alloc] initWithNibName:@"CreateQuestionViewController" bundle:nil];
    AllQuestionsViewController *allQuestionsViewController = [[AllQuestionsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    AllQuestionsViewController *allQuestionsViewController2 = [[AllQuestionsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    UINavigationController *navigationController1 = [[UINavigationController alloc]initWithRootViewController:allQuestionsViewController];
    navigationController1.title = @"Vote!";
    [navigationController1.tabBarItem setImage:[UIImage imageNamed:@"117-todo.png"]];
     UINavigationController *navigationController2 = [[UINavigationController alloc]initWithRootViewController:allQuestionsViewController2];
    navigationController2.title = @"Results";
    [navigationController2.tabBarItem setImage:[UIImage imageNamed:@"122-stats.png"]];
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[createQuestionViewController, navigationController1, navigationController2];
    self.window.rootViewController = self.tabBarController;
        
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
