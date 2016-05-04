//
//  LoginViewController.m
//  Pomodoro
//
//  Created by 王仕杰 on 5/3/16.
//  Copyright © 2016 王仕杰. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "User.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation LoginViewController

- (UIAlertController *)alert {
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                 message:@""
                                                          preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                           style:UIAlertActionStyleCancel
                                         handler:nil]];
  return alert;
}

- (IBAction)signIn {
  if (self.nameTextField.text.length == 0) {
    [self textFieldIsEmpty];
    return;
  }
  
  if (![self hasUserWithName:self.nameTextField.text]) {
    UIAlertController* alert = self.alert;
    alert.message = @"User not found.";
    [self presentViewController:alert
                       animated:YES
                     completion:nil];    
  } else {
    [[NSUserDefaults standardUserDefaults] setObject:self.nameTextField.text
                                              forKey:@"current username"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"login"
                                                        object:@{@"username" : self.nameTextField.text}];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
  }
}

- (IBAction)signUp {
  if (self.nameTextField.text.length == 0) {
    [self textFieldIsEmpty];
    return;
  }
  
  if ([self hasUserWithName:self.nameTextField.text]) {
    UIAlertController* alert = self.alert;
    alert.message = @"This user is already existed.";
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
  } else {
    User* newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                  inManagedObjectContext:self.context];
    newUser.name = self.nameTextField.text;
    [self.context save:nil];
    [[NSUserDefaults standardUserDefaults] setObject:self.nameTextField.text
                                              forKey:@"current username"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"login"
                                                        object:@{@"username" : self.nameTextField.text}];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
  }
}

- (IBAction)cancel {
  [self dismissViewControllerAnimated:true
                           completion:nil];
}


- (void)textFieldIsEmpty {
  [UIView animateWithDuration:0.2
                        delay:0
                      options:UIViewAnimationOptionAutoreverse
                   animations:^{
                     self.nameTextField.backgroundColor = [UIColor redColor];
                   } completion:^(BOOL finished) {
                     if (finished) { self.nameTextField.backgroundColor = [UIColor whiteColor]; }
                   }];
}

- (BOOL)hasUserWithName:(NSString *)name {
  NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
  request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
  
  NSError* error;
  
  NSArray* results = [self.context executeFetchRequest:request
                              error:&error];
  
//  NSLog(@"%@", (NSArray<User *> *)results);
  
  if (results.count == 1 && !error) {
    return true;
  }
  
  return false;
}

- (NSManagedObjectContext *)context {
  return ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
}

@end
