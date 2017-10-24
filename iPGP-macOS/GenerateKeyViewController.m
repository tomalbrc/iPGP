//
//  GenerateKeyViewController.m
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "GenerateKeyViewController.h"
#import "XApplication+Additions.h"

@interface GenerateKeyViewController () {
    NSMutableDictionary *_keys;
    
    WKUserScript *script;
    WKWebView *webView;
    //WKUserContentController *userContentController;
}

@end

@implementation GenerateKeyViewController

- (IBAction)generate:(id)sender {
    BOOL shouldGenerate = YES;
    if (nameTF.stringValue.length <= 0) {
        nameTF.textColor = [NSColor redColor];
        shouldGenerate = NO;
    }
    if (emailTF.stringValue.length <= 0) {
        emailTF.textColor = [NSColor redColor];
        shouldGenerate = NO;
    }
    if (passwordTF.stringValue.length <= 0) {
        passwordTF.textColor = [NSColor redColor];
        shouldGenerate = NO;
    }
    if (passwordConfirmTF.stringValue.length <= 0) {
        nameTF.textColor = [NSColor redColor];
        shouldGenerate = NO;
    }
    
    if (shouldGenerate) [self generateKeys];
}


// TODO: Cross platform Key manager
- (void)generateKeys {
    if (webView) [webView reload];
    
    NSLog(@"Generate keys");
    
    _keys = [NSMutableDictionary dictionary];
    
    NSInteger algoSelectionIndex = [algoSelection.itemArray indexOfObject:algoSelection.selectedItem];
    NSInteger keyLengthSelectionIndex = [algoSelection.itemArray indexOfObject:algoSelection.selectedItem];
    NSString *algo = algoSelectionIndex == 0 ? @"rsa" : @"ecc";
    
    int keySize = 384;
    if (algoSelectionIndex == 0) keySize = keyLengthSelectionIndex == 0 ? 1024 : keyLengthSelectionIndex == 1 ? 2048 : keyLengthSelectionIndex == 2 ? 4096 : 8192;
    
    
    NSString *name = nameTF.stringValue, *email = emailTF.stringValue, *comment = commentTF.stringValue, *password = passwordTF.stringValue;
    
    NSString *jquery = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"jquery-1.11.2.min" ofType:@"js"] encoding:NSUTF8StringEncoding error:NULL];
    NSString *kbpgp = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"kbpgp-1.0.0-min" ofType:@"js"] encoding:NSUTF8StringEncoding error:NULL];
    NSString *keygen = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pgpkeygen" ofType:@"js"] encoding:NSUTF8StringEncoding error:NULL];
    
    NSString *commandString = [NSString stringWithFormat:@
                               " genKeyPair(\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", %d);", name, email, comment, password, algo, keySize];
    keygen = [keygen stringByAppendingString:commandString];

    
    script = [[WKUserScript alloc] initWithSource:[[jquery stringByAppendingString:kbpgp] stringByAppendingString:keygen] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"skey"];
    [userContentController addScriptMessageHandler:self name:@"pkey"];
    [userContentController addScriptMessageHandler:self name:@"customDebug"];
    [userContentController addUserScript:script];

    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userContentController;
    
    webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 300, 300) configuration:configuration];
    [self.view addSubview:webView];

    [webView loadHTMLString:@"<html><p>hellohkhjkhjhjkhkjhjkh kjhjk</p></html>ghg hjgjh gj" baseURL:[NSBundle.mainBundle bundleURL]];
    //[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://google.com"]]];
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"Message: %@ %@", message.name, message.body);
    _keys[message.name] = [[[NSApplication sharedApplication] objectivePGP] keysFromData:[message.body dataUsingEncoding:NSUTF8StringEncoding]].firstObject;
    
    if (_keys.allValues.count >= 2 && _keys[@"skey"] && _keys[@"pkey"]) {
        if (self.delegate) [self.delegate generateKeyViewController:self didFinishWithKeys:_keys.allValues];
        else NSLog(@"No delegate!");
        
        [webView removeFromSuperview];
        webView = nil;
        _keys = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
