//
//  MusicTableViewCell.h
//  Muise
//
//  Created by Phillip Ou on 10/3/14.
//  Copyright (c) 2014 Phillip Ou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Parse/Parse.h>
#import "Song.h"

@protocol MusicCellDelegate
-(void) songAdded: (Song*)song;
@end

@interface MusicTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *songTitle;
@property (strong, nonatomic) IBOutlet UILabel *artist;
@property (strong,nonatomic) NSString *cellURL;
@property (strong,nonatomic) AVPlayer *player;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong,nonatomic) NSString *imageURL;
@property (strong, nonatomic) IBOutlet PFImageView *thumbnail;
@property (retain) id <MusicCellDelegate> delegate;
@property (strong, nonatomic) Song *song;

@end
