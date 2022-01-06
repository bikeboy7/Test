//
//  TaggedPointer.m
//  Test
//
//  Created by panjinyong on 2021/8/31.
//

#import "TaggedPointer.h"

@implementation TaggedPointer

- (void)test {
//    [self testNumber];
//    [self testString];
    [self testString3];
}

- (void)testNumber {
    for (int i = 0; i < 16; i ++) {
        NSNumber *number = [[NSNumber alloc] initWithInt:i];
        NSLog(@"number%d = %p", i, number);
    }
    
}

- (void)testString {
    NSMutableString *muStr2 = [NSMutableString stringWithString:@"1"];
    for(int i=0; i<14; i+=1){
        NSString *strFor = [[muStr2 mutableCopy] copy];
        NSLog(@"%@, %p", [strFor class], strFor);
        [muStr2 appendString:@"1"];
    }
}

- (void)testString2 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0 );
    for (int i = 0 ; i < 10000; i ++) {
        dispatch_async(queue, ^{
            self.name = [NSString stringWithFormat:@"%@",@"123sdfasfdas"];
        });
    }
}

- (void)testString3 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0 );
    for (int i = 0 ; i < 10000; i ++) {
        dispatch_async(queue, ^{
            self.name = [NSString stringWithFormat:@"%@",@"123"];
        });
    }
}


@end
