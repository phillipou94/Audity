//
//  GlobalFeed.m
//  Muise
//
//  Created by Phillip Ou on 10/3/14.
//  Copyright (c) 2014 Phillip Ou. All rights reserved.
//

#import "GlobalFeed.h"
#import "SearchSongTableViewController.h"
#import "ShowPlaylistTableViewcontroller.h"

@interface GlobalFeed (){
    PFObject *selectedPlaylist;
}

@end

@implementation GlobalFeed


- (void)viewWillAppear:(BOOL)animated {
    [super viewDidLoad];
    self.parseClassName = @"Playlist";
    self.view.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    //[self.view setTintColor:[UIColor colorWithRed:69/255.0 green:173/255.0 blue:162/255.0 alpha:1]];
    self.navigationController.navigationBar.translucent=NO;
    self.navigationController.navigationBar.barTintColor= [UIColor colorWithRed:69/255.0 green:173/255.0 blue:162/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Hero" size:21],
      NSFontAttributeName, nil]];
    [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:69/255.0 green:173/255.0 blue:162/255.0 alpha:1]];
    
    UIWindow* mWindow = [[UIApplication sharedApplication] keyWindow]; mWindow.tintColor = [UIColor blackColor];
    [self.tableView reloadData];
    
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
-(PFQuery *) queryForTable{
    NSLog(@"log");
    PFQuery *query = [PFQuery queryWithClassName:@"Playlist"];
    [query orderByDescending:@"createdAt"];
    return query;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.objects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewCell" forIndexPath:indexPath];
    
    PFObject *playList = [self.objects objectAtIndex:indexPath.row];
    
    cell.textLabel.text = playList[@"title"];
    cell.textLabel.textColor=[UIColor colorWithRed:69/255.0 green:173/255.0 blue:162/255.0 alpha:1];
    cell.textLabel.font = [UIFont fontWithName:@"Hero" size:20];
    cell.detailTextLabel.text = playList[@"description"];
    cell.detailTextLabel.textColor=[UIColor whiteColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedPlaylist = [self.objects objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showPlaylist" sender:self];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showPlaylist"]) {
        ShowPlaylistTableViewController *other = [segue destinationViewController];
        other.playList= selectedPlaylist;
        
    }

    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
