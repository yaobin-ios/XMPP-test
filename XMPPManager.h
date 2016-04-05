//
//  XMPPManager.h
//  XMPP-test
//
//  Created by yaobin on 15/10/30.
//  Copyright © 2015年 yaobin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "XMPPReconnect.h"

typedef void (^RetuenStatusBlock)(NSDictionary * dic);
typedef void (^RetuenMessageBlock)(XMPPMessage * message);


@interface XMPPManager : NSObject <XMPPStreamDelegate>

{
    NSString * Password;
    NSString * Host;
}

@property (strong, nonatomic)XMPPStream * xmppStream;
@property (strong, nonatomic)XMPPReconnect * Reconnect;

@property (strong, nonatomic)RetuenStatusBlock StatusBlock;
@property (strong, nonatomic)RetuenMessageBlock MessageBlock;

+(XMPPManager *)defaultManager;

/**
 *  开始连接到服务器
 *
 *  @param host   服务器地址
 *  @param user   用户名
 *  @param password 密码
 *  @param device 设备类型  android 或者 iphone
 */
-(void)connectToHost:(NSString *)host User:(NSString *)user Password:(NSString *)password device:(NSString *)device;

/**
 *  连接服务器失败或者成功的回调
 *
 *  @param Block 成功或者失败的状态 成功：true   失败：false
 */
-(void)didSuccessLogin:(RetuenStatusBlock)Block;


/**
 *  接收到消息的回调
 *
 *  @param Block 返回消息体
 */
-(void)didReturnMessage:(RetuenMessageBlock)Block;

/**
 *  发送消息
 *
 *  @param message 消息内容
 *  @param user    消息接收者的用户名
 */
- (void)sendMessage:(NSString *) message toUser:(NSString *) user;

@end
