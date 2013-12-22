//
//  URLDecodeHelper.m
//  iXiami
//
//  Created by 祝 嘉栋 on 13-8-31.
//  Copyright (c) 2013年 祝 嘉栋. All rights reserved.
//

#import "URLDecodeHelper.h"

@implementation URLDecodeHelper

+(NSString *)convertURL:(NSString *)rawUrl
{
    NSInteger length, row, longRow, rowLength;
    length = [rawUrl length];
    length = length - 1;
    row = (char)[rawUrl characterAtIndex:0] - '0';
    NSMutableArray *strArray = [NSMutableArray arrayWithCapacity:10];
    NSInteger curRow, curLoc = 1;
    longRow = length % row;
    rowLength = length / row;
    for (curRow = 1; curRow <= row; curRow++) {
        NSInteger thisRowLength;
        if (curRow <= longRow) {
            thisRowLength = rowLength + 1;
        }
        else {
            thisRowLength = rowLength;
        }
        [strArray addObject:[rawUrl substringWithRange:NSMakeRange(curLoc, thisRowLength)]];
        curLoc += thisRowLength;
    }
    for (NSString *rowStr in strArray) {
        NSLog(@"%@", rowStr);
    }
    unichar charsets[1000];
    NSInteger pos = 0;
    for (NSInteger loc = 0; loc < rowLength + 1; loc ++) {
        for (NSString *rowStr in strArray) {
            if(loc + 1 <= [rowStr length]) {
                charsets[pos++] = [rowStr characterAtIndex:loc];
            }
        }
    }
    NSString *realUrl = [NSString stringWithCharacters:charsets length:length];
    realUrl = [realUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    realUrl = [realUrl stringByReplacingOccurrencesOfString:@"^" withString:@"0"];
    
    return realUrl;
}

@end
