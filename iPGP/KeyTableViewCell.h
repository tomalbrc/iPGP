//
//  KeyTableViewCell.h
//  iPGP
//
//  Created by Tom Albrecht on 08.04.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ObjectivePGP/ObjectivePGP.h>

@interface KeyTableViewCell : UITableViewCell {
    IBOutlet UIImageView *myImageView;
    
    BOOL _secret,_public;
}


@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UILabel *emailLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

- (void)setSecret:(BOOL)secretF;
- (void)setPublic:(BOOL)publicF;

@end
