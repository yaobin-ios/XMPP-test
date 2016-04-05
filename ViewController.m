//
//  ViewController.m
//  XMPP-test
//
//  Created by yaobin on 15/10/30.
//  Copyright © 2015年 yaobin. All rights reserved.
//

#import "ViewController.h"
#import "XMPPChatViewController.h"

@interface ViewController ()
{
    UITextField * User_textfield;
    UITextField * Psd_textfield;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel * user_label = [UILabel new];
    [self.view addSubview:user_label];
    user_label.text = @"用户名:";
    user_label.textAlignment = NSTextAlignmentCenter;
    [user_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-40);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    User_textfield = [UITextField new];
    [self.view addSubview:User_textfield];
    User_textfield.layer.cornerRadius = 5.0f;
    User_textfield.layer.borderColor = [UIColor lightGrayColor].CGColor;
    User_textfield.layer.borderWidth = 1.0f;
    User_textfield.layer.masksToBounds = YES;
    User_textfield.tag  = 0;
    User_textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    [User_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(user_label.mas_right).offset(10);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-40);
        make.height.mas_equalTo(30);
    }];
    
    UILabel * pad_label = [UILabel new];
    [self.view addSubview:pad_label];
    pad_label.text = @"密码:";
    pad_label.textAlignment = NSTextAlignmentCenter;
    [pad_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    Psd_textfield = [UITextField new];
    [self.view addSubview:Psd_textfield];
    Psd_textfield.layer.cornerRadius = 5.0f;
    Psd_textfield.layer.borderColor = [UIColor lightGrayColor].CGColor;
    Psd_textfield.layer.borderWidth = 1.0f;
    Psd_textfield.layer.masksToBounds = YES;
    Psd_textfield.secureTextEntry = YES;
    Psd_textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    [Psd_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pad_label.mas_right).offset(10);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    UIButton * Login = [UIButton new];
    [self.view addSubview:Login];
    Login.backgroundColor = [UIColor orangeColor];
    [Login addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
    [Login setTitle:@"登录" forState:UIControlStateNormal];
    [Login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(100);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
}


-(void)HideKeyBoard{
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITextField class]]){
            UITextField * view = (UITextField*)obj;
            [view resignFirstResponder];
        }
    }];
}



-(void)Login:(UIButton *)sender{
    [self HideKeyBoard];

    [[XMPPManager defaultManager] connectToHost:HOST User:User_textfield.text Password:Psd_textfield.text device:@"iphone"];
    [[XMPPManager defaultManager] didSuccessLogin:^(NSDictionary *dic) {
        if ([dic[@"status"] intValue] == 1){
            XMPPChatViewController * Controller = [XMPPChatViewController new];
            UINavigationController * NavController = [[UINavigationController alloc] initWithRootViewController:Controller];
            [self presentViewController:NavController animated:YES completion:nil];
        }else{
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
