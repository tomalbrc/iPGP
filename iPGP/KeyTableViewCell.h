//
//  KeyTableViewCell.h
//  iPGP
//
//  Created by Tom Albrecht on 08.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ObjectivePGP/ObjectivePGP.h>

@interface KeyTableViewCell : UITableViewCell {
    IBOutlet UIImageView *myImageView;
}


@property (assign, nonatomic) PGPKeyType keytype;
@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UILabel *emailLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;



@end
