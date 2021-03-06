//
//  GCD.m
//  Test
//
//  Created by 车小孩 on 2021/9/7.
//

#import "GCD.h"

@implementation GCD

+ (void)test {
    [self test09];
}


// gcd api dispatch_sync（同步）和dispatch_async（异步）用来控制是否要开启新的线程
/**
 任务的执行方式：
 
 sync （同步）：同步添加任务到指定的队列中，在添加的任务执行结束之前，会一直等待，知道队列里面的任务完成之后再继续执行，即会阻塞线程。只能在当前线程中执行任务（是当前线程，不一定是主线程），不具备开启新线程的能力
 
 async （异步）：线程会立即返回，无需等待就会继续执行下面的任务，不阻塞当前线程。可以在新的线程中执行任务，具备开启新线程的能力（并不一定开启新线程）。如果不是添加到主队列上，异步会在子线程中执行任务
 */

/**
 队列的类型，决定了任务的执行方式（并发、串行）
 1.并发队列
 2.串行队列
 3.主队列（也是一个串行队列）
 
 队列是用来保存和管理任务的
 */

/**
 1、dispatch_sync 都是没有开启新线程，串行执行任务
 2、dispatch_async + 并发队列 开启新线程并发执行
 3、dispatch_async + 一个新的串行队列（与当前不一样的队列） 会开启新线程串行执行任务
 2、dispatch_async + 并发队列 开启新线程并发执行

 */


+ (void)test01 {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 问题：以下代码是在主线程执行的，会不会产生死锁？会！
        NSLog(@"执行任务1");
        // dispatch_sync立马在当前线程同步执行任务，而由于主队列还有任务test01没有执行完，新增进去的任务2排在任务3（任务test01）后面，主队列又是串行队列，所以会出现死锁的情况（同一个串行队列的性质决定任务必须先进先出，dispatch_sync同步的性质决定要立刻执行刚添加的任务，出现冲突，程序崩溃）
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"执行任务2");
        });
        NSLog(@"执行任务3");
    });
}

+ (void)test02 {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 问题：以下代码是在主线程执行的，会不会产生死锁？不会！
        NSLog(@"执行任务1");
        // dispatch_async不要求立马在当前线程同步执行任务
        dispatch_async(dispatch_get_main_queue(), ^{
            [self doTask:2];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [self doTask:3];
        });
        [self doTask:4];
    });
    // 1 4 2 3 串行执行，因为只有一个线程
}

+ (void)test03 {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"执行任务1");
        dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
        // dispatch_sync会立马执行任务2（阻塞当前线程，任务2完成之前，不能继续执行任务3、4），由于添加的任务是在另外一个队列，即使是串行的，但由于这个队列只有任务2（任务2前面没有任何任务阻塞）所以不会死锁。
        dispatch_sync(queue, ^{
            [self doTask:2];
            // 由于是同步执行+串行队列，所以不会有新的线程。实际上凡是dispatch_sync都不会有新的线程
            NSLog(@"%@", NSThread.currentThread); // 主线程
        });
        
        dispatch_sync(queue, ^{
            [self doTask:3];
            NSLog(@"%@", NSThread.currentThread); // 主线程
        });
        [self doTask:4];
    });
    // 1 2 3 4 串行执行 因为只有一个线程
}

+ (void)test04 {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"执行任务1");
        dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{
            [self doTask:2];
            NSLog(@"%@", NSThread.currentThread); // 子线程
        });
        dispatch_async(queue, ^{
            [self doTask:3];
            NSLog(@"%@", NSThread.currentThread); // 同一个子线程
        });

        [self doTask:4];
    });
    // 1 (2 3 串行执行，因为是在同个串行队列，同个线程) （【2 3】 4 并发执行，因为不是在同个线程)
}

+ (void)test04_1 {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"执行任务1");
        dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{ // 异步执行，开启新线程
            [self doTask:2];
            NSLog(@"%@", NSThread.currentThread); // 子线程
        });
        dispatch_sync(queue, ^{ // 同步执行，不开启新线程，且排在串行队列中的任务2之后，所以要等任务二执行完之后才会执行任务3
            [self doTask:3];
            NSLog(@"%@", NSThread.currentThread); // 主线程
        });

        [self doTask:4]; // 要等前面的同步（立刻）执行的任务2执行完之后才可以执行
    });
    // 1 2 3 4 串行执行
}

// 异步+并发队列
+ (void)test04_2 {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"执行任务1");
        dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{ // 异步执行，开启新线程
            [self doTask:2];
            NSLog(@"%@", NSThread.currentThread); // 子线程
        });
        dispatch_async(queue, ^{ // 异步执行，开启新线程
            [self doTask:3];
            NSLog(@"%@", NSThread.currentThread); // 子线程
        });

        [self doTask:4];
    });
    // 2 3 4 在不同的线程并发执行
}

// 异步+串行队列
+ (void)test04_3 {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"执行任务1");
        dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);

        dispatch_async(queue, ^{ // 异步执行
            [self doTask:2]; // 会开启新线程
        });
        
        [self doTask:3];
        
        dispatch_sync(queue, ^{ // 同步执行
            // 队列前面有任务2，根据队列先进先出原则，一定会先执行完2才会执行4
            // 因为是同步任务，所以会阻塞线程，不会开启新的线程，只有执行完任务4才能继续任务5
            [self doTask:4];
        });
        [self doTask:5];
    });
    
    // 1 3 2 4 5 (3 2 并发执行，因为2是会在新的线程中执行，不会阻塞3的线程)
    
}

+ (void)test05 {
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();

    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, queue, ^{
        [self doTask:1];
    });
    dispatch_group_async(group, queue, ^{
        [self doTask:2];
    });
    dispatch_group_notify(group, queue, ^{
        [self doTask:3]; // 子线程
    });
    // （1 2 并发执行）完成之后执行3
}

+ (void)test06 {
    dispatch_queue_t queue1 = dispatch_get_global_queue(0, 0);
    dispatch_queue_t queue2 = dispatch_get_global_queue(0, 0);
    dispatch_queue_t queue3 = dispatch_queue_create("queu3", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue4 = dispatch_queue_create("queu4", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue5 = dispatch_queue_create("queu4", DISPATCH_QUEUE_CONCURRENT);

    NSLog(@"%p %p %p %p %p", queue1, queue2, queue3, queue4, queue5);
    // queue1 == queue1,  queue4 != queue5
}

NSString *target;

+ (void)test07 {
    dispatch_queue_t queue = dispatch_queue_create("parallel", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 1000000 ; i++) {
        dispatch_async(queue, ^{
            target = [NSString stringWithFormat:@"ksddkjalkjd%d",i];
            NSLog(@"%i", i);
        });
    }
}


/// dispatch_barrier_async 栅（zha）栏函数
/// dispatch_barrier_sync （同步）
/// 实现高效率的数据库访问和文件访问，避免数据竞争（多读单写）
+ (void)test08 {
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [self doTask:0];
    });
    dispatch_async(queue, ^{
        [self doTask:1];
    });
    
    dispatch_barrier_async(queue, ^{
        [self doTask:2];
    });
    
    dispatch_async(queue, ^{
        [self doTask:3];
    });
    dispatch_async(queue, ^{
        [self doTask:4];
    });
    // （0、1并发）2、（3、4并发）
    // 按照任务添加进去的顺序，先并发执行完dispatch_barrier_async之前的所有任务，然后执行任务2，任务2完之后才执行3、4
}

/// dispatch_group_t  线程组
/// dispatch_group_async
/// dispatch_group_notify
+ (void)test09 {
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    for (int i = 0; i < 5; i ++) {
        dispatch_group_async(group, queue, ^{
            [self doTask:i];
        });
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"所有任务完成，刷新界面");
    });
}




+ (void)doTask:(int)task {
    for (int i = 0; i < 5; i ++) {
        [NSThread sleepForTimeInterval:0.1];
        NSLog(@"任务%d--%d %@", task, i, NSThread.currentThread);
    }
}



@end
