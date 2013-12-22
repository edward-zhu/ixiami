//
//  MusicData.h
//  iXiami
//
//  Created by 祝 嘉栋 on 13-8-30.
//  Copyright (c) 2013年 祝 嘉栋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLDecodeHelper.h"
#import <ID3/TagAPI.h>
#import "CoverArtWriter.h"

@interface MusicData : NSObject

@property NSString *MD_ID;              // Song ID
@property NSString *MD_Artist;          // 曲目艺人
@property NSString *MD_Title;           // 曲目
@property NSString *MD_Album;           // 专辑
@property NSString *MD_AlbumArtist;     // 专辑艺人
@property NSString *MD_AlbumArtwork;    // 专辑封面
@property NSString *MD_Track;           // 轨道编号
@property NSString *MD_DiscSerial;      // 光盘编号
@property NSString *MD_Lyric;           // 歌词
@property NSString *MD_Composer;        // 作曲家
@property NSString *MD_HQURL;           // 高音质版下载地址
@property NSString *MD_URL;             // 低音质版下载地址
@property NSString *MD_Path;
@property NSString *MD_AlbumArtworkFilePath;

// @property NSImage *MD_AlbumArtworkImage;

@property NSString *MD_STATUS;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (MusicData *)MusicDataFromDictionary:(NSDictionary *)dic;

-(void)completeDownloadURL;
-(void)completeDownloadURL2;

-(NSString *)getFileName;
- (void)getLyric;
- (void)getArtwork;

- (void)printMusicInfo;
- (void)writeID3;
- (void)writeAlbumArt;

@end