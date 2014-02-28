//
//  JCUserView.m
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCUserView.h"
#import "JCUserViewModel.h"
#import <QuartzCore/QuartzCore.h>

@implementation JCUserView
@synthesize viewModel;
@synthesize firstNameLabel, lastNameLabel,
        favouriteRouteView, favouriteRouteLabel, routesThisMonthView, routesThisMonthLabel,
        timeThisMonthView, timeThisMonthLabel, distanceThisMonthView, distanceThisMonthLabel;

- (id)initWithFrame:(CGRect)frame viewModel:(JCUserViewModel *)userViewModel
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.viewModel = userViewModel;
    [self setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.85]];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.0f;
    int padding = 12;

    // Name
    UIFont *nameFont = [UIFont fontWithName:@"Helvetica Neue"
                                       size:20.0];
    self.firstNameLabel = [[UILabel alloc] init];
    [self.firstNameLabel setFont:nameFont];
    [self.firstNameLabel setText:self.viewModel.firstName];
    [self addSubview:self.firstNameLabel];

    self.lastNameLabel = [[UILabel alloc] init];
    [self.lastNameLabel setFont:nameFont];
    [self.lastNameLabel setText:self.viewModel.lastName];
    [self addSubview:self.lastNameLabel];

    [self.firstNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(padding);
        make.left.equalTo(self.mas_left).with.offset(padding);
    }];

    [self.lastNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstNameLabel.mas_top);
        make.left.equalTo(self.firstNameLabel.mas_right).with.offset(5);
    }];

    // Profile
    UIImage *profileImage = [UIImage imageNamed:@"profile-pic"];
    self.profileImageView = [[UIImageView alloc] initWithImage:profileImage];
    [self addSubview:self.profileImageView];

    [self.profileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstNameLabel.mas_bottom).with.offset(padding);
        make.left.equalTo(self.mas_left).with.offset(padding);
        make.height.equalTo(@(50));
        make.width.equalTo(@(50));
    }];

    // Settings
    self.settingsButton = [[UIButton alloc] init];
    UIImage *settingsImage = [UIImage imageNamed:@"gear-button"];
    [self.settingsButton setBackgroundImage:settingsImage forState:UIControlStateNormal];
    [self.settingsButton setTitleColor:self.tintColor forState:UIControlStateNormal];
    self.settingsButton.layer.masksToBounds = YES;
    self.settingsButton.layer.cornerRadius = 8.0f;
    [self addSubview:self.settingsButton];

    [self.settingsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileImageView.mas_bottom).with.offset(padding);
        make.left.equalTo(self.mas_left).with.offset(padding);
        make.height.equalTo(@(50));
        make.width.equalTo(@(50));
    }];

    // Stats images
    UIImage *favouriteImage = [UIImage imageNamed:@"christmas_star-50"];
    self.favouriteRouteView = [[UIImageView alloc] initWithImage:favouriteImage];
    [self addSubview:self.favouriteRouteView];

    UIImage *routesImage = [UIImage imageNamed:@"calendar-50"];
    self.routesThisMonthView = [[UIImageView alloc] initWithImage:routesImage];
    [self addSubview:self.routesThisMonthView];

    UIImage *timeImage = [UIImage imageNamed:@"clock-50"];
    self.timeThisMonthView = [[UIImageView alloc] initWithImage:timeImage];
    [self addSubview:self.timeThisMonthView];

    UIImage *metersImage = [UIImage imageNamed:@"length-50"];
    self.distanceThisMonthView = [[UIImageView alloc] initWithImage:metersImage];
    [self addSubview:self.distanceThisMonthView];

    NSNumber *imageSize = @(18);
    [self.favouriteRouteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstNameLabel.mas_bottom).with.offset(padding);
        make.left.equalTo(self.profileImageView.mas_right).with.offset(padding);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];

    [self.routesThisMonthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.favouriteRouteView.mas_bottom).with.offset(padding);
        make.left.equalTo(self.favouriteRouteView.mas_left);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];

    [self.timeThisMonthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.routesThisMonthView.mas_bottom).with.offset(padding);
        make.left.equalTo(self.favouriteRouteView.mas_left);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];

    [self.distanceThisMonthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeThisMonthView.mas_bottom).with.offset(padding);
        make.left.equalTo(self.favouriteRouteView.mas_left);
        make.width.equalTo(imageSize);
        make.height.equalTo(imageSize);
    }];

    // Stats text
    UIFont *statsFont = [UIFont fontWithName:@"Helvetica Neue"
                                        size:12.0];

    self.favouriteRouteLabel = [[UILabel alloc] init];
    [self.favouriteRouteLabel setFont:statsFont];
    [self.favouriteRouteLabel setText:self.viewModel.favouriteRouteName];
    [self addSubview:self.favouriteRouteLabel];

    self.routesThisMonthLabel = [[UILabel alloc] init];
    [self.routesThisMonthLabel setFont:statsFont];
    NSString *routesThisMonth = [NSString stringWithFormat:@"%@ routes this month", self.viewModel.routesThisMonth];
    [self.routesThisMonthLabel setText:routesThisMonth];
    [self addSubview:self.routesThisMonthLabel];

    self.timeThisMonthLabel = [[UILabel alloc] init];
    [self.timeThisMonthLabel setFont:statsFont];
    int seconds = [self.viewModel.secondsThisMonth intValue];
    int hours = seconds / 3600;
    int minutes = (seconds - (hours * 3600)) / 60;
    NSString *secondsThisMonth = [NSString stringWithFormat:@"%d:%2d hours this month", hours, minutes];
    [self.timeThisMonthLabel setText:secondsThisMonth];
    [self addSubview:self.timeThisMonthLabel];

    self.distanceThisMonthLabel = [[UILabel alloc] init];
    [self.distanceThisMonthLabel setFont:statsFont];
    NSString *distanceThisMonth = [NSString stringWithFormat:@"%@km travelled this month",
                                   @(self.viewModel.metersThisMonth.intValue / 1000)];
    [self.distanceThisMonthLabel setText:distanceThisMonth];
    [self addSubview:self.distanceThisMonthLabel];

    // Positioning
    [self.favouriteRouteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.favouriteRouteView.mas_top);
        make.left.equalTo(self.favouriteRouteView.mas_right).with.offset(padding);
    }];

    [self.routesThisMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.routesThisMonthView.mas_top);
        make.left.equalTo(self.favouriteRouteLabel.mas_left);
    }];

    [self.timeThisMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeThisMonthView.mas_top);
        make.left.equalTo(self.favouriteRouteLabel.mas_left);
    }];

    [self.distanceThisMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceThisMonthView.mas_top);
        make.left.equalTo(self.favouriteRouteLabel.mas_left);
    }];
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
