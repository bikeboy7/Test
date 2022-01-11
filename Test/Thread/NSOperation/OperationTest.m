//
//  OperationTest.m
//  Test
//
//  Created by panjinyong on 2022/1/11.
//

#import "OperationTest.h"

@implementation OperationTest

/*
 NSOperation：任务， 2个子类：NSBlockOperation、NSInvocationOperation（swift中不可用， 不安全）
 
 NSOperationQueue：队列
 主队列： [NSOperationQueue mainQueue]
 创建新队列：[[NSOperationQueue alloc] init] 会在新的线程并发执行，可用[queue setMaxConcurrentOperationCount:2]设置最大并发数，为1则达到串行队列的效果
 */

+ (void)test {
    [self test4];
}

+ (void)test0 {
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
    }];
    [blockOperation start];
    
    NSInvocationOperation * invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task) object:nil];
    [invocationOperation start];
    
    NSLog(@"end");
}

+ (void)test1 {
    //1.创建NSBlockOperation对象
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
    }];

    //添加多个Block
    // addExecutionBlock 方法必须在 start() 方法之前执行，否则就会报错
    // Operation 中的任务 会并发执行，它会 在主线程和其它的多个线程 执行这些任务
    for (NSInteger i = 0; i < 5; i++) {
        [operation addExecutionBlock:^{
            NSLog(@"第%ld次：%@", i, [NSThread currentThread]);
        }];
    }

    //2.开始任务
    [operation start];

}


/// NSOperationQueue 主队列
+ (void)test2 {
    
    NSOperationQueue* queue = [NSOperationQueue mainQueue];
    
    for (int i = 0; i < 5; i ++) {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"第%d次：%@", i, [NSThread currentThread]);
        }];
        // 加入队列即执行
        [queue addOperation:operation];
//        [queue addOperationWithBlock:^{
//            NSLog(@"第%ld次：%@", i, [NSThread currentThread]);
//        }];
    }
}

/// NSOperationQueue 其它队列
+ (void)test3 {
    // 创建新队列
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    // 设置最大并发数，1则为串行队列了
    [queue setMaxConcurrentOperationCount:2];

    for (int i = 1; i < 5; i++) {
        [queue addOperationWithBlock:^{
            [self doTask:i];
        }];
    }
}

/// NSOperationQueue 其它队列
+ (void)test4 {
    // 创建新队列
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    // 设置最大并发数无法控制 某个operation 内的 addExecutionBlock 线程数，只可以控制以operation为单元的
    [queue setMaxConcurrentOperationCount:1];

    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [self doTask:0];
    }];

    for (int i = 1; i < 5; i++) {

        [operation addExecutionBlock:^{
            [self doTask:i];
        }];
    }
    [queue addOperation:operation];
    
    for (int i = 5; i < 10; i++) {
        [queue addOperationWithBlock:^{
            [self doTask:i];
        }];
    }

}


+ (void)task {
    NSLog(@"do task: %@", [NSThread currentThread]);
}

+ (void)doTask:(int)task {
    for (int i = 0; i < 10; i ++) {
        [NSThread sleepForTimeInterval:0.1];
        NSLog(@"任务%d--%d %@", task, i, NSThread.currentThread);
    }
}

@end
