//
//  JCNavViewController.m
//  JourneyCapture
//
//  Created by Chris Sloey on 12/03/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCNavViewController.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "JCNotificationManager.h"

@interface JCNavViewController ()
@end

@implementation JCNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusNotReachable) {
                // Show not reachable notification
                [[JCNotificationManager manager] displayErrorWithTitle:@"Network Error"
                                                              subtitle:@"There is an issue with either your connection or the server"
                                                                  icon:[UIImage imageNamed:@"connection-issue-icon"]];
            }
        }];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
