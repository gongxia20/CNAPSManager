//
//  HomeCollectionCell.h
//  CNAPSManager
//
//  Created by James on 2019/2/23.
//  Copyright © 2019 James. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeCollectionCell : UICollectionViewCell
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;

@end

NS_ASSUME_NONNULL_END
