//
//  JCPathViewModel.m
//  JourneyCapture
//
//  Created by Chris Sloey on 08/05/2014.
//  Copyright (c) 2014 FCD. All rights reserved.
//

#import "JCPathViewModel.h"

@implementation JCPathViewModel

- (id)init
{
    self = [super init];
    if (self) {
        _points = [[NSMutableArray alloc] init];
        _hasChildren = NO;
    }
    return self;
}

-(JCPathListViewModel *)newChild
{
    return nil;
}

- (NSNumber *)averageRating
{
    return @((self.environmentRating + self.difficultyRating + self.safetyRating) / 3.0f);
}

- (RACSignal *)readableInstanceCount {
    return nil;
}

- (NSString *)readableTime
{
    int seconds = [_time intValue];
    int hours = seconds / 3600;
    int minutes = (seconds - (hours * 3600)) / 60;
    NSString *minuteDesc = minutes == 1 ? @"minute" : @"minutes";
    NSString *hourDesc = hours == 1 ? @"hour" : @"hours";
    if (hours == 0) {
        return [NSString stringWithFormat:@"%d %@", minutes, minuteDesc];
    } else if (minutes == 0) {
        return [NSString stringWithFormat:@"%d %@", hours, hourDesc];
    } else {
        return [NSString stringWithFormat:@"%d %@ and %2d %@", hours, hourDesc,
                minutes, minuteDesc];
    }
}


@end
