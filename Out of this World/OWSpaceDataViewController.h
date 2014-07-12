//
//  OWSpaceDataViewController.h
//  Out of this World
//
//  Created by Tony Angelo on 7/12/14.
//  Copyright (c) 2014 Tony Angelo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OWSpaceObject.h"

@interface OWSpaceDataViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)OWSpaceObject *spaceObject;

@end
