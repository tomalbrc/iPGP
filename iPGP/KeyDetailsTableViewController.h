//
//  KeyDetailsTableViewController.h
//  iPGP
//
//  Created by Tom Albrecht on 15.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectivePGP/ObjectivePGP.h"

@interface KeyDetailsTableViewController : UITableViewController {
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *emailLbl;
    IBOutlet UILabel *commentLbl;
    IBOutlet UILabel *keysizeLbl;
    IBOutlet UILabel *keytypeLbl;
    IBOutlet UILabel *algoLbl;
    
    IBOutlet UILabel *creationLbl;
    IBOutlet UILabel *expiresLbl;
    IBOutlet UILabel *shortKeyLbl;
    IBOutlet UILabel *longKeyLbl;
    
}

@property (weak, nonatomic) PGPKey *key;

@end
