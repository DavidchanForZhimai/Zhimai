//
//  MP3PlayerManager.h
//  Lebao
//
//  Created by adnim on 16/7/19.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
typedef void (^AudioPlayerDidFinishPlayingBlock)(AVAudioPlayer *player,BOOL flag);
typedef void (^StartRecoderBlock)(BOOL flag);
@interface MP3PlayerManager : NSObject<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//播放器
@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) AudioPlayerDidFinishPlayingBlock audioPlayerDidFinishPlayingBlock;
@property(nonatomic,copy) StartRecoderBlock startRecoderBlock;
+ (MP3PlayerManager *)shareInstance;
//
- (void)audioRecorderWithURl:(NSString *)url startRecoderBlock:(StartRecoderBlock)startRecoderBlock;
- (void)stopAudioRecorder;
- (void)removeAudioRecorder:(NSString *)url;

- (void)audioPlayerWithURl:(NSString *)url audioPlayerDidFinishPlayingBlock:(AudioPlayerDidFinishPlayingBlock)audioPlayerDidFinishPlayingBlock;
@end
