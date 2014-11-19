//
//  ShowPlaylistTableViewController.h
//  Muise
//
//  Created by Phillip Ou on 10/4/14.
//  Copyright (c) 2014 Phillip Ou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Song.h"

@interface ShowPlaylistTableViewController : PFQueryTableViewController
@property (nonatomic, strong) PFObject *playList;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (nonatomic,strong) NSMutableArray *arrayOfSongs;
@property BOOL fromYouTableView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) Song *selectedSong;

@end
