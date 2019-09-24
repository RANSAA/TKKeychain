//
//  TKKeychainManager.h
//  TKKeyChainDemo
//
//  Created by mac on 2019/9/23.
//  Copyright © 2019 mac. All rights reserved.
//

/**
 该类简单封装了钥匙串的增，删，改，查功能！
 以及模拟获取UDID功能
 **/


#import "TKKeychainQuery.h"


NS_ASSUME_NONNULL_BEGIN

@interface TKKeychainManager : NSObject

/**
 获取钥匙串中指定service与account的数据
 返回：NSString
 **/
+ (nullable NSString *)getRequestStrForService:(nonnull NSString *)serviceName account:(nonnull NSString *)account;
+ (nullable NSString *)getRequestStrForService:(nonnull NSString *)serviceName account:(nonnull NSString *)account error:(NSError **)error __attribute__((swift_error(none)));

/**
 获取钥匙串中指定service与account的数据
 返回：NSData
 **/
+ (nullable NSData *)getRequestDataForService:(nonnull NSString *)serviceName account:(nonnull NSString *)account;
+ (nullable NSData *)getRequestDataForService:(nonnull NSString *)serviceName account:(nonnull NSString *)account error:(NSError **)error __attribute__((swift_error(none)));


/**
 保存数据到指定钥匙串
 数据格式：NSString
 返回：成功或者失败
 **/
+ (BOOL)saveRequestStr:(NSString *)requestStr forService:(nonnull NSString *)serviceName account:(nonnull NSString *)account;
+ (BOOL)saveRequestStr:(NSString *)requestStr forService:(nonnull NSString *)serviceName account:(nonnull NSString *)account error:(NSError **)error __attribute__((swift_error(none)));

/**
 保存数据到指定钥匙串
 数据格式：NSData
 返回：成功或者失败
 **/
+ (BOOL)saveRequestData:(NSData *)requestData forService:(nonnull NSString *)serviceName account:(nonnull NSString *)account;
+ (BOOL)saveRequestData:(NSData *)requestData forService:(nonnull NSString *)serviceName account:(nonnull NSString *)account error:(NSError **)error __attribute__((swift_error(none)));


/**
 删除指定指定service与account的钥匙串
 返回：删除成功或者失败
 **/
+ (BOOL)delRequestForService:(nonnull NSString *)serviceName account:(nonnull NSString *)account;
+ (BOOL)delRequestForService:(nonnull NSString *)serviceName account:(nonnull NSString *)account error:(NSError **)error __attribute__((swift_error(none)));

/**
 删除当前APP中的所有钥匙串数据
 该方法谨慎操作
**/
+ (void)delAllKeyChainData;


/**
 返回所有的钥匙串数据
 如果没有，返回nil
 **/
+ (nullable NSArray<NSDictionary<NSString *, id> *> *)allAccounts;
+ (nullable NSArray<NSDictionary<NSString *, id> *> *)allAccounts:(NSError *__autoreleasing *)error __attribute__((swift_error(none)));


/**
 返回指定服务中所有钥匙串数据
 如果没有，返回nil
 **/
+ (nullable NSArray<NSDictionary<NSString *, id> *> *)accountsForService:(nullable NSString *)serviceName;
+ (nullable NSArray<NSDictionary<NSString *, id> *> *)accountsForService:(nullable NSString *)serviceName error:(NSError *__autoreleasing *)error __attribute__((swift_error(none)));


#pragma mark 附加
/**
 获取设备UDID,APP卸载之后也不会变
 注意：不同的APP获取到的UDID不同，目前相同的TeamID,的UDID也不相同，没共享！
 **/
+ (NSString *)getUDIDString;


@end

NS_ASSUME_NONNULL_END
