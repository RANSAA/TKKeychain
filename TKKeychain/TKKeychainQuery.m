//
//  TKKeychainQuery.m
//  TKKeyChainDemo
//
//  Created by mac on 2019/9/23.
//  Copyright © 2019 mac. All rights reserved.
//

#import "TKKeychainQuery.h"

@implementation TKKeychainQuery

#pragma mark - Private
/**
 查询指定服务，账号钥匙串的数据
 **/
- (NSMutableDictionary *)query
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    if (self.service) {
        [dictionary setObject:self.service forKey:(__bridge id)kSecAttrService];
    }
    if (self.account) {
        [dictionary setObject:self.account forKey:(__bridge id)kSecAttrAccount];
    }

    if (self.groupID) {
        [dictionary setObject:self.groupID forKey:(__bridge id)kSecAttrAccessGroup];
    }
    
    return dictionary;
}

/**
 钥匙串操作错误
 **/
+ (NSError *)errorWithCode:(OSStatus)code
{
    NSString *message = nil;
    switch (code) {
        case errSecSuccess: return nil;
        case -1001: message = @"有些参数是无效的"; break;
#if TARGET_OS_IPHONE
        case errSecUnimplemented: {
            message = @"功能或操作未实现";
            break;
        }
        case errSecParam: {
            message = @"传递给函数的一个或多个参数无效";
            break;
        }
        case errSecAllocate: {
            message = @"分配内存失败";
            break;
        }
        case errSecNotAvailable: {
            message = @"没有可用的钥匙链。您可能需要重新启动计算机";
            break;
        }
        case errSecDuplicateItem: {
            message = @"指定的项已存在于密钥链中";
            break;
        }
        case errSecItemNotFound: {
            message = @"在密钥链中找不到指定的项";
            break;
        }
        case errSecInteractionNotAllowed: {
            message = @"不允许用户交互";
            break;
        }
        case errSecDecode: {
            message = @"无法解码提供的数据";
            break;
        }
        case errSecAuthFailed: {
            message = @"您输入的用户名或密码短语不正确";
            break;
        }
        default: {
            message = @"Refer to SecBase.h for description";
        }
#else
        default:
            message = (__bridge_transfer NSString *)SecCopyErrorMessageString(code, NULL);
#endif
    }

    NSDictionary *userInfo = nil;
    if (message) {
        userInfo = @{ NSLocalizedDescriptionKey : message };
    }
    return [NSError errorWithDomain:@"KeyChain" code:code userInfo:userInfo];
}


#pragma mark - Accessors
- (void)setRequestObject:(id<NSCoding>)requestObject
{
    if (@available(iOS 11.0, *)) {
        self.requestData = [NSKeyedArchiver archivedDataWithRootObject:requestObject requiringSecureCoding:YES error:nil];
    } else {
        self.requestData = [NSKeyedArchiver archivedDataWithRootObject:requestObject];
    }
}

- (id<NSCoding>)requestObject
{
    if ([self.requestData length]) {
        if (@available(iOS 11.0, *)) {
            return [NSKeyedUnarchiver unarchivedObjectOfClass:self.class fromData:self.requestData error:nil];
        } else {
            return [NSKeyedUnarchiver unarchiveObjectWithData:self.requestData];
        }
    }
    return nil;
}

- (void)setRequestStr:(NSString *)requestStr
{
    self.requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)requestStr
{
    if ([self.requestData length]) {
        return [[NSString alloc] initWithData:self.requestData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

#pragma mark - Public
/**
 保存到钥匙串，没有就创建，有则更新
 **/
- (BOOL)save:(NSError * _Nullable __autoreleasing *)error
{
    OSStatus status = -1001;
    if (!self.service || !self.account || !self.requestData) {
        if (error) {
            *error = [[self class] errorWithCode:status];
        }
        return NO;
    }
    NSMutableDictionary *query = nil;
    NSMutableDictionary * searchQuery = [self query];
    status = SecItemCopyMatching((__bridge CFDictionaryRef)searchQuery, nil);
    if (status == errSecSuccess) {//更新钥匙串
        query = [[NSMutableDictionary alloc]init];
        [query setObject:self.requestData forKey:(__bridge id)kSecValueData];
#if __IPHONE_4_0 && TARGET_OS_IPHONE
        CFTypeRef accessibilityType = NULL;
        if (accessibilityType) {
            [query setObject:(__bridge id)accessibilityType forKey:(__bridge id)kSecAttrAccessible];
        }
#endif
        status = SecItemUpdate((__bridge CFDictionaryRef)(searchQuery), (__bridge CFDictionaryRef)(query));
    }else if(status == errSecItemNotFound){//创建钥匙串
        query = [self query];
        if (self.remark) {
            [query setObject:self.remark forKey:(__bridge id)kSecAttrLabel];
        }
        [query setObject:self.requestData forKey:(__bridge id)kSecValueData];
#if __IPHONE_4_0 && TARGET_OS_IPHONE
        CFTypeRef accessibilityType = NULL;
        if (accessibilityType) {
            [query setObject:(__bridge id)accessibilityType forKey:(__bridge id)kSecAttrAccessible];
        }
#endif
        status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    }
    if (status != errSecSuccess && error != NULL) {
        *error = [[self class] errorWithCode:status];
    }
    return (status == errSecSuccess);
}

/**
 删除钥匙串
 **/
- (BOOL)deleteItem:(NSError * _Nullable __autoreleasing *)error
{
    OSStatus status = -1001;
    if (!self.service || !self.account) {
        if (error) {
            *error = [[self class] errorWithCode:status];
        }
        return NO;
    }

    NSMutableDictionary *query = [self query];


#if TARGET_OS_IPHONE
    status = SecItemDelete((__bridge CFDictionaryRef)query);
#else
    // On Mac OS, SecItemDelete will not delete a key created in a different
    // app, nor in a different version of the same app.
    //
    // To replicate the issue, save a password, change to the code and
    // rebuild the app, and then attempt to delete that password.
    //
    // This was true in OS X 10.6 and probably later versions as well.
    //
    // Work around it by using SecItemCopyMatching and SecKeychainItemDelete.

    //TARGET_OS_OSX
    CFTypeRef result = NULL;
    [query setObject:@YES forKey:(__bridge id)kSecReturnRef];
    status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    if (status == errSecSuccess) {
        status = SecKeychainItemDelete((SecKeychainItemRef)result);
        CFRelease(result);
    }
#endif

    if (status != errSecSuccess && error != NULL) {
        *error = [[self class] errorWithCode:status];
    }

    return (status == errSecSuccess);
}

/**
 查询钥匙串中所有的数据（针对于当前APP）
 没有查询到返回nil
 **/
- (nullable NSArray *)fetchAll:(NSError *__autoreleasing *)error
{
    NSMutableDictionary *query = [self query];
    [query setObject:@YES forKey:(__bridge id)kSecReturnAttributes];
    [query setObject:(__bridge id)kSecMatchLimitAll forKey:(__bridge id)kSecMatchLimit];
#if __IPHONE_4_0 && TARGET_OS_IPHONE
    CFTypeRef accessibilityType = NULL;
    if (accessibilityType) {
        [query setObject:(__bridge id)accessibilityType forKey:(__bridge id)kSecAttrAccessible];
    }
#endif

    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    if (status != errSecSuccess && error != NULL) {
        *error = [[self class] errorWithCode:status];
        return nil;
    }

    return (__bridge_transfer NSArray *)result;
}

/**
 查询钥匙串中指定service与account是否含有数据
 如果有，会将查询到的数据赋值给self.requestData
 **/
- (BOOL)fetch:(NSError *__autoreleasing *)error
{
    OSStatus status = -1001;
    if (!self.service || !self.account) {
        if (error) {
            *error = [[self class] errorWithCode:status];
        }
        return NO;
    }

    CFTypeRef result = NULL;
    NSMutableDictionary *query = [self query];
    [query setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);

    if (status != errSecSuccess) {
        if (error) {
            *error = [[self class] errorWithCode:status];
        }
        return NO;
    }

    self.requestData = (__bridge_transfer NSData *)result;
    return YES;
}

@end
