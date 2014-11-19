//
//  MusicTableViewCell.m
//  Muise
//
//  Created by Phillip Ou on 10/3/14.
//  Copyright (c) 2014 Phillip Ou. All rights reserved.
//

#import "MusicTableViewCell.h"
#import <Parse/Parse.h>

@implementation MusicTableViewCell

- (void)awakeFromNib {
    // Initialization code
    NSLog(@"loading image");
    
    self.thumbnail.image =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]]];
    self.songTitle.adjustsFontSizeToFitWidth=YES;
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


@end
