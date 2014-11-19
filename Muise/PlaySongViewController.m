//
//  PlaySongViewController.m
//  Muise
//
//  Created by Phillip Ou on 10/9/14.
//  Copyright (c) 2014 Phillip Ou. All rights reserved.
//

#import "PlaySongViewController.h"

@interface PlaySongViewController ()
@property (strong, nonatomic) IBOutlet UILabel *songNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) Song *songPlaying;

@end

@implementation PlaySongViewController{
    int index;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"songTitle:%@",self.song.title);
    self.songNameLabel.text = self.song.title;
    self.artistTitleLabel.text = self.song.artist;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.song.imageUrl]];
    self.imageView.image = [UIImage imageWithData:data];
    self.songPlaying=self.song;
    
    self.player = [AVPlayer playerWithURL:[NSURL  URLWithString:self.songPlaying.url ]];
    [self.player play];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playSong:(id)sender {
    
    NSURL *songurl = [NSURL URLWithString:self.songPlaying.url];
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
    
    [self.playButton setSelected:NO];
}

- (IBAction)next:(id)sender {
    index+=1;
    if(index <[self.playList count]){
        NSDictionary *song = [self.playList objectAtIndex:index];
        self.songPlaying.title = [song objectForKey:@"songTitle"];
        self.songPlaying.artist = [song objectForKey:@"artistName"];
        self.songPlaying.url = [song objectForKey:@"previewUrl"];
        self.songPlaying.imageUrl=[song objectForKey:@"artworkUrl100"];
        self.songPlaying.index +=1;
    }
    
    [self viewDidLoad];
}

- (IBAction)previous:(id)sender {
    
    index-=1;
    if(index >=0){
        NSDictionary *song = [self.playList objectAtIndex:index];
        self.songPlaying.title = [song objectForKey:@"songTitle"];
        self.songPlaying.artist = [song objectForKey:@"artistName"];
        self.songPlaying.url = [song objectForKey:@"previewUrl"];
        self.songPlaying.imageUrl=[song objectForKey:@"artworkUrl100"];
        self.songPlaying.index -=1;
       
        
    }
    
    [self viewDidLoad];
}

@end
