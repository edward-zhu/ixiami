//
//  MusicDataList.h
//  iXiami
//
//  Created by 祝 嘉栋 on 13-8-30.
//  Copyright (c) 2013年 祝 嘉栋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicData.h"
#import "DownloadItem.h"
#import "DownloadList.h"

@protocol MusicDataListDelegate <NSObject>

-(void)singleMusicInfoDidRetrive:(MusicData *)md total:(NSInteger)total;
-(void)musicInfoListRetriveDidFinish;
-(void)singleMusicURLDidRetrive:(NSInteger)num total:(NSInteger)total;
-(void)URLRetriveDidFinish;
-(void)simpleMessage:(NSString *)str;
-(void)simpleMessage:(NSString *)str num:(NSUInteger)num total:(NSUInteger)total;

@end

@interface MusicDataList : NSObject

@property NSString *uid;
@property NSMutableArray *dataList;
@property id <MusicDataListDelegate> musicDataListDelegate;

-(void)fetchURL;
-(void)refreshArrayController:(NSArrayController *)arrayController;
-(void)downloadAll:(id<DownloadQueneDelegate>)downloadQueneDelegate;

- (void)fetchAllMusicInfo;
- (NSUInteger)fetchMusicInfoInPage:(NSString *)page;

- (void)fetchLyric;
- (void)fetchArtwork;

@end
