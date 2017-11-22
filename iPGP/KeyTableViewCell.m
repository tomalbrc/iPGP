//
//  KeyTableViewCell.m
//  iPGP
//
//  Created by Tom Albrecht on 08.04.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
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

- (void)setPublic:(BOOL)publicF {
    _public = publicF;
    _secret = !publicF;
    [self updateImage];
}

- (void)setSecret:(BOOL)secretF {
    _public = !secretF;
    _secret = secretF;
    [self updateImage];
}
- (void)updateImage {
    myImageView.image = [UIImage imageNamed:_secret ? @"lock_closed" : @"globe"];
}

@end
