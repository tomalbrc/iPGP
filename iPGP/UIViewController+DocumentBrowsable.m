//
//  UIViewController+DocumentBrowsable.m
//  iPGP
//
//  Created by Tom Albrecht on 23.11.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "UIViewController+DocumentBrowsable.h"

@interface TADocumentBrowsableTableViewController () {
    UIDocumentPickerViewController *picker;
}
@end

@implementation TADocumentBrowsableTableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"documentOptionSegue"] && [segue.destinationViewController isKindOfClass:[UIViewController class]]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForPreviewingWithDelegate:self sourceView:self.tableView];
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    // TODO: Create document option VC
    [self performSegueWithIdentifier:@"documentOptionSegue" sender:url];
}

#pragma mark - Peek and pop

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    previewingContext.sourceRect = [self.tableView cellForRowAtIndexPath:indexPath].frame;

    if (!picker) picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.data"] inMode:UIDocumentPickerModeOpen];
    picker.delegate = self;
    if (@available(iOS 11_0, *))
        picker.allowsMultipleSelection = NO;
    
    return picker;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.data"] inMode:UIDocumentPickerModeOpen];
    picker.delegate = self;
    if (@available(iOS 11_0, *))
        picker.allowsMultipleSelection = NO;
    
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}


@end
