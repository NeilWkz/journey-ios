//
//  JCRoutesViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 27/02/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRoutesViewController.h"
#import "JCRouteCell.h"
#import "JCRoutesListViewModel.h"
#import "JCRouteViewController.h"

@interface JCRoutesViewController ()

@end

@implementation JCRoutesViewController

- (id)initWithViewModel:(JCRoutesListViewModel *)routesViewModel
{
    self = [super init];
    if (self) {
        self.viewModel = routesViewModel;
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UITableView *routesTableView = [[UITableView alloc] init];
    [self.view addSubview:routesTableView];
    [routesTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [routesTableView setDelegate:self];
    [routesTableView setDataSource:self];
    routesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:self.viewModel.title];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.viewModel routes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"routeCell";

    JCRouteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[JCRouteCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier
                                        viewModel:self.viewModel.routes[indexPath.row]];
    }
    [cell setViewModel:self.viewModel.routes[indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JCRouteViewModel *routeModel = self.viewModel.routes[indexPath.row];
    JCRouteViewController *routeController = [[JCRouteViewController alloc] initWithViewModel:routeModel];
    [self.navigationController pushViewController:routeController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end