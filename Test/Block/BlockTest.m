//
//  BlockTest.m
//  Test
//
//  Created by panjinyong on 2021/8/30.
//

#import "BlockTest.h"
#import "Dog.h"

@interface BlockTest()
@property (strong, nonatomic) void(^block)(void);
@end

@implementation BlockTest

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self test7];
    }
    return self;
}

- (void)test7 {
    int a = 1;
    __weak void(^weakBlock)(void) = ^{
        NSLog(@"a = %d", a);
    };
    weakBlock(); // a = 1
    NSLog(@"weakBlock = %@", weakBlock); // __NSStackBlock__
    
    NSLog(@"%@", ^{
        NSLog(@"a = %d", a);
    }); // __NSMallocBlock__
        

    
    void(^strongBlock)(void) = ^{
        NSLog(@"a = %d", a);
    };
    strongBlock();
    NSLog(@"strongBlock = %@", strongBlock); // __NSMallocBlock__
    
    [self test8Block:^{
        NSLog(@"a = %d", a);
    }]; // __NSMallocBlock__
        
    // weakBlock: __NSStackBlock__
    [self test8Block:weakBlock];  // __NSMallocBlock__
}

- (void)test8Block: (void(^)(void))block {
    NSLog(@"test8Block = %@", block);
}


- (void)test6 {
    __block int a = 1;
    NSLog(@"%p", &a);

    
    void(^block)(void) = ^{
//        NSLog(@"dog2 = %@", dog2);
//        NSLog(@"dog = %@", dog);
        a = 2;
        NSLog(@"a = %d", a);
        NSLog(@"%p", &a);
    };
    NSLog(@"block = %@", block);
    NSLog(@"self.block = %@", self.block);

    self.block = block;
    NSLog(@"self.block = %@", self.block);
    NSLog(@"%p", &a);
    self.block();

    self.block = nil;
    NSLog(@"block = %@", block);
    NSLog(@"self.block = %@", self.block);
    NSLog(@"%p", &a);

    block();
    
    
    
}

- (void)test5 {
    int a = 1;
    self.block = ^{
        NSLog(@"a = %d", a);
    };
//    NSLog(@"block = %@", block);
//    NSLog(@"self.block = %@", self.block);
//
//    self.block = block;
//    NSLog(@"block = %@", block);
    NSLog(@"self.block = %@", self.block);
}


- (void)runBlock {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"self.block = %@", self.block);
        self.block();
    });
}

- (void)test4 {
    
    void(^block)(void) = ^{
        NSLog(@"1234");
    };
    NSLog(@"block = %@", block);
    NSLog(@"self.block = %@", self.block);

    self.block = block;
    NSLog(@"block = %@", block);
    NSLog(@"self.block = %@", self.block);

    self.block();
}


- (void)test2 {
    int a = 1;
    
    Dog *dog = [[Dog alloc] init];
    dog.age = 2;
    NSLog(@"dog = %@", dog);

    __block Dog *dog2 = dog;
    NSLog(@"dog2 = %@", dog2);
    
    void(^block)(void) = ^{
//        NSLog(@"dog2 = %@", dog2);
//        NSLog(@"dog = %@", dog);
        
        NSLog(@"a = %d", a);
        
    };
    NSLog(@"block = %@", block);
    NSLog(@"self.block = %@", self.block);

    self.block = block;
    NSLog(@"self.block = %@", self.block);
    
    self.block();

    NSLog(@"dog = %@", dog);
    
    
}

- (void)test3 {
    self.block();
}

- (void)test {

    __block int a = 1;
    void(^block)(void) = ^{
//        a = 2;
//        NSLog(@"%d", a);
    };
    
    Dog *dog = [[Dog alloc] init];
    dog.age = 1;

    void(^block2)(void) = ^{
        dog.age = 9;
        NSLog(@"dog.age = %d", dog.age);
//        NSLog(@"dog.retainCount = %lu", (unsigned long)dog.retainCount);


    };
    NSLog(@"%@", block);
    NSLog(@"%@", block2);

    printf("dog.retainCount = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(dog)));

    block2();

    self.block = block2;
    printf("dog.retainCount = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(dog)));

    self.block = nil;
    printf("dog.retainCount = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(dog)));

    NSLog(@"%@", block);
    NSLog(@"%@", self.block);
    
    block2();
    NSLog(@"%d", a);
}




@end

