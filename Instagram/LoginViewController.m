//
//  LoginViewController.m
//  Instagram
//
//  Created by Chidi Onyekwelu on 6/28/22.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"

@interface LoginViewController ()
- (IBAction)signupButton:(id)sender;

- (IBAction)loginButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *usersPassword;
@property (weak, nonatomic) IBOutlet UITextField *usersUsername;



@end

@implementation LoginViewController
- (IBAction)loginButton:(id)sender {
    if ([self.usersUsername.text isEqual:@""] || [self.usersPassword.text isEqual:@""]){
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Title"
                                                                               message:@"Message"
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle cancel response here. Doing nothing will dismiss the view.
                                                      }];
    // add the cancel action to the alertController
    [alert addAction:cancelAction];

    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
        [self presentViewController:alert animated:YES completion:^{
            // nothing
        }];
    }
    else{
            [self loginUser];
        }
}



- (IBAction)signupButton:(id)sender {
    
    if ([self.usersUsername.text isEqual:@""] || [self.usersPassword.text isEqual:@""]) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Title"
                                                                               message:@"Message"
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle cancel response here. Doing nothing will dismiss the view.
                                                      }];
    // add the cancel action to the alertController
    [alert addAction:cancelAction];

    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
        
    [self presentViewController:alert animated:YES completion:^{
        // nothing
    }];
}
    else{
            [self registerUser];
        }

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usersUsername.text;
    newUser.password = self.usersPassword.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            [self performSegueWithIdentifier:@"FirstSegue" sender:nil];
            // manually segue to logged in view
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
            SceneDelegate *mySceneDelegate = (SceneDelegate *) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
            mySceneDelegate.window.rootViewController = tabBarController;
        }
    }];
}

- (void)loginUser {
    NSString *username = self.usersUsername.text;
    NSString *password = self.usersPassword.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"FirstSegue" sender:nil];
            // display view controller that needs to shown after successful login
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
            SceneDelegate *mySceneDelegate = (SceneDelegate *) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
            mySceneDelegate.window.rootViewController = tabBarController;
        }
    }];
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

