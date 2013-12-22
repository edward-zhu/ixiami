//
//  MusicData.m
//  iXiami
//
//  Created by 祝 嘉栋 on 13-8-30.
//  Copyright (c) 2013年 祝 嘉栋. All rights reserved.
//

#import "MusicData.h"

@implementation MusicData

@synthesize MD_ID;
@synthesize MD_Artist;
@synthesize MD_Title;
@synthesize MD_Album;
@synthesize MD_AlbumArtist;
@synthesize MD_AlbumArtwork;
@synthesize MD_Track;
@synthesize MD_DiscSerial;
@synthesize MD_Lyric;
@synthesize MD_Composer;
@synthesize MD_HQURL;
@synthesize MD_URL;
@synthesize MD_STATUS;
@synthesize MD_Path;
@synthesize MD_AlbumArtworkFilePath;
// @synthesize MD_AlbumArtworkImage;



- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    MD_ID = [dic objectForKey:@"song_id"];
    MD_Artist = [dic objectForKey:@"singers"];
    MD_AlbumArtist = [dic objectForKey:@"artist_name"];
    MD_AlbumArtwork = [dic objectForKey:@"album_logo"];
    MD_Album = [dic objectForKey:@"title"];
    MD_Track = [dic objectForKey:@"track"];
    MD_Composer = [dic objectForKey:@"composer"];
    MD_Lyric = [dic objectForKey:@"lyric"];
    MD_DiscSerial = [dic objectForKey:@"cd_serial"];
    MD_Title = [dic objectForKey:@"name"];
    MD_URL = [dic objectForKey:@"location"];
    
    return self;
}

+ (MusicData *)MusicDataFromDictionary:(NSDictionary *)dic
{
    MusicData *musicData = [[MusicData alloc] initWithDictionary:dic];
    
    return musicData;
}

-(void)completeDownloadURL2
{
    NSString *str = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://5istar.net/xiami/?sid=%@", MD_ID]] encoding:NSUTF8StringEncoding error:nil];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<br/>(.*)<br/>" options:NSRegularExpressionCaseInsensitive error:nil];
    NSLog(@"%@",str);
    NSString *url;
    for (NSTextCheckingResult *result in [regex matchesInString:str options:0 range:NSMakeRange(0, [str length])]) {
        NSLog(@"%ld %ld", [result range].location, [result range].length);
        url = [str substringWithRange:[result range]];
        url = [url substringWithRange:NSMakeRange(5, [url length] - 10)];
    }
    
    self.MD_URL = url;
}

-(void)completeDownloadURL
{
    NSError *error =  nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.xiami.com/song/gethqsong/sid/%@",self.MD_ID]] cachePolicy:0 timeoutInterval:10.0];
    
    NSHTTPURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    self.MD_HQURL = [URLDecodeHelper convertURL:[jsonDic objectForKey:@"location"]];
}

-(NSString *)getFileName
{
    NSString *fileName;
    fileName = [[[MD_Artist stringByAppendingString:@" - "]
                 stringByAppendingString:MD_Title]
                stringByAppendingString:@".mp3"];
    
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@" "];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"\\" withString:@" "];
    
    NSLog(@"Filename = %@", fileName);
    
    return fileName;
}

-(void)getLyric
{
    NSLog(@"%@", MD_Lyric);
    NSError *error = nil;
    if ([MD_Lyric length]) {
        MD_Lyric = [NSString stringWithContentsOfURL:[NSURL URLWithString:MD_Lyric] encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"%@", MD_Lyric);
    }
}

- (void)getArtwork
{
    if ([MD_AlbumArtwork length]) {
        MD_AlbumArtwork = [MD_AlbumArtwork stringByReplacingOccurrencesOfString:@"_2.jpg" withString:@".jpg"];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:MD_AlbumArtwork]];
        MD_AlbumArtworkFilePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Music/xiami"] stringByAppendingPathComponent:[MD_ID stringByAppendingString:@".jpg"]];
        [data writeToFile:MD_AlbumArtworkFilePath atomically:YES];
    }
}

- (void)printMusicInfo
{
    NSLog(@"Title %@", MD_Title);
    NSLog(@"Artist %@", MD_Artist);
    NSLog(@"Composer %@", MD_Composer);
    NSLog(@"Album %@", MD_Album);
}

- (void)writeID3
{
    
    
    [self printMusicInfo];
    TagAPI *tag = [[TagAPI alloc] initWithPath:MD_Path genreDictionary:nil];
    if ([MD_Title length]) {
        [tag setTitle:MD_Title];
    }
    NSLog(@"Title sat");
    if ([MD_Album length]) {
        [tag setAlbum:MD_Album];
    }
    NSLog(@"Album sat");
    if ([MD_Composer isKindOfClass:[NSString class]]) {
        if ([MD_Composer length] > 2) {
            [tag setComposer:MD_Composer];
            NSLog(@"Composer: %@", MD_Composer);
        }
    }
    NSLog(@"Composer Set");
    if ([MD_Track length]) {
        [tag setTrack:(int)[MD_Track integerValue] totalTracks:0];
    }
    NSLog(@"Track Set");
    if ([MD_Artist length]) {
        [tag setArtist:MD_Artist];
    }
    NSLog(@"Artist Set");
    [tag updateFile];
    
    [self writeAlbumArt];
    
    
}

- (void)writeAlbumArt
{
    [CoverArtWriter writeCoverArt:MD_Path withPicture:MD_AlbumArtworkFilePath];
}


@end
