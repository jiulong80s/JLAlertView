//
//  ViewController.m
//  Test
//
//  Created by 周九龙 on 16/2/18.
//  Copyright © 2016年 Carlos. All rights reserved.
//

#import "ViewController.h"
#import "JLAlertView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)click:(UIButton *)sender {
	JLAlertView *alert = nil;
	switch (sender.tag) {
		case 1:
			alert = [[JLAlertView alloc] initWithTitle:@"提示1" detailText:@"测试一下 JLAlertview" customView:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"]];
				break;
		case 2:
			alert = [[JLAlertView alloc] initWithTitle:@"提示2" detailText:@"测试一下 JLAlertview\n换个行试试" customView:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"]];
			break;
		case 3:
			alert = [[JLAlertView alloc] initWithTitle:@"提示3" detailText:@"测试一下 JLAlertview，多个按钮试试" customView:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@" button1",@" button2"]];
			break;
		case 4:
		{
			UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 180, 50)];
			view.backgroundColor = [UIColor orangeColor];
			alert = [[JLAlertView alloc] initWithTitle:@"提示4" detailText:@"测试一下 JLAlertview,添加自定义视图" customView:view cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"]];
		}
			break;
			
	  default:
				break;
	}
	
	[alert showWithBlock:^(NSInteger index) {
		NSLog(@"click button index:%ld",index);
	}];
	
}
@end
