//
//  CoverArtWriter.m
//  iXiami
//
//  Created by 祝 嘉栋 on 13-9-19.
//  Copyright (c) 2013年 祝 嘉栋. All rights reserved.
//

#import     "CoverArtWriter.h"
#import     <TagLib/TagLib.h>
#import     <TagLib/tag.h>
#import     <TagLib/taglib.h>
#import     <TagLib/fileref.h>
#include    <TagLib/tbytevector.h>//ByteVector
#include    <TagLib/mpegfile.h>//mp3 file
#include    <TagLib/id3v2tag.h>//tag
#include    <TagLib/id3v2frame.h>//frame
#include    <TagLib/attachedpictureframe.h>

@implementation CoverArtWriter

+(void)writeCoverArt:(NSString *)audioFile withPicture:(NSString *)picPath
{
    TagLib::MPEG::File file([audioFile UTF8String]);
    NSData *albumArt = [NSData dataWithContentsOfFile:picPath];
    TagLib::ByteVector bv = TagLib::ByteVector((const char*)[albumArt bytes], (unsigned int)[albumArt length]);
    TagLib::ID3v2::Tag *tag = file.ID3v2Tag();
    TagLib::ID3v2::AttachedPictureFrame *frame = new TagLib::ID3v2::AttachedPictureFrame;
    
    frame->setMimeType("image/jpeg");
    frame->setPicture(bv);
    tag->addFrame(frame);
    file.save();
}

@end
