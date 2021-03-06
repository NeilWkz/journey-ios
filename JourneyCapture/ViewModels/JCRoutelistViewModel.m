//
//  JCRouteListViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 12/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCRouteListViewModel.h"
#import "JCAPIManager.h"
#import "JCRouteViewModel.h"

@implementation JCRouteListViewModel

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return self;
    }
    
    self.title = @"Routes";
    
    return self;
}

#pragma mark - JCJourneyListViewModel

-(RACSignal *)loadItems
{
    NSLog(@"Loading user routes");
    JCAPIManager *manager = [JCAPIManager manager];
    NSDictionary *searchParams = @{
                                   @"per_page": @1000,
                                   @"page_num": @1,
                                   @"start_maidenhead": _startMaidenhead,
                                   @"end_maidenhead": _endMaidenhead
                                   };
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *op = [manager GET:@"/routes.json"
                                       parameters:searchParams
                                          success:^(AFHTTPRequestOperation *operation, NSDictionary *routesDict) {
                                              // Registered, store user token
                                              self.items = [NSMutableArray new];
                                              
                                              NSLog(@"Routes load success (%@ to %@)", _startMaidenhead, _endMaidenhead);
                                              NSLog(@"%@", routesDict);
                                              NSArray *routesResponse = routesDict[@"routes"];
                                              
                                              [self storeItems:routesResponse];
                                              
                                              [subscriber sendCompleted];
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              NSLog(@"User routes load failure");
                                              NSLog(@"%@", error);
                                              [subscriber sendError:error];
                                          }
                                      ];
        
        return [RACDisposable disposableWithBlock:^{
            [op cancel];
        }];
    }];
}

- (void)storeItems:(NSArray *)allItemData
{
    for (NSDictionary *data in allItemData) {
        [self storeItem:data inViewModel:[JCRouteViewModel new]];
    }
}

@end
