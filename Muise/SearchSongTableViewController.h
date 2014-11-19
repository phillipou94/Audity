//
//  SearchSongTableViewController.h
//  Muise
//
//  Created by Phillip Ou on 10/3/14.
//  Copyright (c) 2014 Phillip Ou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MusicTableViewCell.h"

@interface SearchSongTableViewController : UITableViewController<UISearchBarDelegate,MusicCellDelegate>
@property PFObject *playList;
@end
