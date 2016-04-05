//
//  XMPPManager.m
//  XMPP-test
//
//  Created by yaobin on 15/10/30.
//  Copyright © 2015年 yaobin. All rights reserved.
//

#import "XMPPManager.h"

@implementation XMPPManager

#pragma mark 单例方法的实现
+(XMPPManager *)defaultManager{
    static XMPPManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XMPPManager alloc]init];
    });
    return manager;
}

-(void)setupXMPPStream{
    
    _xmppStream = [[XMPPStream alloc] init];
    self.Reconnect = [[XMPPReconnect alloc] init];
    [self.Reconnect activate:self.xmppStream];
    // 设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

-(void)connectToHost:(NSString *)host User:(NSString *)user Password:(NSString *)password device:(NSString *)device{
    NSLog(@"开始连接到服务器");
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    
    // 设置登录用户JID
    //resource 标识用户登录的客户端 iphone android
    Password = password;
    Host = host;
    XMPPJID *myJID = [XMPPJID jidWithUser:user domain:host resource:device];
    _xmppStream.myJID = myJID;
    
    // 设置服务器域名
    _xmppStream.hostName = host;//不仅可以是域名，还可是IP地址
    
    // 设置端口 如果服务器端口是5222，可以省略
    _xmppStream.hostPort = 5222;
    
    // 连接
    NSError *err = nil;
    if(![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&err]){
        NSLog(@"%@",err);
    }
    
}

-(void)sendPwdToHost{
    NSLog(@"再发送密码授权");
    NSError *err = nil;
    [_xmppStream authenticateWithPassword:Password error:&err];
    if (err) {
        NSLog(@"%@",err);
        _StatusBlock(@{@"status":@false});
    }
}

#pragma mark  授权成功后，发送"在线" 消息
-(void)sendOnlineToHost{
    
    NSLog(@"发送 在线 消息");
    XMPPPresence *presence = [XMPPPresence presence];
    //    NSLog(@"%@",presence);
    
    [_xmppStream sendElement:presence];
    _StatusBlock(@{@"status":@true});
}

#pragma mark 与主机连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"与主机连接成功");
    // 主机连接成功后，发送密码进行授权
    [self sendPwdToHost];
}

#pragma mark  与主机断开连接
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    // 如果有错误，代表连接失败
    NSLog(@"与主机断开连接 %@",error);
    _StatusBlock(@{@"status":@false});
}

#pragma mark 授权成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"授权成功");
    
    [self sendOnlineToHost];
}

#pragma mark 授权失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"授权失败 %@",error);
    _StatusBlock(@{@"status":@false});
}


-(void)logout{
    // 1." 发送 `离线` 消息"
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    
    // 2. 与服务器断开连接
    [_xmppStream disconnect];
}

/*
//与登录一样，首先发送帐号建立连接
//连接成功后，发送注册的密码
//注册成功后，框架会通知代理
//实现以下代理方法
- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    NSLog(@"注册成功");
    
    if (_resultBlock) {
        _resultBlock(BWXMPPLoginResultSuccessed);
    }
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error {
    if (_resultBlock) {
        _resultBlock(BWXMPPLoginResultFailure);
    }
}
 */

- (void)sendMessage:(NSString *) message toUser:(NSString *) user {
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:message];
    NSXMLElement * Elementmsg = [NSXMLElement elementWithName:@"message"];
    [Elementmsg addAttributeWithName:@"type" stringValue:@"chat"];
    NSString *to = [NSString stringWithFormat:@"%@@%@", user,Host];
    [Elementmsg addAttributeWithName:@"to" stringValue:to];
    [Elementmsg addChild:body];
    [self.xmppStream sendElement:Elementmsg];
}


#pragma mark --聊天的代理方法
//消息发送成功方法
-(void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    NSLog(@"消息发送成功");
}

//消息发送失败
-(void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
    NSLog(@"消息发送失败");
}

//成功接收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    NSString *chatType = message.type;
    if ([chatType isEqualToString:@"chat"]){
        NSString *messageBody = [[message elementForName:@"body"] stringValue];
        if (messageBody != nil){
            NSLog(@"%@",messageBody);
            _MessageBlock(message);
        }
    }else
        NSLog(@"%@",chatType);
}

-(void)didSuccessLogin:(RetuenStatusBlock)Block{
    _StatusBlock = Block;
}

-(void)didReturnMessage:(RetuenMessageBlock)Block{
    _MessageBlock = Block;
}

@end
