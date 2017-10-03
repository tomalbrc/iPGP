//
//  TATabBarController.h
//  iPGP-macOS
//
//  Created by Tom Albrecht on 28.09.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TATabBarController : NSViewController

@property (weak, nonatomic) IBOutlet NSStackView *buttonBarStackView;
@property (weak, nonatomic) IBOutlet NSView *containerView;


@end
