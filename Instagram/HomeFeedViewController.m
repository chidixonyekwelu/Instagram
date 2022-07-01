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
#import "PostDetailsViewController.h"
#import "ComposeViewController.h"
#import "DateTools.h"

@interface HomeFeedViewController () <ComposeViewControllerDelegate ,UITableViewDataSource>
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
    self.refreshcontrol = [[UIRefreshControl alloc] init];
    [self.refreshcontrol addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshcontrol atIndex:0];
 
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
    cell.thisPost = thisPost;
        cell.postImages.file = thisPost[@"image"];
        [cell.postImages loadInBackground];
    cell.captionHomeView.text = thisPost[@"caption"];
    cell.timeLabel.text = [thisPost.createdAt shortTimeAgoSinceNow];
    return cell;
}

- (void)fetchData
{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.arrayOfposts = (NSMutableArray*) posts;
            [self.tableView reloadData];
            [self.refreshcontrol endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"PostDetailsSegue"]) {
        Post * post = self.arrayOfposts[[self.tableView indexPathForCell:sender].row
        ];
        PostDetailsViewController *detailsviewcontroller = [segue destinationViewController];
        detailsviewcontroller.post = post;
            
    //     Get the new view controller using [segue destinationViewController].
    }
    else {
        UINavigationController *navigationcontroller = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationcontroller.topViewController;
        composeController.delegate = self;
        
    }
}

- (void)didPost:(Post *)post {
    [self.arrayOfposts insertObject:post atIndex:0];
    [self.tableView reloadData];
}

@end
