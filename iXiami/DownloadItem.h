//
//  DownloadItem.h
//  iXiami
//
//  Created by 祝 嘉栋 on 13-9-1.
//  Copyright (c) 2013年 祝 嘉栋. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloadItemDelegate;

@interface DownloadItem : NSObject <NSURLDownloadDelegate>

@property NSString *DI_URL;
@property NSString *DI_Filename;
@property NSString *DI_Path;
@property NSURLResponse *downloadResponse;
@property long long bytesReceived;

@property id<DownloadItemDelegate> downloadItemDelegate;

- (id)initDownloadwithURL:(NSString *)url filename:(NSString *)filename delegate:(id <DownloadItemDelegate>)delegate;
+ (DownloadItem *)downloadItemWithURL:(NSString *)url filename:(NSString *)filename delegate:(id <DownloadItemDelegate>)delegate;
- (void)startDownload;

@end

@protocol DownloadItemDelegate <NSObject>

- (void)didReceiveData:(DownloadItem*)download ofLength:(NSUInteger)length total:(NSUInteger)totalLength;
- (void)downloadDidFinish:(DownloadItem *)downloadItem;

@end
