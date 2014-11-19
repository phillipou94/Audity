//
//  PlaySongViewController.h
//  Muise
//
//  Created by Phillip Ou on 10/9/14.
//  Copyright (c) 2014 Phillip Ou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import <AVFoundation/AVFoundation.h>

@interface PlaySongViewController : UIViewController
@property (strong,nonatomic) Song *song;
@property (strong,nonatomic) NSMutableArray *playList;
@property (strong,nonatomic) AVPlayer *player;

@end
