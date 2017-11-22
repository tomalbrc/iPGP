//
//  DocumentManager.m
//  iPGP
//
//  Created by Tom Albrecht on 19.07.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "DocumentManager.h"

@interface DocumentManager () {
    
}
@property (nonatomic, copy, nullable) void (^completionHandler)(NSArray<NSURL*> * __nullable items);
@end

@implementation DocumentManager
+ (void)pickDocumentWithCompletionHandler:(void(^)(NSArray<NSURL*> *items))block {
    DocumentManager *manager = [DocumentManager new];
    
    
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.data", @"public.content"] inMode:UIDocumentPickerModeImport];
    picker.delegate = manager;
    manager.completionHandler = block;
}



#pragma mark - Document Picker Delegate implementation

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    
    self.completionHandler(nil);
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    self.completionHandler(@[url]);
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    self.completionHandler(urls);
}


@end
