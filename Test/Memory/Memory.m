//
//  Memory.m
//  Test
//
//  Created by panjinyong on 2022/1/16.
//

#import "Memory.h"

@interface Memory ()
{
    NSString *name1;
}

@property (strong, nonatomic) NSString *name;

// test01
@property (weak, nonatomic) NSObject *weakObject;
@property (assign, nonatomic) NSObject *assignObject;
@property (unsafe_unretained, nonatomic) NSObject *unsafeObject;

@end

/*
 内存中的5大区
 1.堆区（stack）有编译器自动分配释放，存放函数的参数值、局部变量值，是连续的，高地址往低地址扩展
 2.堆区（heap）通过alloc、malloc、calloc等动态分配的空间，离散的，低地址往高地址扩展 需要我们手动控制
 3.全局区（静态区）（static）全局变量和静态变量的存储是放一块的，程序结束后由系统释放
 4.文字常量区 存放常量字符串 程序结束后由系统释放
 5.代码区 存放函数体的二进制代码
 */

@implementation Memory
+ (void)test {
    [[[Memory alloc] init] test01];
}

// 野指针（悬垂指针？）、僵尸对象、空指针
- (void)test01 {
    /*
     野指针：指针指向的对象已经被释放了，内存已经被系统回收；指针没有被初始化为nil，随意指向一块内存
     
     僵尸对象：引用计数为0的对象，内存已经被系统回收
     
     野指针也叫悬垂指针？
     */
    NSObject *obj = [[NSObject alloc] init];
    
    self.weakObject = obj;
    self.assignObject = obj;
    self.unsafeObject = obj;
    
    NSLog(@"self.weakObject: %@", self.weakObject);
    NSLog(@"self.assignObject: %@", self.assignObject);
    NSLog(@"self.unsafeObject: %@", self.unsafeObject);

    obj = nil;

    // weak修饰的指针指向的对象被释放之后，weak指针会被赋值为null，成为了空指针，向空指针发送消息不会有问题。
    NSLog(@"_weakObject: %@", _weakObject); // _weakObject: (null)
    // assign修饰的指针的对象释放之后，assign指针不会被赋值为null，成为了野指针，向野指针发送消息会报错EXC_BAD_ADDRESS
    NSLog(@"_assignObject: %@", _assignObject); // Thread 1: EXC_BAD_ACCESS (code=EXC_I386_GPFLT)
    // unsafe_unretained 同 assign 所以说是不安全的
    NSLog(@"_unsafeObject: %@", _unsafeObject); // Thread 1: EXC_BAD_ACCESS (code=EXC_I386_GPFLT)
}

@end
