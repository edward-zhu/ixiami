//
//  AppDelegate.h
//  iXiami
//
//  Created by 祝 嘉栋 on 13-8-30.
//  Copyright (c) 2013年 祝 嘉栋. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MusicDataList.h"
#import "MusicData.h"
#import "XiamiLogin.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, MusicDataListDelegate, DownloadQueneDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;


@property (weak) IBOutlet NSButton *startButton;
@property (weak) IBOutlet NSTextField *userIdTextField;
@property (weak) IBOutlet NSTextField *infoLabel;

@property (weak) IBOutlet NSArrayController *arrayController;
@property (weak) IBOutlet NSTextField *emailTextField;
@property (weak) IBOutlet NSTextField *passwordTextField;
@property (weak) IBOutlet NSTextField *loginInfo;

@property NSString * member_auth;



@property MusicDataList *musicDataList;
@property NSOperationQueue *opQuene;

- (IBAction)startProcess:(id)sender;
-(void)fetchProcess;
-(void)downloadProcess;

- (IBAction)login:(id)sender;

@end
