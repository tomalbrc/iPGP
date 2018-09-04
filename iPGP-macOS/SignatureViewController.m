//
//  SignatureViewController.m
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "SignatureViewController.h"

#import "UserInputViewController.h"
#import "XApplication+Additions.h"
#import "NSString+Additions.h"

#import <ObjectivePGP/PGPPacketFactory.h>
#import <ObjectivePGP/PGPSignaturePacket.h>
#import <ObjectivePGP/PGPCompressedPacket.h>
#import <ObjectivePGP/PGPLiteralPacket.h>
#import <ObjectivePGP/ObjectivePGPObject.h>

#define let id

@interface SignatureViewController () {
    UserInputViewController *_userInputViewController;
}

@end

@implementation SignatureViewController

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationController isKindOfClass:[UserInputViewController class]]) {
        _userInputViewController = (UserInputViewController *)segue.destinationController;
        [_userInputViewController.textView setDelegate:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)sign:(id)sender {
    
    
    [[XApplication sharedApplication].objectivePGP sign:_userInputViewController.userData usingKey:[XApplication.sharedApplication.objectivePGP findKeyWithIdentifier:@"DivineMomentOfTruth <olaf.kaiser@aol.com>"] passphrase:@"arschlecker123" detached:NO error:NULL];
}

- (IBAction)showSignedMessage:(id)sender {
    [self verifySignatureData:_userInputViewController.userData];
}

- (void)verifySignatureData:(NSData *)signedData {
    NSData *inputData = signedData;
    
    NSArray<NSData *> *binaryMessages = [ObjectivePGP convertArmoredMessage2BinaryBlocksWhenNecessary:signedData];
    if (binaryMessages.count > 0) signedData = binaryMessages.firstObject;
    
    NSLog(@"binary messages: %@", binaryMessages.description);
    
    PGPSignaturePacket *sigPacket = nil;
    PGPLiteralPacket *literalPacket = nil;
    
    NSArray<PGPPacket *> *accumulatedPackets = [self packetsForData:signedData];
    NSLog(@"First iteration of packets from data: %@", accumulatedPackets.description);
    for (PGPPacket *packet in accumulatedPackets) {
        if (packet.tag == PGPCompressedDataPacketTag) {
            PGPCompressedPacket *compressedPacket = (PGPCompressedPacket *)packet;
            signedData = [compressedPacket decompressedData];
        } else if (packet.tag == PGPSignaturePacketTag) {
            PGPSignaturePacket *signaturePacket = (PGPSignaturePacket *)packet;
            sigPacket = signaturePacket;
        } else if (packet.tag == PGPLiteralDataPacketTag) {
            PGPLiteralPacket *litPacket = (PGPLiteralPacket *)packet;
            literalPacket = litPacket;
        }
    }
    
    NSArray<PGPPacket *> *subPackets = [self packetsForData:signedData];
    NSLog(@"subpackets from data: %@", subPackets.description);
    for (PGPPacket *subPacket in subPackets) {
        if (subPacket.tag == PGPSignaturePacketTag) {
            sigPacket = (PGPSignaturePacket *)subPacket;
            if (sigPacket.type == PGPSignatureCanonicalTextDocument) {
                // filter from input data
                __block NSInteger startLoc = NSNotFound, endLoc = NSNotFound;
                
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(-----)+(BEGIN)[ ](PGP)[A-Z ]*(-----)+" options:NSRegularExpressionDotMatchesLineSeparators error:NULL];
                NSString *s = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
                [regex enumerateMatchesInString:s options:0 range:NSMakeRange(0, s.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                    if (result.range.length > 0) {
                        NSLog(@"Found %@", [s substringWithRange:result.range]);
                        
                        if (startLoc == NSNotFound) startLoc = result.range.location + result.range.length;
                        else if (endLoc == NSNotFound) endLoc = result.range.location - startLoc;
                    }
                }];
                
                NSString *preMsg = [s substringWithRange:NSMakeRange(startLoc+1, endLoc-1)];
                NSRange firstNewline = [preMsg rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:0];
                NSString *final = [preMsg substringWithRange:NSMakeRange(firstNewline.location+2, preMsg.length-firstNewline.location-2)];
                NSLog(@"Message contents: %@", final);
                if (final) literalPacket = [PGPLiteralPacket literalPacket:PGPLiteralPacketTextUTF8 withData:[final dataUsingEncoding:NSUTF8StringEncoding]];
            }
        } else if (subPacket.tag == PGPLiteralDataPacketTag) {
            literalPacket = (PGPLiteralPacket *)subPacket;
        }
    }
    
    PGPKey *user = nil;
    for (PGPKey *key in [[XApplication sharedApplication].objectivePGP keys]) {
        if (key.isPublic && [key.publicKey.keyID.longIdentifier isEqualToString:sigPacket.issuerKeyID.longIdentifier]) {
            user = key;
            break;
        }
    }
    
    NSLog(@"Found Key: %@", user);
    NSLog(@"Signature packet type: %d", sigPacket.type);
    NSLog(@"Literal data UTF-8: %@", [[NSString alloc] initWithData:literalPacket.literalRawData encoding:NSUTF8StringEncoding]);
    
    NSError *err;
    BOOL real = [sigPacket verifyData:literalPacket.literalRawData withKey:user error:&err];
    
    if (err) {
        NSAlert *a = [NSAlert alertWithError:err];
        [a runModal];
    }
    
    if (user)   _statusTextField.stringValue = [NSString stringWithFormat:@"Signed by %@ (Couldn't verify message data)", [user.publicKey.users.firstObject userID].PGPName];
    else if (sigPacket.type == PGPSignatureBinaryDocument && literalPacket.literalRawData.length > 0) _statusTextField.stringValue = @"Unknown Signee";
    else _statusTextField.stringValue = @"Invalid";
    
    NSLog(@"REAL: %d, err: %@", real, err);
    
    if (real) {
        _statusTextField.stringValue = @"REAL DATA! SUCCESS";
    }
}


- (NSArray<PGPPacket *> *)packetsForData:(NSData *)data {
    NSMutableArray<PGPPacket *> *accumulatedPackets = [NSMutableArray array];
    NSUInteger offset = 0;
    NSUInteger nextPacketOffset;

    while (offset < data.length) {
        PGPPacket *packet = [PGPPacketFactory packetWithData:data offset:offset nextPacketOffset:&nextPacketOffset];
        if (packet) {
            [accumulatedPackets addObject:packet];
        } else {
            // Should assert here
            // happens when data is completely invalid
            break;
        }
        
        offset += nextPacketOffset;
    }
    return accumulatedPackets;
}

#pragma mark - NSTextViewDelegate

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRanges:(NSArray<NSValue *> *)affectedRanges replacementStrings:(NSArray<NSString *> *)replacementStrings {
    [self textView:textView shouldChangeTextInRange:affectedRanges.firstObject.rangeValue replacementString:replacementStrings.firstObject];
    return YES;
}

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString {
    NSLog(@"%s, TextViewString: %@", __PRETTY_FUNCTION__, textView.string);
    NSLog(@"%s, ReplacementString: %@", __PRETTY_FUNCTION__, replacementString);
    NSLog(@"%s, AffectedRange: %@", __PRETTY_FUNCTION__, NSStringFromRange(affectedCharRange));
    NSLog(@"Resulting String: %@", [textView.string stringByAppendingString:replacementString]);
    
    
    //[_recipientSelection removeAllItems];
    _statusTextField.stringValue = @"";
    
    NSString *sanitizedString = affectedCharRange.length > 0 ? [textView.string substringFromIndex:textView.string.length-1] : [textView.string stringByAppendingString:replacementString];
    NSLog(@"Sanitized String: %@", sanitizedString);
    if ([sanitizedString isValidSignature] || [sanitizedString isValidMessage]) {
        [self verifySignatureData:[sanitizedString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return YES;
}

@end
