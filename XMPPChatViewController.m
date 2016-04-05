//
//  XMPPChatViewController.m
//  XMPP-test
//
//  Created by yaobin on 15/10/31.
//  Copyright © 2015年 yaobin. All rights reserved.
//

#import "XMPPChatViewController.h"

@interface XMPPChatViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * TableView;
    NSMutableArray * Message_array;
    UITextField *Content_Text;
}
@end

@implementation XMPPChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"聊天";
    
    TableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,ScreenWidth,ScreenHeight-50} style:UITableViewStylePlain];
    [self.view addSubview:TableView];
    TableView.dataSource = self;
    TableView.delegate = self;
    TableView.tableFooterView = [UIView new];
    
    UIToolbar * Toolbar = [UIToolbar new];
    [self.view addSubview:Toolbar];
    NSMutableArray *myToolBarItems = [NSMutableArray array];
    Content_Text = [[UITextField alloc] initWithFrame:(CGRect){10,10,ScreenWidth-80,30}];
    Content_Text.backgroundColor = [UIColor whiteColor];
    Content_Text.layer.cornerRadius = 5.0f;
    Content_Text.layer.masksToBounds = YES;
    UIBarButtonItem *myButtonItem = [[UIBarButtonItem alloc]initWithCustomView:Content_Text];
    [myToolBarItems addObject: myButtonItem];
    UIButton *Sendbtn = [[UIButton alloc] initWithFrame:(CGRect){ScreenWidth-60,10,50,30}];
    Sendbtn.backgroundColor = [UIColor whiteColor];
    [Sendbtn setTitle:@"发送" forState:UIControlStateNormal];
    [Sendbtn addTarget:self action:@selector(SendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [Sendbtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    Sendbtn.layer.cornerRadius = 5.0f;
    Sendbtn.layer.masksToBounds = YES;
    UIBarButtonItem *myButtonItem1 = [[UIBarButtonItem alloc]initWithCustomView:Sendbtn];
    [myToolBarItems addObject: myButtonItem1];
    
    [Toolbar setItems:myToolBarItems animated:YES];
    [Toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];

    Message_array = [NSMutableArray array];

    __block UITableView * weak_tableview = TableView;
    __block NSMutableArray * weak_array = Message_array;
    [[XMPPManager defaultManager] didReturnMessage:^(XMPPMessage *message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weak_array addObject:message];
            [weak_tableview reloadData];
        });
    }];
}


-(void)SendMessage:(UIButton*)sender{
    [Content_Text resignFirstResponder];
    if (Content_Text.text.length != 0){
        [[XMPPManager defaultManager] sendMessage:Content_Text.text toUser:@"admin"];
        Content_Text.text = @"";
    }
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return Message_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * indetifer = @"cell";
    UITableViewCell * cell = [TableView dequeueReusableCellWithIdentifier:indetifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifer];
    }
    XMPPMessage * meg = Message_array[indexPath.row];
    cell.textLabel.text = meg.body;
    
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
