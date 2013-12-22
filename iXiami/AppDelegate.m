//
//  AppDelegate.m
//  iXiami
//
//  Created by 祝 嘉栋 on 13-8-30.
//  Copyright (c) 2013年 祝 嘉栋. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize musicDataList;
@synthesize arrayController;
@synthesize opQuene;
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize loginInfo;

@synthesize member_auth;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    musicDataList = [[MusicDataList alloc] init];
    musicDataList.dataList  = [[NSMutableArray alloc] init];
    musicDataList.musicDataListDelegate = self;
    opQuene = [[NSOperationQueue alloc] init];
    [opQuene setMaxConcurrentOperationCount:1];
    [XiamiLogin clearCookies];
}

- (IBAction)startProcess:(id)sender {
    // [self.infoLabel setStringValue:@"Hello !"];
    
    musicDataList.uid = [self.userIdTextField stringValue];
    NSLog(@"%@", [self.userIdTextField stringValue]);
    [self.progressIndicator startAnimation:self];
    [self.infoLabel setStringValue:@"正在获取音乐列表..."];
    NSInvocationOperation *io =
        [[NSInvocationOperation alloc]
         initWithTarget:self
         selector:@selector(fetchProcess)
         object:nil];
    
    [opQuene addOperation:io];
    
    
    // [self fetchProcess];
}

- (void)fetchProcess
{
    NSLog(@"正在获取音乐信息..");
    [musicDataList fetchAllMusicInfo];
    if ([member_auth length]) {
        [musicDataList fetchURL];
    }
    [musicDataList fetchArtwork];
    [self performSelectorOnMainThread:@selector(downloadProcess)
                           withObject:nil
                        waitUntilDone:YES];
    // [opQuene cancelAllOperations];
    
}

- (void)downloadProcess
{
    [musicDataList downloadAll:self];
}

- (IBAction)login:(id)sender {
    member_auth = [XiamiLogin xiamiLoginWithEmail:[emailTextField stringValue]
                                         password:[passwordTextField stringValue]];
    if (![member_auth isEqualToString:@"Failed"])
    {
        [loginInfo setStringValue:[NSString stringWithFormat:@"已登陆 member_auth: %@", member_auth]];
        [loginInfo setTextColor:[NSColor greenColor]];
    }
    else
    {
        [loginInfo setStringValue:@"登录失败，请重试。"];
        member_auth = @"";
    }
    
}

- (void)singleMusicInfoDidRetrive:(MusicData *)md total:(NSInteger)total
{
    [self.infoLabel setStringValue:[NSString stringWithFormat:@"已获取歌曲 %@ - %@ ... (# %ld)", md.MD_Artist, md.MD_Title, total]];
    [self.musicDataList refreshArrayController:self.arrayController];
}

-(void)musicInfoListRetriveDidFinish
{
    [self.progressIndicator setIndeterminate:YES];
    // [self.progressIndicator stopAnimation:self];
    [self.infoLabel setStringValue:@"音乐文件信息获取完成。"];
}

-(void)singleMusicURLDidRetrive:(NSInteger)num total:(NSInteger)total
{
    [self.infoLabel setStringValue:[NSString stringWithFormat:@"正在获取高质量音乐下载地址(%ld / %ld)...", num, total]];
    [self.progressIndicator setDoubleValue:100.0f * num / total];
}

-(void)URLRetriveDidFinish
{
    // [self.progressIndicator stopAnimation:self];
    [self.progressIndicator setIndeterminate:YES];
    [self.infoLabel setStringValue:@"高质量下载地址解析完成！"];
}

- (void)didReceiveDataOfID:(NSInteger)count totalItem:(NSInteger)totalItem receivedLength:(NSInteger)length totalLength:(NSInteger)total
{
    NSString *iStr = [NSString stringWithFormat:@"正在下载文件#%ld.. (%ld Bytes / %ld Bytes)", count, length, total];
    //NSLog(@"%@", iStr);
    [self.infoLabel setStringValue:iStr];
    [self.progressIndicator setIndeterminate:NO];
    [self.progressIndicator setDoubleValue:100.0f * length / total];
    
}

- (void)downloadDidFinishForID:(NSInteger)count totalItem:(NSInteger)totalItem path:(NSString *)path
{
    NSLog(@"#%ld Downloading Finished", count);
    [self.infoLabel setStringValue:[NSString stringWithFormat:@"#%ld 文件下载完成.", count]];
    MusicData *md = [musicDataList.dataList objectAtIndex:count];
    md.MD_Path = path;
    [md writeID3];
}

- (void)downloadQueneFinished
{
    NSLog(@"All Item Downloaded");
    [self.infoLabel setStringValue:@"所有文件下载完成."];
}

- (void)simpleMessage:(NSString *)str
{
    [self.infoLabel setStringValue:str];
}

- (void)simpleMessage:(NSString *)str num:(NSUInteger)num total:(NSUInteger)total
{
    [self.infoLabel setStringValue:str];
    [self.progressIndicator setIndeterminate:NO];
    [self.progressIndicator setDoubleValue:100 * num / total];
}

@end
