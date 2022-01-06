//
//  Student.m
//  Test
//
//  Created by panjinyong on 2021/8/31.
//

#import "Student.h"
#import <objc/runtime.h>

@interface MessageStudnet : NSObject
@end

@implementation MessageStudnet
- (void)doHomework {
    NSLog(@"doing homeeork");
}
@end

@interface MessageStudnet2 : NSObject
@end

@implementation MessageStudnet2
- (void)doHomework2 {
    NSLog(@"doing homeeork 2");
}
@end

@interface MessageStudnet3 : NSObject
@end

@implementation MessageStudnet3
- (void)doHomework3 {
    NSLog(@"doing homeeork 3");
}
@end


@implementation Student
- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self test];
    }
    return self;
}

- (void)test {
    NSLog(@"[self class] = %@", [self class]); // student
    NSLog(@"[super class] = %@", [super class]); // student
    NSLog(@"[self superclass] = %@", [self superclass]); // person
    NSLog(@"[super superclass] = %@", [super superclass]); // person
}
//
//- (void)doHomework {
//    NSLog(@"doing homeeork");
//}

/**
 消息：
 
 1、消息发送
 1）判断receiver是否为nil，为nil则退出
 2）从receiverClass的cache查找方法，找到则调用，结束查找
 3）从receiverClass的class_rw_t查找方法，找到则调用，并将方法缓存到receiverClass的cache
 4）从superClass中的cache、class_rw_t查找方法，找到则调用，并将方法缓存到receiverClass的cache，直至根父类
 5）直至根父类都没找到方法，进入 动态方法解析

 2、动态方法解析 resolveInstanceMethod：
 可以为此类添加一个方法，方法名字sel为所找不到的，并且返回yes，runtime则会重新走“消息发送流程”，从查找缓存那一步开始，自然就找到了方法；
 如果没有添加方法，返回NO则会进入 消息转发
 
 3、消息转发
 1）forwardingTargetForSelector：返回一个可以执行此方法的对象即会执行objc_msgSend(返回值，SEL)，返回nil则进行下一步
 2）methodSignatureForSeleector: 消息转发前的消息签名，签名不为nil则进行下一步
 3）forwardInvocation: 此时可根据参数anInvocation做任何处理，也可调用doesNotRecognizeSelector抛出异常
 
 */

// 动态方法解析
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(doHomework)) {
        // 创建一个方法
        Method method = class_getInstanceMethod(self, @selector(otherMethod));
        // 为此类添加一个方法，key = sel，value = method.imp
        class_addMethod(self,
                        sel,
                        method_getImplementation(method),
                        method_getTypeEncoding(method));
        return  YES;
    }

    return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    if (sel == @selector(doHomework)) {
        // 为此类的元类添加一个方法，key = sel，value = otherMethod2
        Class cla = object_getClass(self);
        class_addMethod(cla,
                        sel,
                        (IMP)otherMethod2,
                        "V@:");
        return  YES;
    }
    return [super resolveInstanceMethod:sel];
}

// 消息转发，返回一个可以执行此方法的对象
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(doHomework2)) {
        MessageStudnet2 *obj = [[MessageStudnet2 alloc] init];
        if ([obj respondsToSelector:aSelector]) {
            return obj;
        }
    }
    return [super forwardingTargetForSelector:aSelector];
}

// 消息转发前的消息签名，配合forwardInvocation使用
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(doHomework3)) {
        if (YES) {
            return [NSMethodSignature signatureWithObjCTypes:"V@:@"];
        }else {
            return [[[MessageStudnet3 alloc] init] methodSignatureForSelector:aSelector];
        }
    }
    return [super methodSignatureForSelector:aSelector];
}

// 消息转发
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    if (anInvocation.selector == @selector(doHomework3)) {
        [anInvocation invokeWithTarget:[[MessageStudnet3 alloc] init]];
    }else {
        [self doesNotRecognizeSelector:anInvocation.selector];
    }
}


- (void)otherMethod {
    NSLog(@"otherMethod");
}

void otherMethod2(id self, SEL _cmd) {
    NSLog(@"otherMethod2");
}


@end
