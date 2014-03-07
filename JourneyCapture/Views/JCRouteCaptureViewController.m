//
//  JCRouteCaptureViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 07/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteCaptureViewController.h"
#import "JCCaptureView.h"
#import "JCStatCell.h"
#import "JCRoutePointViewModel.h"

@interface JCRouteCaptureViewController ()

@end

@implementation JCRouteCaptureViewController
@synthesize viewModel, captureView;

- (id)init
{
    self = [super init];
    if (self) {
        self.viewModel = [[JCRouteCaptureViewModel alloc] init];
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    CGRect captureFrame = [[UIScreen mainScreen] applicationFrame];
    self.captureView = [[JCCaptureView alloc] initWithFrame:captureFrame];
    captureView.captureButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"Tapped capture button");
        if ([[self.captureView.captureButton.titleLabel text] isEqualToString:@"Start"]) {
            // Start
            [self.captureView transitionToActive];
            self.navigationItem.hidesBackButton = YES;
            [[[JCLocationManager manager] locationManager] startUpdatingLocation];
            [[JCLocationManager manager] setDelegate:self];
        } else {
            // Stop
            [self.navigationController popViewControllerAnimated:YES];
        }
        return [RACSignal empty];
    }];

    [self.captureView.statsTable setDelegate:self];
    [self.captureView.statsTable setDataSource:self];

    [self.view addSubview:self.captureView];
}

- (void)didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Got new location, adding to the route");
    CLLocation *latestLocation = locations[0];
    JCRoutePointViewModel *point = [[JCRoutePointViewModel alloc] init];
    [point setSpeed:latestLocation.speed];
    [point setLocation:latestLocation];
    [self.viewModel addPoint:point];
    [self.viewModel setCurrentSpeed:latestLocation.speed];
    [self.captureView.statsTable reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationItem setTitle:@"Capture"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.view.frame.size.height - 400) / 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StatsCell";

    JCStatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[JCStatCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.row == 0) {
        [[cell statName] setText:@"Current Speed"];
        [[cell statValue] setText:[NSString stringWithFormat:@"%.02f mph", self.viewModel.currentSpeed]];
    } else if (indexPath.row == 1) {
        [[cell statName] setText:@"Average Speed"];
        [[cell statValue] setText:[NSString stringWithFormat:@"%.02f mph", self.viewModel.averageSpeed]];
    } else if (indexPath.row == 2) {
        [[cell statName] setText:@"Distance"];
        [[cell statValue] setText:[NSString stringWithFormat:@"%.02f km", self.viewModel.totalMetres / 1000.0]];
    }
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end