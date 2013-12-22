//
//  XiamiLogin.h
//  iXiami
//
//  Created by 祝 嘉栋 on 13-9-4.
//  Copyright (c) 2013年 祝 嘉栋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XiamiLogin : NSObject

+(NSString *)xiamiLoginWithEmail:(NSString *)email password:(NSString *)password;

+(void)clearCookies;

@end
