//
//  TKKeychainManager.m
//  TKKeyChainDemo
//
//  Created by mac on 2019/9/23.
//  Copyright © 2019 mac. All rights reserved.
//

#import "TKKeychainManager.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation TKKeychainManager



/**
 获取钥匙串中指定service与account的数据
 返回：NSString
 **/
+ (nullable NSString *)getRequestStrForService:(nonnull NSString *)serviceName account:(nonnull NSString *)account
{
    return [self getRequestStrForService:serviceName account:account error:nil];
}
+ (nullable NSString *)getRequestStrForService:(nonnull NSString *)serviceName account:(nonnull NSString *)account error:(NSError **)error __attribute__((swift_error(none)))
{
    TKKeychainQuery *query = [[TKKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    [query fetch:error];
    return query.requestStr;
}

/**
 获取钥匙串中指定service与account的数据
 返回：NSData
 **/
+ (nullable NSData *)getRequestDataForService:(nonnull NSString *)serviceName account:(nonnull NSString *)account
{
    return [self getRequestDataForService:serviceName account:account error:nil];
}
+ (nullable NSData *)getRequestDataForService:(nonnull NSString *)serviceName account:(nonnull NSString *)account error:(NSError **)error __attribute__((swift_error(none)))
{
    TKKeychainQuery *query = [[TKKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    [query fetch:error];
    return query.requestData;
}



/**
 保存数据到指定钥匙串
 数据格式：NSString
 返回：成功或者失败
 **/
+ (BOOL)saveRequestStr:(NSString *)requestStr forService:(nonnull NSString *)serviceName account:(nonnull NSString *)account
{
    return [self saveRequestStr:requestStr forService:serviceName account:account error:nil];
}
+ (BOOL)saveRequestStr:(NSString *)requestStr forService:(nonnull NSString *)serviceName account:(nonnull NSString *)account error:(NSError **)error __attribute__((swift_error(none)))
{
    TKKeychainQuery *query = [[TKKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    query.requestStr = requestStr;
    return [query save:error];
}

/**
 保存数据到指定钥匙串
 数据格式：NSData
 返回：成功或者失败
 **/
+ (BOOL)saveRequestData:(NSData *)requestData forService:(nonnull NSString *)serviceName account:(nonnull NSString *)account
{
    return [self saveRequestData:requestData forService:serviceName account:account error:nil];
}
+ (BOOL)saveRequestData:(NSData *)requestData forService:(nonnull NSString *)serviceName account:(nonnull NSString *)account error:(NSError **)error __attribute__((swift_error(none)))
{
    TKKeychainQuery *query = [[TKKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    query.requestData = requestData;
    return [query save:error];
}


/**
 删除指定指定service与account的钥匙串
 返回：删除成功或者失败
 **/
+ (BOOL)delRequestForService:(nonnull NSString *)serviceName account:(nonnull NSString *)account
{
    return [self delRequestForService:serviceName account:account error:nil];
}
+ (BOOL)delRequestForService:(nonnull NSString *)serviceName account:(nonnull NSString *)account error:(NSError **)error __attribute__((swift_error(none)))
{
    TKKeychainQuery *query = [[TKKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    return [query deleteItem:error];
}


/**
 删除当前APP中的所有钥匙串数据
 该方法谨慎操作
 **/
+ (void)delAllKeyChainData
{
    NSArray *allAccounts = [self allAccounts];
    for (NSDictionary *node in allAccounts) {
        NSString *acct = node[@"acct"];
        NSString *svce = node[@"svce"];
        [self delRequestForService:svce account:acct];
    }
}



/**
 返回所有的钥匙串数据
 如果没有，返回nil
 **/
+ (nullable NSArray<NSDictionary<NSString *, id> *> *)allAccounts
{
    return [self allAccounts:nil];
}
+ (nullable NSArray<NSDictionary<NSString *, id> *> *)allAccounts:(NSError *__autoreleasing *)error __attribute__((swift_error(none)))
{
    return [self accountsForService:nil error:error];
}


/**
 返回指定服务中所有钥匙串数据
 如果没有，返回nil
 **/
+ (nullable NSArray<NSDictionary<NSString *, id> *> *)accountsForService:(nullable NSString *)serviceName
{
    return [self accountsForService:serviceName error:nil];
}
+ (nullable NSArray<NSDictionary<NSString *, id> *> *)accountsForService:(nullable NSString *)serviceName error:(NSError *__autoreleasing *)error __attribute__((swift_error(none)))
{
    TKKeychainQuery *query = [[TKKeychainQuery alloc] init];
    query.service = serviceName;
    return [query fetchAll:error];
}


#pragma mark 附加
/**
 获取设备UDID,APP卸载之后也不会变
 注意：不同的APP获取到的UDID不同，目前相同的TeamID,的UDID也不相同，没共享！
 **/
+ (NSString *)getUDIDString
{
    NSString *udid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSString *service = @"com.device.udid.keychain.sevice";
    NSString *account = @"com.device.udid.keychain.account";
    NSString *queryUDID = [self getRequestStrForService:service account:account];
    if (queryUDID) {
        return queryUDID;
    }else{
        [self saveRequestStr:udid forService:service account:account];
        return udid;
    }
}


@end
