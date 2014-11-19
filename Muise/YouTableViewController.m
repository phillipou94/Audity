//
//  YouTableViewController.m
//  Muise
//
//  Created by Phillip Ou on 10/4/14.
//  Copyright (c) 2014 Phillip Ou. All rights reserved.
//

#import "YouTableViewController.h"
#import "ShowPlaylistTableViewController.h"

@interface YouTableViewController ()
@property (nonatomic, strong) PFObject *playList;
@property (nonatomic,strong) NSMutableArray *arrayOfSongs;

@end

@implementation YouTableViewController{
     PFObject *selectedPlaylist;
    BOOL fromYouTableView;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden=NO;
    fromYouTableView=YES;
    self.parseClassName=@"Songs";
    self.view.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    //[self.view setTintColor:[UIColor colorWithRed:69/255.0 green:173/255.0 blue:162/255.0 alpha:1]];
    [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:69/255.0 green:173/255.0 blue:162/255.0 alpha:1]];
    
    self.navigationController.navigationBar.translucent=NO;
    self.navigationController.navigationBar.barTintColor= [UIColor colorWithRed:69/255.0 green:173/255.0 blue:162/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Hero" size:21],
      NSFontAttributeName, nil]];
    
    
    
    
}
-(PFQuery *) queryForTable{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Playlist"];
    [query whereKey:@"createdById" equalTo:[[PFUser currentUser]objectId]];
    [query addDescendingOrder:@"createdAt"];
    return query;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    NSLog(@"%lu",[self.objects count]);
    return [self.objects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *playlist = self.objects[indexPath.row];
    //UILabel *titleLabel = (UILabel *) [cell viewWithTag:0];
    cell.textLabel.text = playlist[@"title"];
    cell.textLabel.textColor=[UIColor colorWithRed:69/255.0 green:173/255.0 blue:162/255.0 alpha:1];
    cell.textLabel.font = [UIFont fontWithName:@"Hero" size:20];
    cell.detailTextLabel.text = playlist[@"description"];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    
    return cell;
    
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedPlaylist = [self.objects objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showSongs" sender:self];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showSongs"]) {
        
        ShowPlaylistTableViewController *other = [segue destinationViewController];
        //NSLog(@"segueing:%@",[self.selectedArticle objectForKey:@"link"]);
        other.playList= selectedPlaylist;
        other.fromYouTableView=fromYouTableView;
        
    }
    
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *loginNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"loginNav"];
    [self presentViewController:loginNavigationController animated:YES completion:nil];
        
        

}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //NSLog(@"deleting");
        PFObject *objectToDelete = self.objects[indexPath.row];
        
        [objectToDelete deleteInBackground];
        [self loadObjects];
        
        //add code here for when you hit delete
        
    }
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        PFObject *objectToDelete = self.objects[indexPath.row];
                                        
                                        [objectToDelete deleteInBackground];
                                        [self loadObjects];
                                    }];
    button.backgroundColor = [UIColor colorWithRed:69/255.0 green:173/255.0 blue:162/255.0 alpha:1]; //arbitrary color
    
    return @[button];
}
@end
