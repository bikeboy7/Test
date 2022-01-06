//
//  RunLoopTestViewController.m
//  Test
//
//  Created by panjinyong on 2021/9/6.
//

#import "RunLoopTestViewController.h"
#import "MJPermenantThread.h"



@interface RunLoopTestViewController ()
@property (strong, nonatomic) MJPermenantThread *thread;
@end

@implementation RunLoopTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.thread = [[MJPermenantThread alloc] init];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.thread executeTask:^{
        NSLog(@"执行任务 - %@", [NSThread currentThread]);
    }];
}


- (void)dealloc
{
    NSLog(@"%s", __func__);
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
