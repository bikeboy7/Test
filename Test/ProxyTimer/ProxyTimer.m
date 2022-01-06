//
//  ProxyTimer.m
//  Test
//
//  Created by panjinyong on 2021/8/31.
//

#import "ProxyTimer.h"
#import "TimerProxy.h"

@interface ProxyTimer()
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) int count;
@end

@implementation ProxyTimer

- (void)dealloc
{
    [self.timer invalidate];
    NSLog(@"ProxyTimer  dealloc");
}

- (void)test {

    TimerProxy *proxy = [TimerProxy initWithTaret:self];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:proxy selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@", self);
    });
}

- (void)timerAction {
    self.count += 1;
    NSLog(@"%d", self.count);
}

@end
