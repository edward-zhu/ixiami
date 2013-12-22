//
//  DownloadItem.m
//  iXiami
//
//  Created by 祝 嘉栋 on 13-9-1.
//  Copyright (c) 2013年 祝 嘉栋. All rights reserved.
//

#import "DownloadItem.h"

@implementation DownloadItem

@synthesize DI_URL;
@synthesize DI_Filename;
@synthesize DI_Path;
@synthesize downloadResponse;
@synthesize bytesReceived;
@synthesize downloadItemDelegate;

- (id)init
{
    self = [super init];
    self.downloadResponse = [[NSURLResponse alloc] init];
    
    return self;
}

- (id)initDownloadwithURL:(NSString *)url filename:(NSString *)filename delegate:(id <DownloadItemDelegate>)delegate
{
    self = [super init];
    downloadItemDelegate = delegate;
    DI_URL = url;
    DI_Filename = filename;
    return self;
}

+ (DownloadItem *)downloadItemWithURL:(NSString *)url filename:(NSString *)filename delegate:(id <DownloadItemDelegate>)delegate;
{
    return [[DownloadItem alloc] initDownloadwithURL:url filename:filename delegate:delegate];
}

- (void)startDownload
{
    [NSThread sleepForTimeInterval:2.0];
    NSURLRequest *request =
        [NSURLRequest requestWithURL:[NSURL URLWithString:DI_URL]
                         cachePolicy:0
                     timeoutInterval:60.0];
    NSURLDownload *download = [[NSURLDownload alloc] initWithRequest:request delegate:self];
    bytesReceived = 0;
    
    if (!download) {
        NSLog(@"Download Starting Failed.");
    }
    else {
        NSLog(@"Download Started Completedly %@", DI_URL);
    }
}

- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error
{
    NSLog(@"Download failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)download:(NSURLDownload *)download decideDestinationWithSuggestedFilename:(NSString *)filename
{
    NSString *destFileName;
    NSString *homeDirectory = NSHomeDirectory();
    
    NSLog(@"Suggested Filename: %@", filename);
    
    destFileName = [[homeDirectory stringByAppendingPathComponent:@"Music/xiami"] stringByAppendingPathComponent:DI_Filename];
    [download setDestination:destFileName allowOverwrite:YES];
    
    NSLog(@"Destination: %@", destFileName);
}

- (void)download:(NSURLDownload *)download didCreateDestination:(NSString *)path
{
    DI_Path = path;
}

- (void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)response
{
    downloadResponse = response;
    NSLog(@"get Reponse");
}

- (void)download:(NSURLDownload *)download didReceiveDataOfLength:(NSUInteger)length
{
    long long expectedLength = [self.downloadResponse expectedContentLength];
    bytesReceived += length;
    // NSLog(@"get Data");
    [downloadItemDelegate didReceiveData:self ofLength:bytesReceived total:expectedLength];
    
}


- (void)downloadDidFinish:(NSURLDownload *)download
{
    [downloadItemDelegate downloadDidFinish:self];
}

@end
