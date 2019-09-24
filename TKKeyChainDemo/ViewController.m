//
//  ViewController.m
//  TKKeyChainDemo
//
//  Created by mac on 2019/9/23.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ViewController.h"
#import "TKKeychain.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self test];
}

- (void)test
{
    NSString *UDID = [TKKeychainManager getUDIDString];
    NSLog(@"UDID:%@",UDID);

//    [TKKeychainManager saveRequestStr:@"test" forService:@"testService" account:@"accTest3"];

    NSLog(@"all:\n%@",[TKKeychainManager allAccounts]);

//    [TKKeychainManager delRequestForService:@"com.qishare.ios.keychain" account:@"1222"];
//    [TKKeychainManager delAllKeyChainData];
}

@end
