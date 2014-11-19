//
//  Song.h
//  Muise
//
//  Created by Phillip Ou on 10/9/14.
//  Copyright (c) 2014 Phillip Ou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *artist;
@property (nonatomic,strong) NSString *imageUrl;
@property int index;

@end
