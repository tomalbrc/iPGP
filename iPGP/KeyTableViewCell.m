//
//  KeyTableViewCell.m
//  iPGP
//
//  Created by Tom Albrecht on 08.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "KeyTableViewCell.h"
#import "Types.h"

@implementation KeyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    myImageView.tintColor = kColorButtons;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setKeytype:(PGPKeyType)keytype {
    _keytype = keytype;
    
    if (keytype == PGPKeySecret) {
        myImageView.image = [UIImage imageNamed:@"lock_closed"];
    } else {
        myImageView.image = [UIImage imageNamed:@"globe"];
    }
    
    myImageView.image = [myImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

@end
