//
//  HomeFeedViewController.m
//  Instagram
//
//  Created by Chidi Onyekwelu on 6/28/22.
//

#import "HomeFeedViewController.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "GramCell.h"
#import "Post.h"

@interface HomeFeedViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayOfposts;
@property(strong, nonatomic) UIRefreshControl *refreshcontrol;

@end

@implementation HomeFeedViewController
- (IBAction)didTapLogout:(id)sender {
        
    // PFUser.current() will now be nil
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nilUIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        SceneDelegate *mySceneDelegate = (SceneDelegate *) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
        mySceneDelegate.window.rootViewController = loginViewController;
        NSLog(@"User logged out");
    }];
    }

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self fetchData];
    UIRefreshControl *refreshcontrol = [[UIRefreshControl alloc] init];
 
    // Do any additional setup after loading the view.
}
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}
  
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfposts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GramCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GramCell"];
    Post *thisPost = self.arrayOfposts[indexPath.row];
//    cell.thisPost = thisPost;
        cell.postImages.file = thisPost[@"image"];
        [cell.postImages loadInBackground];
    
    return cell;
}

- (void)fetchData
{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    query.limit = 20;
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.arrayOfposts = (NSMutableArray*) posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
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
