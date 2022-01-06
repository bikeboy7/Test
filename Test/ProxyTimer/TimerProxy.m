//
//  TimerProxy.m
//  Test
//
//  Created by panjinyong on 2021/8/31.
//

#import "TimerProxy.h"

@implementation TimerProxy

+ (instancetype)initWithTaret:(id)target
{
    TimerProxy *proxy = [TimerProxy alloc];
    proxy.target = target;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}

@end
