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
    return [self.questionWithAnswers count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    if (CPTPieChartFieldSliceWidth == fieldEnum) {
        return [NSNumber numberWithInt:[[[self.questionWithAnswers objectAtIndex:index] objectForKey:@"tally"]intValue]];
    }
    return [NSDecimalNumber zero];
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
    static CPTMutableTextStyle *labelText = nil;
    if (!labelText) {
        labelText= [[CPTMutableTextStyle alloc] init];
        labelText.color = [CPTColor grayColor];
    }
    
    int totalVotes = 0;
    for (PFObject *vote in self.questionWithAnswers) {
        totalVotes += [[vote objectForKey:@"tally"]intValue];
    }
    
    int votes = [[[self.questionWithAnswers objectAtIndex:index]objectForKey:@"tally"]intValue];
    float percent = ((float)votes/(float)totalVotes)*100;
    NSString *labelValue = [NSString stringWithFormat:@"%d Votes\n(%0.2f %%)", votes, percent];
    
    return [[CPTTextLayer alloc] initWithText:labelValue style:labelText];
}

-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    if ([self.questionWithAnswers count] == 0) {
        return @"N/A";
    }
    return [[self.questionWithAnswers objectAtIndex:index] objectForKey:@"answer"];
}

-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configureChart];
    [self configureLegend];
}

-(void)configureHost {
    CGRect parentRect = self.view.bounds;
    self.hostView = [[CPTGraphHostingView alloc] initWithFrame:parentRect];
    self.hostView.allowPinchScaling = NO;
    [self.view addSubview:self.hostView];
}

-(void)configureGraph {
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    self.hostView.hostedGraph = graph;
    graph.paddingLeft = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingRight = 0.0f;
    graph.paddingBottom = 0.0f;
    graph.axisSet = nil;
    
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor grayColor];
    textStyle.fontName = @"Helvetica-Bold";
    textStyle.fontSize = 16.0f;

    NSString *title = self.question;
    graph.title = title;
    graph.titleTextStyle = textStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, -12.0f);

    self.selectedTheme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph applyTheme:self.selectedTheme];
}

-(void)configureChart {

    CPTGraph *graph = self.hostView.hostedGraph;
    // 2 - Create chart
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.dataSource = self;
    pieChart.delegate = self;
    pieChart.pieRadius = (self.hostView.bounds.size.height * 0.4) / 2;
    pieChart.identifier = graph.title;
    pieChart.startAngle = M_PI_4;
    pieChart.sliceDirection = CPTPieDirectionClockwise;
    pieChart.centerAnchor = CGPointMake(.5, .6);
    // 3 - Create gradient
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    // 4 - Add chart to graph    
    [graph addPlot:pieChart];

}

-(void)configureLegend {
    CPTGraph *graph = self.hostView.hostedGraph;
    
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
    theLegend.numberOfColumns = 1;
    theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    theLegend.cornerRadius = 5.0;
    
    graph.legend = theLegend;
    graph.legendAnchor = CPTRectAnchorBottom;
    CGFloat legendPadding = -(self.view.bounds.size.width / 8);
    graph.legendDisplacement = CGPointMake(legendPadding, 0.0);
}


@end
