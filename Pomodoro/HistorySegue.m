//
//  HistorySegue.m
//  Pomodoro
//
//  Created by 王仕杰 on 4/10/16.
//  Copyright © 2016 王仕杰. All rights reserved.
//

#import "HistorySegue.h"
#import "HistoryTableViewController.h"

@implementation HistorySegue

- (void)perform {
  if ([[UIDevice currentDevice].model isEqualToString:@"iPhone"]) {
    [self.sourceViewController.navigationController pushViewController:self.destinationViewController animated:true];
  } else {
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:self.destinationViewController];
    navi.modalPresentationStyle = UIModalPresentationPopover;
    HistoryTableViewController *dest = self.destinationViewController;
    CGFloat height = navi.navigationBar.frame.size.height + 60.0 * dest.tableView.numberOfSections;
    navi.preferredContentSize = CGSizeMake(300, height > 600 ? 600 : height);
    
    [self.sourceViewController presentViewController:navi animated:true completion:nil];
    
    UIPopoverPresentationController* popover = navi.popoverPresentationController;
    popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popover.barButtonItem = self.sourceViewController.navigationItem.rightBarButtonItem;
  }
}

@end
