//
//  MusicDataList.m
//  iXiami
//
//  Created by 祝 嘉栋 on 13-8-30.
//  Copyright (c) 2013年 祝 嘉栋. All rights reserved.
//

#import "MusicDataList.h"

@implementation MusicDataList

@synthesize musicDataListDelegate;
@synthesize uid;
@synthesize dataList;

-(void)fetchURL
{
    NSInteger num = 1;
    for (MusicData *md in self.dataList) {
        [NSThread sleepForTimeInterval:2.0];
        [md completeDownloadURL];
        NSLog(@"%@", md.MD_HQURL);
        [self.musicDataListDelegate singleMusicURLDidRetrive:num++ total:[self.dataList count]];
    }
    
    [self.musicDataListDelegate URLRetriveDidFinish];
}

- (void)fetchAllMusicInfo
{
    NSUInteger page = 1;
    while ([self fetchMusicInfoInPage:[NSString stringWithFormat:@"%ld", page++]]);
    NSLog(@"Retrived %ld PAGES and %ld Musics", page - 1, [dataList count]);
    
    [self.musicDataListDelegate musicInfoListRetriveDidFinish];
}

- (NSUInteger)fetchMusicInfoInPage:(NSString *)page
{
    [NSThread sleepForTimeInterval:2.0];
    // 1 Create Request
    NSString * urlStr = [NSString stringWithFormat:@"http://www.xiami.com/app/android/lib-songs?uid=%@&page=%@", [self uid], page];
    NSLog(@"urlStr = %@", urlStr);
    NSURL * url = [NSURL URLWithString: urlStr];
    NSURLRequest * request = [NSURLRequest
                              requestWithURL:url
                              cachePolicy:NSURLCacheStorageAllowed
                              timeoutInterval:10.0];
    
    // 2 Create Connection and Receive Data
    NSError * error = nil;
    NSHTTPURLResponse * response = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *pageSource = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"\n%@\n%ld", pageSource, [pageSource length]);
    
    if ([pageSource length] <= 30) {
        return 0;
    }
    
    // 3 Read Data
    NSJSONSerialization * json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingAllowFragments
                                  error:&error];
    NSArray * result = nil;
    result = [json mutableArrayValueForKey:@"songs"];
    
    

    
    // 4 Append Data to the Array
    for (NSDictionary * song in result) {
        MusicData *md = [MusicData MusicDataFromDictionary:song];
        [dataList addObject:md];
        [self.musicDataListDelegate singleMusicInfoDidRetrive:md total:[self.dataList count]];
    }
    
    return [result count];
}

-(void)refreshArrayController:(NSArrayController *)arrayController
{
    [[arrayController content] removeAllObjects];
    [arrayController addObjects:self.dataList];
}

-(void)downloadAll:(id<DownloadQueneDelegate>)downloadQueneDelegate
{
    DownloadList *downloadList = [[DownloadList alloc] init:downloadQueneDelegate];
    NSString *url;

    for (MusicData* md in dataList) {
        
        if ([md.MD_HQURL length]) {
            url = md.MD_HQURL;
        }
        else {
            url = md.MD_URL;
        }
        
        [downloadList addDownloadItem:[DownloadItem downloadItemWithURL:url filename:[md getFileName] delegate:downloadList]];
    }
    [downloadList startDownloadQuene];
}

- (void)fetchLyric
{
    NSUInteger i = 0;
    for (MusicData *md in dataList) {
        [NSThread sleepForTimeInterval:2.0];
        [md getLyric];
        [musicDataListDelegate simpleMessage:[NSString stringWithFormat:@"正在下载歌词数据... (%ld / %ld)", i, [dataList count]] num:i total:[dataList count]];
        i++;
    }
}

- (void)fetchArtwork
{
    NSUInteger i = 0;
    for (MusicData *md in dataList) {
        [NSThread sleepForTimeInterval:2.0];
        [md getArtwork];
        [musicDataListDelegate simpleMessage:[NSString stringWithFormat:@"正在下载封面数据... (%ld / %ld)", i, [dataList count]] num:i total:[dataList count]];
        i++;
    }
}



@end
