//
//  RunLoopTestViewController2.m
//  Test
//
//  Created by panjinyong on 2021/9/6.
//

#import "RunLoopTestViewController2.h"

@interface RunLoopTestThread : NSThread
@end

@implementation RunLoopTestThread
- (void)dealloc {
    NSLog(@"%s", __func__);
}
@end

@interface RunLoopTestViewController2 ()
@property (strong, nonatomic) RunLoopTestThread *thread;
@property (assign, nonatomic) BOOL isStopped;
@end

@implementation RunLoopTestViewController2

- (void)dealloc {
    NSLog(@"%s", __func__);
    
    [self stopRunLoop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isStopped = NO;
    __weak typeof(self) weakSelf = self;
    self.thread = [[RunLoopTestThread alloc] initWithBlock:^{
        NSLog(@"start-----");
        NSLog(@"%@", NSRunLoop.currentRunLoop);
        
        // 往RunLoop里面添加Source\Timer\Observer
//        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];

        // 但是添加Observer dealloc会有问题
//        [weakSelf addObserver];

//        [weakSelf addTimer];

        NSLog(@"%@", NSRunLoop.currentRunLoop);

//        [weakSelf addPort];
        
//        [weakSelf addSource];
        
//        NSLog(@"%@", NSRunLoop.currentRunLoop);

        // 启动, returnAfterSourceHandled: 处理完source是否退出当前loop
//        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
        
        int a = 1;
        
        if (a == 0) {
            // 如果没有一个输入源或者timer附加于runloop上，runloop就会立刻退出，不管哪一种方式启动runloop
        }else if (a == 1) {
            [weakSelf addPort];
        }else if (a == 2) {
            [weakSelf addSource];
        }else if (a == 3) {
            [weakSelf addTimer];
        }else if (a == 4) {
            // 添加监听并不会影响runloop退出
            [weakSelf addObserver];
        }
        
        // 如果没有一个输入源或者timer附加于runloop上，runloop就会立刻退出，不管哪一种方式启动runloop
        int b = 2;
        if (b == 0) {
            // runloop一直不会退出，除非通过移除所有source和timer，但这种方式不建议，因为可能会存在一些系统的输入源
            [[NSRunLoop currentRunLoop] run];
        }else if (b == 1) {
            while (weakSelf && !weakSelf.isStopped) {
                //如果没有输入源或计时器附加到运行循环，这个方法会立即退出并返回no;否则，它将在处理第一个输入源或到达limitDate之后返回
               BOOL result = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                NSLog(@"result = %d", result);
            }
        }else if (b == 2) {
            //CFRunLoopRunInMode: C语言方法第3个参数：returnAfterSourceHandled 可控制运行完一次之后是否退出runloop
            BOOL returnAfterSourceHandled = NO;
            if (returnAfterSourceHandled) {
                while (weakSelf && !weakSelf.isStopped) {
                    // runloop运行完一次之后，如果input source、timer被处理完，则runloop会退出
                    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, returnAfterSourceHandled);
                }
            }else {
                // 建议直接用这种方法，简单
                CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, returnAfterSourceHandled);
            }
        }
        
        NSLog(@"end-----");
    }];
    [self.thread start];
}

/**
 1、BOOL result = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]
 如果runloop有source，则
 */

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);

    [self performSelector:@selector(doTask) onThread:self.thread withObject:nil waitUntilDone:NO];
    
}

- (void)doTask {
    NSLog(@"%@", NSRunLoop.currentRunLoop);
    NSLog(@"%s", __func__);
}

- (void)stopRunLoop {
    if (!self.thread) {
        return;
    }
    // 在子线程调用stop（waitUntilDone设置为YES，代表子线程的代码执行完毕后，这个方法才会往下走）
    [self performSelector:@selector(__stopRunLoop) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)__stopRunLoop {
    self.isStopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.thread = nil;
}

- (void)addPort {
    [NSRunLoop.currentRunLoop addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
}

- (void)addSource {
    // 创建上下文（要初始化一下结构体）
    CFRunLoopSourceContext context = {0};
    // 创建source
    CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    // 往runloop中添加source
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    // 销毁source
    CFRelease(source);
}

- (void)addTimer {
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"%s", __func__);
    }];
    [NSRunLoop.currentRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
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
    
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    CFRelease(observer);
}




@end
