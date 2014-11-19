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
        NSString *songURL = dic[@"previewUrl"];
        //NSLog(@"%@",songURL);
        NSString *songTitle = dic[@"trackName"];
        NSLog(@"%@",songTitle);
        
    }
    
    [self.tableView reloadData];

    // Do the search...
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    PFObject *song = [PFObject objectWithClassName:@"Songs" ];
    NSDictionary *songDic = self.searchResults[indexPath.row];
    NSString *songTitle= [songDic objectForKey:@"trackName"];
    NSString *artistName = [songDic objectForKey:@"artistName"];
    NSString *previewUrl = [songDic objectForKey:@"previewUrl"];
    NSString *downloadUrl = [songDic objectForKey:@"trackViewUrl"];
    
    [song setObject:songTitle forKey:@"songTitle"];
    [song setObject:artistName forKey:@"artistName"];
    [song setObject:previewUrl forKey:@"previewUrl"];
    [song setObject:self.playList.objectId forKey:@"playListID"];
    [song setObject: songDic[@"artworkUrl100"] forKey:@"artworkUrl100"];
    [song setObject:downloadUrl forKey:@"downloadUrl"];
    [song saveInBackground];
    
    [self performSegueWithIdentifier:@"showPlaylist" sender:self];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showPlaylist"]){
        ShowPlaylistTableViewController *other = [segue destinationViewController];
        other.playList=self.playList;
        [other.tableView reloadData];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
