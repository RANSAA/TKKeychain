//
//  TKKeychainQuery.h
//  TKKeyChainDemo
//
//  Created by mac on 2019/9/23.
//  Copyright © 2019 mac. All rights reserved.
//

/**
 注意该框架只操作kSecClassGenericPassword(一般密码)类型的钥匙串，并且不与iCloud相关
 即钥匙串只会存储到设备上。
 如果要使用iCloud，请转移到:https://github.com/soffes/SAMKeychain

 功能：对钥匙串访问的简单封装
 注意：只能访问当前APP的钥匙串，或者相同Team下共享的钥匙串（该工具并没有共享Team钥匙串）
 其它：http://blog.sina.com.cn/s/blog_7ea0400d0101fksj.html

 **/


#if __has_feature(modules)
@import Foundation;
@import Security;
#else
#import <Foundation/Foundation.h>
#import <Security/Security.h>
#endif

NS_ASSUME_NONNULL_BEGIN


@interface TKKeychainQuery : NSObject
/**
 kSecAttrAccount
 :对应的账号
 ps:kSecClassGenericPassword: 一般密码会使用
 **/
@property (nonatomic, copy, nonnull) NSString *account;
/**
 kSecAttrService
 :对应的服务
 ps:kSecClassGenericPassword: 一般密码会使用
 */
@property (nonatomic, copy, nonnull) NSString *service;
/** kSecAttrLabel
 :描述(可选)给用户看的
 **/
@property (nonatomic, copy, nullable) NSString *remark;

/**
 需要存到钥匙串的数据
 字符串要使用UTF-8
 注意：存放到钥匙串中的数据不能太大
 **/
@property (nonatomic, copy, nullable) NSData   *requestData;
@property (nonatomic, copy, nullable) NSString *requestStr;
/**
 :可归档，接档对象
 `requestObject` using NSKeyedArchiver and NSKeyedUnarchiver.
 */
@property (nonatomic, copy, nullable) id<NSCoding> requestObject;





/** 保存，返回是否成功 **/
- (BOOL)save:(NSError **)error;
/** 删除，返回是否成功 **/
- (BOOL)deleteItem:(NSError **)error;
/**
 查询钥匙串中所有的数据（针对于当前APP）
 没有查询到返回nil
 **/
- (nullable NSArray<NSDictionary<NSString *, id> *> *)fetchAll:(NSError **)error;
/**
 查询钥匙串中指定service与account是否含有数据
 如果有，会将查询到的数据赋值给self.requestData
 **/
- (BOOL)fetch:(NSError **)error;



@end

NS_ASSUME_NONNULL_END
