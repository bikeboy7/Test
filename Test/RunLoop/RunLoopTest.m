//
//  RunLoopTest.m
//  Test
//
//  Created by panjinyong on 2021/9/6.
//

#import "RunLoopTest.h"
#import "MJPermenantThread.h"

@interface RunLoopTest()
@property (strong, nonatomic) MJPermenantThread *thread;
@end

@implementation RunLoopTest

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self addObserverc];
    }
    return self;
}

- (void)addTextViewInView:(UIView*)view {
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(100, 100, 100, 200)];
    textView.text = @"textView\n\ntextView\n\ntextView\n\ntextView\n\ntextView\n\ntextView\n\ntextView\n\ntextView\n\ntextView\n\ntextView\n\ntextView\n\ntextView\n\n";
    [view addSubview:textView];
}

- (void)test {
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    NSLog(@"%@", runLoop);
    NSLog(@"currentMode = %@", runLoop.currentMode);
    [self performSelector:@selector(doSomething) withObject:nil afterDelay:3 inModes:@[UITrackingRunLoopMode]];
    [self performSelector:@selector(doSomething) withObject:nil afterDelay:3 inModes:@[NSDefaultRunLoopMode]];
}

- (void)addObserver {
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"kCFRunLoopEntry");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"kCFRunLoopBeforeTimers");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"kCFRunLoopBeforeSources");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"kCFRunLoopBeforeWaiting");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"kCFRunLoopAfterWaiting");
                break;
            case kCFRunLoopExit:
                NSLog(@"kCFRunLoopExit");
                break;
            case kCFRunLoopAllActivities:
                NSLog(@"kCFRunLoopAllActivities");
                break;
        }
    });
    
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
}

- (void)TimerTest {
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer1: %@", [NSDate date]);
    }];
    
    // NSDefaultRunLoopMode、UITrackingRunLoopMode才是真正存在的模式
    // NSRunLoopCommonModes并不是一个真的模式，它只是一个标记
    // timer能在_commonModes数组中存放的模式下工作
    NSTimer *timer2 = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer2: %@", [NSDate date]);
    }];
//    [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:UITrackingRunLoopMode];

//    [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:NSRunLoopCommonModes];
    
}

- (void)doSomething {
    NSLog(@"%s", __func__);
}

@end
