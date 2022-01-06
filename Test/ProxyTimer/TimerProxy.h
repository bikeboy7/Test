//
//  TimerProxy.h
//  Test
//
//  Created by panjinyong on 2021/8/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimerProxy : NSProxy
@property (weak, nonatomic) id target;

+ (instancetype)initWithTaret:(id)target;

@end

NS_ASSUME_NONNULL_END
