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
@property(strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation HomeFeedViewController
- (IBAction)didTapLogout:(id)sender {
        
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
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
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
 
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
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.arrayOfposts = (NSMutableArray*) posts;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"PostDetailsSegue"]) {
        Post * post = self.arrayOfposts[[self.tableView indexPathForCell:sender].row
        ];
        PostDetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
            
  
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
