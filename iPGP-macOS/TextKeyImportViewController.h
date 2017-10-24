//
//  TextKeyImportViewController.h
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PGPKey;
@class TextKeyImportViewController;
@protocol TextKeyImportViewControllerDelegate
- (void)textKeyImportViewController:(TextKeyImportViewController *)textKeyImportViewController didFinishWithKeys:(NSArray<PGPKey *> *)keys;
@end

@interface TextKeyImportViewController : NSViewController <NSTextViewDelegate> {
    IBOutlet NSTextView *_textView;
    IBOutlet NSButton *_importButton;
}

@property (weak, nonatomic) id<TextKeyImportViewControllerDelegate> delegate;

- (IBAction)importKey:(id)sender;

@end
