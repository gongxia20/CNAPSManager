//
//  HomeCollectionCell.m
//  CNAPSManager
//
//  Created by James on 2019/2/23.
//  Copyright © 2019 James. All rights reserved.
//

#import "HomeCollectionCell.h"

@interface HomeCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation HomeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImage:(UIImage *)image {
    _imageView.image = image;
}

@end
