//
//  XiamiLogin.m
//  iXiami
//
//  Created by 祝 嘉栋 on 13-9-4.
//  Copyright (c) 2013年 祝 嘉栋. All rights reserved.
//

#import "XiamiLogin.h"

@implementation XiamiLogin

+(void)clearCookies
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://www.xiami.com/"]];
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://www.xiami.com/"]];
    NSLog(@"%@", cookies);
}

+(NSString *)xiamiLoginWithEmail:(NSString *)email password:(NSString *)password
{
    // 常量设置
    NSString *ua = @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.62 Safari/537.36";
    NSString *url = @"http://www.xiami.com/";
    
    NSLog(@"%@ %@ Loging in...", email, password);
    
    // Cookie设置
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    // 生成 POST Request Header
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.xiami.com/web/login"] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:60.0];
    [request addValue:ua forHTTPHeaderField:@"User-Agent"];
    [request addValue:@"http://www.xiami.com/web/login" forHTTPHeaderField:@"Referer"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];

    // 生成 POST Data
    NSMutableData *post = [NSMutableData data];
    [post appendData:[[[NSString stringWithFormat:@"email=%@&password=%@&LoginButton=登录", email, password] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:post];
    
    // 提交请求
    NSHTTPURLResponse * response = nil;
    NSError * error = nil;
    NSData * responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"Response Received: %ld \n %@", [responseData length], [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    // 获取 Cookie 信息
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:url]];
    NSLog(@"%@", cookies);
    for (NSHTTPCookie *cookie in cookies) {
        if ([[[cookie properties] objectForKey:NSHTTPCookieName] isEqualToString:@"member_auth"]) {
            NSString *member_auth = [[cookie properties] objectForKey:NSHTTPCookieValue];
            NSLog(@"%@", member_auth);
            return member_auth;
        }
    }
    
    NSLog(@"登录失败!");
    return @"Failed";
}

@end
