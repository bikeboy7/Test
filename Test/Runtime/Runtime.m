//
//  Runtime.m
//  Test
//
//  Created by panjinyong on 2021/8/31.
//

#import "Runtime.h"
#import "Student.h"
#import <objc/runtime.h>
#import "Message.h"

@implementation Runtime

- (void)test {
//    [self classTest];
//    [self classTest1];
//    [self classTest2];
//    [self classTest3];
//    [self isaTest];
    [self messageTest];

}


- (void)messageTest {
    Student *studnet = [[Student alloc] init];
    [studnet performSelector:@selector(doHomework)];
    [Student performSelector:@selector(doHomework)];
    [studnet performSelector:@selector(doHomework2)];
    [studnet performSelector:@selector(doHomework3)];


    
}

- (void)isaTest {
    Student *studnet1 = [[Student alloc] init];
    Student *studnet2 = [[Student alloc] init];
    Student *studnet3 = studnet1;

    NSLog(@"%p", [studnet1 class]);
    NSLog(@"%p", [studnet2 class]);
    NSLog(@"%p", [studnet3 class]);
    
}

- (void)classTest {
    [[Student alloc] init];
}

- (void)classTest1 {
    
    BOOL rs1 = [[NSObject class] isKindOfClass:[NSObject class]];
    BOOL rs2 = [[NSObject class] isMemberOfClass:[NSObject class]];
    BOOL rs3 = [[Person class] isKindOfClass:[Person class]];
    BOOL rs4 = [[Person class] isMemberOfClass:[Person class]];

    NSLog(@"rs1 = %d, rs2 = %d, rs3 = %d, rs4 = %d", rs1, rs2, rs3, rs4);
    // rs1 = 1, rs2 = 0, rs3 = 0, rs4 = 0
}

- (void)classTest2 {

    BOOL rs1 = [[[NSObject alloc] init] isKindOfClass:[NSObject class]];
    BOOL rs2 = [[[NSObject alloc] init] isMemberOfClass:[NSObject class]];
    BOOL rs3 = [[[Person alloc] init] isKindOfClass:[Person class]];
    BOOL rs4 = [[[Person alloc] init] isMemberOfClass:[Person class]];

    NSLog(@"rs1 = %d, rs2 = %d, rs3 = %d, rs4 = %d", rs1, rs2, rs3, rs4);
    // rs1 = 1, rs2 = 1, rs3 = 1, rs4 = 1
}

- (void)classTest3 {
        
    // 返回结果等同于[Student class]
    NSLog(@"[[[Student class] class] class] = %@", [[[Student class] class] class]);
    
    // 会返回对应父类
    NSLog(@"[[Student superclass] superclass] = %@", [[Student superclass] superclass]);
    
    // 返回结果等同于[Student class]
    Class class1 = objc_getClass([NSStringFromClass([Student class]) UTF8String]);
    NSLog(@"class1: %@, address = %p, isMetaClass = %d", class1, class1, class_isMetaClass(class1));

    // 返回传入参数的isa
    Class class2 = object_getClass([Student class]);
    NSLog(@"class2: %@, address = %p, isMetaClass = %d", class2, class2, class_isMetaClass(class2));
    
    Class class3 = object_getClass([[Student alloc] init]);
    NSLog(@"class3: %@, address = %p, isMetaClass = %d", class3, class3, class_isMetaClass(class3));

}

/**
 
 //类对象返回自身
 + (Class)class {
     return self;
 }

 //如果obj不是nil，就返回对象isa指针指向的对象
 Class object_getClass(id obj)
 {
     if (obj) return obj->getIsa();
     else return Nil;
 }
 
 + (BOOL)isMemberOfClass:(Class)cls {
     return object_getClass((id)self) == cls;
 }

 - (BOOL)isMemberOfClass:(Class)cls {
     return [self class] == cls;
 }

 + (BOOL)isKindOfClass:(Class)cls {
     for (Class tcls = object_getClass((id)self); tcls; tcls = tcls->superclass) {
         if (tcls == cls) return YES;
     }
     return NO;
 }

 - (BOOL)isKindOfClass:(Class)cls {
     for (Class tcls = [self class]; tcls; tcls = tcls->superclass) {
         if (tcls == cls) return YES;
     }
     return NO;
 }
 
 */




@end
