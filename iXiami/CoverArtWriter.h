//
//  CoverArtWriter.h
//  iXiami
//
//  Created by 祝 嘉栋 on 13-9-19.
//  Copyright (c) 2013年 祝 嘉栋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoverArtWriter : NSObject

+(void)writeCoverArt:(NSString *)audioFile withPicture:(NSString *)picPath;

@end
