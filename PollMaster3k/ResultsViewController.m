//
//  ResultsViewController.m
//  PollMaster3k
//
//  Created by Kris Fields on 8/20/12.
//  Copyright (c) 2012 Kris Fields. All rights reserved.
//

#import "ResultsViewController.h"
#import <Parse/Parse.h>
#import <CorePlot-CocoaTouch.h>

@interface ResultsViewController () <CPTPlotDataSource>
@property (strong, nonatomic) NSArray *questionWithAnswers;
@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTTheme *selectedTheme;
-(void)initPlot;
-(void)configureHost;
-(void)configureGraph;
-(void)configureChart;
-(void)configureLegend;
@end

@implementation ResultsViewController
@synthesize questionLabel;

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // The plot is initialized here, since the view bounds have not transformed for landscape until now
    [self initPlot];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.questionLabel.text = self.question;
    self.questionLabel.minimumFontSize = 1;
    self.questionLabel.numberOfLines = 1;
    self.questionLabel.adjustsFontSizeToFitWidth = YES;
    
    PFQuery *query = [PFQuery queryWithClassName:@"PollResults"];
    [query whereKey:@"question_id" equalTo:self.question_id];
    self.questionWithAnswers = [query findObjects];
    
    for (int i = 0; i < [self.questionWithAnswers count]; i++) {
        UILabel *possibleAnswer = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 60.0 + (30.0*i), 280.0, 30.0)];
        possibleAnswer.minimumFontSize = 1;
        possibleAnswer.numberOfLines = 1;
        possibleAnswer.adjustsFontSizeToFitWidth = YES;
//        UITextView *possibleAnswer = [[UITextView alloc]initWithFrame:CGRectMake(20.0, 60.0 + (30.0*i), 280.0, 30.0)];
        possibleAnswer.text = [[self.questionWithAnswers objectAtIndex:i] objectForKey:@"answer"];
        possibleAnswer.text = [possibleAnswer.text stringByAppendingFormat:@": %@",[[self.questionWithAnswers objectAtIndex:i] objectForKey:@"tally"]];
        [self.view addSubview:possibleAnswer];
    }
}

- (void)viewDidUnload
{
    [self setQuestionLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return 0;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    return 0;
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
    return nil;
}

-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    return @"";
}

-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configureChart];
    [self configureLegend];
}

-(void)configureHost {
}

-(void)configureGraph {
}

-(void)configureChart {
}

-(void)configureLegend {
}


@end
