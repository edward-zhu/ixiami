//
//  DownloadList.m
//  iXiami
//
//  Created by 祝 嘉栋 on 13-8-31.
//  Copyright (c) 2013年 祝 嘉栋. All rights reserved.
//

#import "DownloadList.h"

@implementation DownloadList

@synthesize currentDownloading;
@synthesize downloadQuene;
@synthesize downloadQueneDelegate;

- (id)init:(id<DownloadQueneDelegate>)delegate
{
    self = [super init];
    downloadQuene = [[NSMutableArray alloc] init];
    downloadQueneDelegate = delegate;
    
    return self;
}

- (void)addDownloadItem:(DownloadItem *)downloadItem
{
    [downloadQuene addObject:downloadItem];
}

- (void)startDownloadQuene
{
    
    currentDownloading = 0;
    NSError *error = nil;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:@"~/Music/xiami"]) {
        [fileManager createDirectoryAtPath:@"~/Music/xiami" withIntermediateDirectories:YES attributes:nil error:&error];
    }
    [[downloadQuene objectAtIndex:currentDownloading] startDownload];
}

- (void)didReceiveData:(DownloadItem*)download ofLength:(NSUInteger)length total:(NSUInteger)totalLength
{
    [downloadQueneDelegate didReceiveDataOfID:currentDownloading totalItem:[downloadQuene count] receivedLength:length totalLength:totalLength];
}

- (void)downloadDidFinish:(DownloadItem *)downloadItem
{
    [downloadQueneDelegate downloadDidFinishForID:currentDownloading++ totalItem:[downloadQuene count] path:downloadItem.DI_Path];
    if (currentDownloading <= [downloadQuene count] - 1) {
        [[downloadQuene objectAtIndex:currentDownloading] startDownload];
    }
    else {
        [downloadQueneDelegate downloadQueneFinished];
    }
}



@end
