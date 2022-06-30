//
//  GramCell.h
//  Instagram
//
//  Created by Chidi Onyekwelu on 6/29/22.
//

#import <UIKit/UIKit.h>
@import Parse;
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface GramCell : UITableViewCell
@property (strong, nonatomic) Post *thisPost;
@property (weak, nonatomic) IBOutlet PFImageView *postImages;

@end

NS_ASSUME_NONNULL_END
