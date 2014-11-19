//
//  SearchSongTableViewController.m
//  Muise
//
//  Created by Phillip Ou on 10/3/14.
//  Copyright (c) 2014 Phillip Ou. All rights reserved.
//

#import "SearchSongTableViewController.h"
#import "MusicTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import <Parse/Parse.h>
#import "ShowPlaylistTableViewController.h"

@interface SearchSongTableViewController ()
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic) NSMutableArray *searchResults;
@property (strong,nonatomic) AVPlayer *player;

@end

@implementation SearchSongTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title=@"Search";
    UINib *customNibCell = [UINib nibWithNibName:@"MusicTableViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:customNibCell forCellReuseIdentifier:@"CustomCell"];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.searchBar.delegate=self;
    self.view.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.navigationController.navigationBar.translucent=NO;
    self.navigationController.navigationBar.barTintColor= [UIColor colorWithRed:69/255.0 green:173/255.0 blue:162/255.0 alpha:1];
    self.navigationController.navigationItem.title = @"Search Songs";
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Hero" size:21],
      NSFontAttributeName, nil]];
    [self.tableView reloadData];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancel:(id)sender {
    [self.tabBarController setSelectedIndex:0];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    NSLog(@"count:%lu",[self.searchResults count]);
    return [self.searchResults count];
}

- (IBAction)search:(id)sender {
    self.searchResults = [NSMutableArray array];
    NSString *searchTerm = self.searchBar.text;
    
    searchTerm =[searchTerm
                 stringByReplacingOccurrencesOfString:@" " withString:@""];
    searchTerm = [searchTerm lowercaseString];
    
    NSString *str=[NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@",searchTerm];
    NSURL *url=[NSURL URLWithString:str];
    NSData *data=[NSData dataWithContentsOfURL:url];
    NSError *error=nil;
    id response=[NSJSONSerialization JSONObjectWithData:data options:
                 NSJSONReadingMutableContainers error:&error];
    
    for(NSDictionary *dic in [response objectForKey:@"results"]){
        [self.searchResults addObject:dic];
        NSString *songURL = dic[@"previewUrl"];
        //NSLog(@"%@",songURL);
        NSString *songTitle = dic[@"trackName"];
        NSLog(@"%@",songTitle);
        
    }
    
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    
    NSDictionary *song = self.searchResults[indexPath.row];
    cell.songTitle.text = [song objectForKey:@"trackName"];
    cell.artist.text = [song objectForKey:@"artistName"];
    cell.cellURL = [song objectForKey:@"previewUrl"];
    cell.imageURL=[song objectForKey:@"artworkUrl100"];
    [cell.playButton setTag: indexPath.row];
    cell.delegate = self;
    //[cell.playButton addTarget:self action:@selector(playTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // Configure the cell...
    
    return cell;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.searchResults = [NSMutableArray array];
    NSString *searchTerm = self.searchBar.text;
    
    searchTerm =[searchTerm
                 stringByReplacingOccurrencesOfString:@" " withString:@""];
    searchTerm = [searchTerm lowercaseString];
    
    NSString *str=[NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@",searchTerm];
    NSURL *url=[NSURL URLWithString:str];
    NSData *data=[NSData dataWithContentsOfURL:url];
    NSError *error=nil;
    id response=[NSJSONSerialization JSONObjectWithData:data options:
                 NSJSONReadingMutableContainers error:&error];
    
    for(NSDictionary *dic in [response objectForKey:@"results"]){
        [self.searchResults addObject:dic];
        
    }
    
    [self.tableView reloadData];
    

    // Do the search...
}


-(void)songAdded:(Song*) song{
    NSLog(@"Song:%@",song);
    PFObject *songToSave = [PFObject objectWithClassName:@"Songs" ];
    [songToSave setObject:song.title forKey:@"songTitle"];
    [songToSave setObject:song.artist forKey:@"artistName"];
    [songToSave setObject:song.url forKey:@"previewUrl"];
    [songToSave setObject:self.playList.objectId forKey:@"playListID"];
    [songToSave setObject: song.imageUrl forKey:@"artworkUrl100"];
    //[songToSave setObject:downloadUrl forKey:@"downloadUrl"];
    [songToSave saveInBackground];
    [self performSegueWithIdentifier:@"showPlaylist" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showPlaylist"]){
        ShowPlaylistTableViewController *other = [segue destinationViewController];
        other.playList=self.playList;
        [other.tableView reloadData];
    }
}

@end
