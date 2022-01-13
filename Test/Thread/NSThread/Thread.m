//
//  Thread.m
//  Test
//
//  Created by panjinyong on 2022/1/10.
//

#import "Thread.h"

@implementation Thread
+ (void)test {
    [self test3];
}


+ (void)test1 {
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"%@", [NSThread currentThread]);
        
        // 此时取消无效,只是添加个取消的标记
        [[NSThread currentThread] cancel];
     
        NSLog(@"此时取消无效,只是添加个取消的标记");
        
        // 退出所有子线程
        [NSThread exit];
        
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"completion");
    }];
    thread.name = @"ABC";
   
    [thread start];
    
    NSLog(@"%llu", NSEC_PER_SEC);
    
    NSLog(@"thread start");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT), ^{
        NSLog(@"thread cancel");
        [thread cancel];
    });

    [thread cancel];

}

+ (void)test2 {
    
    [self performSelectorInBackground:@selector(task) withObject:nil];
    
    [self performSelectorOnMainThread:@selector(task) withObject:nil waitUntilDone:YES];
    
    [self performSelector:@selector(task) withObject:nil afterDelay:3];
    
    
}


/// 延时执行
+ (void)test3 {
    
    NSLog(@"test3 start");
    
    [self performSelector:@selector(task) withObject:nil afterDelay:3];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT), ^{
        NSLog(@"dispatch_afterk: %@", [NSThread currentThread]);
    });
    
    [[[NSThread alloc] initWithBlock:^{
        [self performSelector:@selector(task) withObject:nil afterDelay:5];
        // 如果是带afrerDelay的延时函数，会在内部创建一个NSTimer,然后添加到当前线程的runloop中，也就是如果当前线程没有开启runloop，该方法不会被执行，在子线程中需要手动启动runloop
        [[NSRunLoop currentRunLoop] run];
    }] start] ;
    
}

+ (void)task {
    NSLog(@"do task: %@", [NSThread currentThread]);
}


@end
