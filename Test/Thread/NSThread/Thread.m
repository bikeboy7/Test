//
//  Thread.m
//  Test
//
//  Created by panjinyong on 2022/1/10.
//

#import "Thread.h"

@implementation Thread
+ (void)test {
    [self test1];
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
}

+ (void)task {
    NSLog(@"do task: %@", [NSThread currentThread]);
}


@end
