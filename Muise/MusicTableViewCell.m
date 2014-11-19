//
//  MusicTableViewCell.m
//  Muise
//
//  Created by Phillip Ou on 10/3/14.
//  Copyright (c) 2014 Phillip Ou. All rights reserved.
//

#import "MusicTableViewCell.h"
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>




@implementation MusicTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //get a dispatch queue
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //this will start the image loading in bg
    dispatch_async(concurrentQueue, ^{
        NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.imageURL]];
        
        //this will set the image when loading is finished
        dispatch_async(dispatch_get_main_queue(), ^{
            self.thumbnail.image = [UIImage imageWithData:image];
        });
    });
    self.songTitle.adjustsFontSizeToFitWidth=YES;
    self.song = [[Song alloc]init];
    [self.thumbnail loadInBackground];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    NSLog(@"%@",self.imageURL);
    self.thumbnail.image =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]]];
}


    // Configure the view for the selected state

- (IBAction)playButton:(id)sender {
    
    NSURL *songurl = [NSURL URLWithString:self.cellURL];
    NSLog(@"%@",self.cellURL);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player];
    
    self.player = [AVPlayer playerWithURL:songurl];
    if(!self.playButton.selected){
        [self.player play];
        [self.playButton setSelected:YES];
    }
    else{
        [self.player pause];
        [self.playButton setSelected:NO];
    }
    
}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    
    NSLog(@"done");
    [self.playButton setSelected:NO];
}

- (IBAction)addSong:(id)sender {
    NSLog(@"clicked");
    self.song.url=self.cellURL;
    self.song.title=self.songTitle.text;
    self.song.imageUrl = self.imageURL;
    self.song.artist=self.artist.text;
    NSLog(@"%@",self.song);
    [self.delegate songAdded:self.song];
}



@end
