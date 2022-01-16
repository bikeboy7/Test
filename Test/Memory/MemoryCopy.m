//
//  MemoryCopy.m
//  Test
//
//  Created by panjinyong on 2022/1/16.
//

#import "MemoryCopy.h"

@interface MemoryCopy ()

@property (copy, nonatomic) NSString *copyyStr;

@property (strong, nonatomic) NSString *strongStr;

@property (strong, nonatomic) NSMutableString *mutableStr;

// 可变字符串不能用copy修饰，否则在调用改变字符串方法时会报错，因为实际上copy出来的是个NSString
@property (copy, nonatomic) NSMutableString *mutableCopyyStr;

@end

/*
 copy 只能修饰 NSString NSArray NSDicationary 等不可变的对象
 copy 修饰 只有在调用set方法才会真的执行[xxx copy],否则直接_xxx = obj 赋值时即使obj是个可变对象也不会进行深拷贝
 strong 修饰 浅拷贝，变量的值为同个指针，指向同块内存，只是会让引用计数+1，相当执行了[xxx retain]
 
 只有NSString + copy 是浅拷贝；
 NSMutableString（即使是不应该的）+ copy 是深拷贝；
 (NSString、NSMutableString )+ mutableCopy 是深拷贝
 */

@implementation MemoryCopy

+ (void)test {
    [[[MemoryCopy alloc] init] test06];
}

// copy 深拷贝、浅拷贝
- (void)test01 {
    NSMutableString *originStr = [[NSMutableString alloc] initWithString:@"originStr"];
    self.copyyStr = originStr; // 等同于 _copyyStr = [originStr copy];
    self.strongStr = originStr;// 等同于 _strongStr = [originStr retain];
    
    [originStr setString:@"new str"];
    
    NSLog(@"               对象地址         对象指针地址        对象的值   ");
    NSLog(@"originStr: %p , %p , %@", originStr, &originStr, originStr);
    NSLog(@"strongStr: %p , %p , %@", _strongStr, &_strongStr, _strongStr);
    NSLog(@"copyyStr: %p , %p , %@", _copyyStr, &_copyyStr, _copyyStr);
}

- (void)test02 {
    NSMutableString *originStr = [[NSMutableString alloc] initWithString:@"originStr"];
    _copyyStr = originStr; // 没有调用set方法，_copyyStr与originStr指向同块内存
    _strongStr = originStr;
    
    [originStr setString:@"new str"];
    
    NSLog(@"               对象地址         对象指针地址        对象的值   ");
    NSLog(@"originStr: %p , %p , %@", originStr, &originStr, originStr);
    NSLog(@"strongStr: %p , %p , %@", _strongStr, &_strongStr, _strongStr); // originStr 完全同上
    NSLog(@"copyyStr: %p , %p , %@", _copyyStr, &_copyyStr, _copyyStr); // originStr 完全同上
}

- (void)test03 {
    NSMutableString *originStr = [[NSMutableString alloc] initWithString:@"originStr"];
    _copyyStr = [originStr copy];
    _strongStr = [originStr copy];
    
    [originStr setString:@"new str"];
    
    NSLog(@"               对象地址         对象指针地址        对象的值   ");
    NSLog(@"originStr: %p , %p , %@", originStr, &originStr, originStr);
    NSLog(@"strongStr: %p , %p , %@", _strongStr, &_strongStr, _strongStr); // originStr 新的内存
    NSLog(@"copyyStr: %p , %p , %@", _copyyStr, &_copyyStr, _copyyStr); // originStr 新的内存
}

// mutableCopy 深拷贝
- (void)test04 {
    NSMutableString *originStr = [[NSMutableString alloc] initWithString:@"originStr"];
    
    self.mutableStr = [originStr mutableCopy];
    
    [self.mutableStr setString:@"new mutableStr"];

    [originStr setString:@"new str"];
    
    NSLog(@"               对象地址         对象指针地址        对象的值   ");
    NSLog(@"originStr: %p , %p , %@", originStr, &originStr, originStr);
    NSLog(@"copyyStr: %p , %p , %@", _mutableStr, &_mutableStr, _mutableStr);
    
}


- (void)test05 {
    NSMutableString *originStr = [[NSMutableString alloc] initWithString:@"originStr"];
    
    self.mutableCopyyStr = originStr; 
    
    NSLog(@"               对象地址         对象指针地址        对象的值   ");
    NSLog(@"originStr: %p , %p , %@", originStr, &originStr, originStr);
    NSLog(@"copyyStr: %p , %p , %@", _mutableCopyyStr, &_mutableCopyyStr, _mutableCopyyStr);

    [self.mutableCopyyStr setString:@"new mutableCopyyStr"];
    // 可变字符串不能用copy修饰，否则在调用改变字符串方法时会报错，因为实际上copy出来的是个NSString
    // [NSTaggedPointerString setString:]: unrecognized selector sent to instance 0x865556cbb49388e2'
}

- (void)test06 {
    NSString *originStr = @"originStr";
   
    // 深拷贝,确实是个可变字符串
    NSMutableString *str = [originStr mutableCopy];
    
    NSString *str2 = [originStr mutableCopy];
    
    NSMutableString *str3 = (NSMutableString *)str2;
    
    [str3 setString:@"str3"];
    
    [str setString:@"new str"];
    
    NSLog(@"%@, %@", [str2 class], str2);
        
    NSLog(@"               对象地址         对象指针地址        对象的值   ");
    NSLog(@"originStr: %p , %p , %@", originStr, &originStr, originStr);
    NSLog(@"copyyStr: %p , %p , %@", str, &str, str);
}




@end
