//
//  DownloadList.h
//  iXiami
//
//  Created by 祝 嘉栋 on 13-8-31.
//  Copyright (c) 2013年 祝 嘉栋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadItem.h"

@protocol DownloadQueneDelegate <NSObject>

- (void)didReceiveDataOfID:(NSInteger)count totalItem:(NSInteger)totalItem receivedLength:(NSInteger)length totalLength:(NSInteger)total;

- (void)downloadDidFinishForID:(NSInteger)count totalItem:(NSInteger)totalItem path:(NSString *)path;

- (void)downloadQueneFinished;

@end

@interface DownloadList : NSObject <DownloadItemDelegate>

@property NSInteger currentDownloading;
@property NSMutableArray *downloadQuene;

@property id<DownloadQueneDelegate> downloadQueneDelegate;

- (id)init:(id<DownloadQueneDelegate>)delegate;
- (void)addDownloadItem:(DownloadItem *)downloadItem;
- (void)startDownloadQuene;

@end
