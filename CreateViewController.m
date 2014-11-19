//
//  CreateViewController.m
//  Muise
//
//  Created by Phillip Ou on 10/3/14.
//  Copyright (c) 2014 Phillip Ou. All rights reserved.
//

#import "CreateViewController.h"
#import <Parse/Parse.h>
#import "Song.h"

@interface CreateViewController ()

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleTextField.attributedPlaceholder=[[NSAttributedString alloc] initWithString:@"Title Your Playlist" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:69/255.0 green:173/255.0 blue:162/255.0 alpha:1]}];
    self.descriptionTextView.delegate=self;
    self.navigationController.navigationBar.translucent=NO;
    self.navigationController.navigationBar.barTintColor= [UIColor colorWithRed:69/255.0 green:173/255.0 blue:162/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Hero" size:21],
      NSFontAttributeName, nil]];
    // Do any additional setup after loading the view.
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.descriptionTextView.text = @"";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {
    
    PFUser *currentUser = [PFUser currentUser];
    PFObject *playList = [PFObject objectWithClassName:@"Playlist"];
    playList[@"createdById"] = currentUser.objectId;
    playList[@"createdByName"] = currentUser.username;
    if(self.titleTextField.text.length==0){
        playList[@"title"]=@"Untitled";
    }
    else{
        playList[@"title"] = self.titleTextField.text;
    }
    playList[@"description"]=self.descriptionTextView.text;
    
    [playList saveInBackground];
    [self.tabBarController setSelectedIndex:0];
    
    [self clear];
    
    
}

-(void)clear{
    self.titleTextField.text=nil;
    self.descriptionTextView.text=nil;
}

- (IBAction)back:(id)sender {
    [self.tabBarController setSelectedIndex:0];
    [self clear];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
