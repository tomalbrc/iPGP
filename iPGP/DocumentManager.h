//
//  DocumentManager.h
//  iPGP
//
//  Created by Tom Albrecht on 19.07.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DocumentManager : NSObject <UIDocumentPickerDelegate>
+ (void)pickDocumentWithCompletionHandler:(void(^)(NSArray<NSURL*> *items))block;
@end
