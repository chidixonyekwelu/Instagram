//
//  PostDetailsViewController.m
//  Instagram
//
//  Created by Chidi Onyekwelu on 6/30/22.
//

#import "PostDetailsViewController.h"
#import "GramCell.h"
#import "Parse/Parse.h"
#import "Post.h"
#import "HomeFeedViewController.h"

@interface PostDetailsViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *postDetailImage;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.postDetailImage.file = self.post.image;
    [self.postDetailImage loadInBackground];
    
    self.captionLabel.text = self.post.caption;
    
    // Do any additional setup after loading the view.
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
