//
//  HistorySegue.m
//  Pomodoro
//
//  Created by 王仕杰 on 4/10/16.
//  Copyright © 2016 王仕杰. All rights reserved.
//

#import "HistorySegue.h"


@implementation HistorySegue

- (void)perform {
  if ([[UIDevice currentDevice].model isEqualToString:@"iPhone"]) {
    [self.sourceViewController.navigationController pushViewController:self.destinationViewController animated:true];
  } else {
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:self.destinationViewController];
    navi.modalPresentationStyle = UIModalPresentationPopover;
    
    [self.sourceViewController presentViewController:navi animated:true completion:nil];
    
    UIPopoverPresentationController* popover = navi.popoverPresentationController;
    popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popover.barButtonItem = self.sourceViewController.navigationItem.rightBarButtonItem;
  }
}

@end
