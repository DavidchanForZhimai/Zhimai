//
//  MP3PlayerManager.h
//  Lebao
//
//  Created by adnim on 16/7/19.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MP3PlayerManager : NSObject<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//播放器
@property(nonatomic,copy) NSString *url;
- (BOOL)canRecord;
+ (MP3PlayerManager *)shareInstance;
//
- (void)audioRecorderWithURl:(NSString *)url;
- (void)stopAudioRecorder;
- (void)removeAudioRecorder;
- (void)stopPlayer;
- (void)audioPlayerWithURl:(NSString *)url;
@end
