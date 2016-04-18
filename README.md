# Pomodoro
A simple Pomodoro Timer in Objective-C.

### iPhone
![image](http://7xt1ag.com1.z0.glb.clouddn.com/Simulator%20Screen%20Shot%20Apr%2016%2C%202016%2C%2009.04.30.png)
![image](http://7xt1ag.com1.z0.glb.clouddn.com/Simulator%20Screen%20Shot%20Apr%2016%2C%202016%2C%2009.05.08.png)
### iPad
#### portrait
![image](http://7xt1ag.com1.z0.glb.clouddn.com/Simulator%20Screen%20Shot%20Apr%2016%2C%202016%2C%2009.07.25.png)
#### landscape
![image](http://7xt1ag.com1.z0.glb.clouddn.com/Simulator%20Screen%20Shot%20Apr%2016%2C%202016%2C%2009.07.29.png)
  
## TODO:
* ~~Add animation when counting down.~~
* ~~The animation did not finish when counting down finished.~~
* ~~Launch screen and App Icon.~~
* ~~store history by core data.~~
* ~~Adapt to iPad and iPhone in landscape.~~
* Add iCloud Kit to store records on cloud.

###  April 13, 2016 BUG
~~**Timer stoped when App enter background.** Solved~~



# Implementation
### Push in iPhone and popover in iPad:
By using custom sugue:  
![image](http://7xt1ag.com1.z0.glb.clouddn.com/Screen%20Shot%202016-04-16%20at%2008.32.46.png)  

implementation of HistorySegue:    
Override `- (void)perform` method of `UIStoryboardSegue` Class.

	- (void)perform {
	  if ([[UIDevice currentDevice].model isEqualToString:@"iPhone"]) {
	    [self.sourceViewController.navigationController pushViewController:self.destinationViewController animated:true];
	  } else {
	    self.destinationViewController.modalPresentationStyle = UIModalPresentationPopover;
	    
	    [self.sourceViewController presentViewController:self.destinationViewController animated:true completion:nil];
	    
	    UIPopoverPresentationController* popover = self.destinationViewController.popoverPresentationController;
	    popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
	    popover.barButtonItem = self.sourceViewController.navigationItem.rightBarButtonItem;
	  }
	}
	
### Adaptation of iPhone and iPad
By using Size Classes:  
![image](http://7xt1ag.com1.z0.glb.clouddn.com/Screen%20Shot%202016-04-16%20at%2008.55.35.png)  
Set different constraints in different size classes