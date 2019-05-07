//
//  DetailAddressCell.m
//  CNAPSManager
//
//  Created by James on 2019/3/6.
//  Copyright © 2019 James. All rights reserved.
//

#import "DetailAddressCell.h"
#import "MapViewController.h"

@interface DetailAddressCell () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageAddress;
@property (weak, nonatomic) IBOutlet UILabel *branchBankName;
@property (weak, nonatomic) IBOutlet UILabel *branchBankAddress;
@property (weak, nonatomic) IBOutlet UILabel *branchBankCnaps;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;

@property (weak, nonatomic) id target;
@property (assign, nonatomic) SEL action;
@end

@implementation DetailAddressCell

- (void)setModel:(CnapsModel *)model {
    _model = model;
    
    self.branchBankName.text = _model.branchBankName;
    if (_model.branchBankAddress.length == 0) {
        self.branchBankAddress.text = @"没有具体的参考地址";
        self.btnImage.userInteractionEnabled = NO;
//        [self.btnImage setImage:[UIImage imageNamed:@"location_gray"] forState:UIControlStateNormal];
    } else {
        self.btnImage.userInteractionEnabled = NO;
        self.branchBankAddress.text = _model.branchBankAddress;
    }
    self.branchBankCnaps.text = _model.branchBankCnaps;
}

// 复制cnaps
- (IBAction)btnClick:(id)sender forEvent:(UIEvent *)event {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.branchBankCnaps.text;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"CNAPS码 已复制" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];
}

- (IBAction)btnLoction:(UIButton *)btn {

}


@end
