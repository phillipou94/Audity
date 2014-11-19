//
//  ShowPlaylistTableViewController.m
//  Muise
//
//  Created by Phillip Ou on 10/4/14.
//  Copyright (c) 2014 Phillip Ou. All rights reserved.
//

#import "ShowPlaylistTableViewController.h"
#import "MusicTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "SearchSongTableViewController.h"
#import "PlaySongViewController.h"

@interface ShowPlaylistTableViewController ()
@property (strong,nonatomic) AVPlayer *player;
@property (strong, nonatomic) IBOutlet UIView *view;


@end

@implementation ShowPlaylistTableViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.selectedSong = [[Song alloc]init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.parseClassName=@"Songs";
    UINib *customNibCell = [UINib nibWithNibName:@"MusicTableViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:customNibCell forCellReuseIdentifier:@"CustomCell"];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.descriptionTextView.text = self.playList[@"description"];
    self.titleLabel.text = self.playList[@"title"];
    self.nameLabel.text = self.playList[@"createdByName"];
    self.view.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.navigationController.navigationBar.translucent=NO;
    self.navigationController.navigationBar.barTintColor= [UIColor colorWithRed:69/255.0 green:173/255.0 blue:162/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Hero" size:21],
      NSFontAttributeName, nil]];
    self.tabBarController.tabBar.hidden=YES;
    
    [self.tableView reloadData];

}
-(PFQuery *) queryForTable{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Songs"];
    [query whereKey:@"playListID" equalTo:self.playList.objectId];
    return query;
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.objects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    PFObject *song = self.objects[indexPath.row];
    cell.songTitle.text = [song objectForKey:@"songTitle"];
    cell.songTitle.font=[UIFont fontWithName:@"Hero" size:20];
    cell.artist.text = [song objectForKey:@"artistName"];
    cell.artist.font=[UIFont fontWithName:@"Hero-Light" size:15];
    cell.cellURL = [song objectForKey:@"previewUrl"];
    cell.imageURL=[song objectForKey:@"artworkUrl100"];
    if(self.fromYouTableView){
        cell.addButton.hidden=YES;
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PFObject *song = self.objects[indexPath.row];
    self.selectedSong.index = (int) indexPath.row;
    NSLog(@"selectedSong: %@",song);
    self.selectedSong.title =[song objectForKey:@"songTitle"];
    self.selectedSong.artist =[song objectForKey:@"artistName"];
    self.selectedSong.url= [song objectForKey:@"previewUrl"];
    self.selectedSong.imageUrl =[song objectForKey:@"artworkUrl100"];
    [self performSegueWithIdentifier:@"playSong" sender:self];
    
}


- (IBAction)addSongs:(id)sender {
    [self performSegueWithIdentifier:@"takeToSearch" sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"takeToSearch"]) {
        
        SearchSongTableViewController *other = [segue destinationViewController];
        other.playList= self.playList;
        
    }
    else if([segue.identifier isEqualToString:@"playSong"]){
        PlaySongViewController *other = [segue destinationViewController];
        other.song = self.selectedSong;
        other.playList = [self.objects mutableCopy];
        
    }
    
             
}

    


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //NSLog(@"deleting");
        PFObject *objectToDelete = self.objects[indexPath.row];
        
        NSString *downloadUrl=objectToDelete[@"downloadUrl"];
        
        //[objectToDelete deleteInBackground];
        //[self loadObjects];
        
        //add code here for when you hit delete
        
    }
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Download" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        
                                        PFObject *object = self.objects[indexPath.row];
                                        NSString *downloadUrl=object[@"downloadUrl"];
                                        NSLog(@"download%@",downloadUrl);
                                        NSURL *url = [NSURL URLWithString:downloadUrl];
                                        
                                        if (![[UIApplication sharedApplication] openURL:url]) {
                                            NSLog(@"%@%@",@"Failed to open url:",[url description]);
                                        }

                                        
                                        
                                    }];
    button.backgroundColor = [UIColor colorWithRed:69/255.0 green:173/255.0 blue:162/255.0 alpha:1]; //arbitrary color
    
    return @[button];
}
@end
