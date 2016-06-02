//
//  MMHomeModuleSelectionView.h
//  Mmine
//
//  Created by Jamie on 16/6/1.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ItemBlock)(NSInteger itemNum);
@interface MMHomeModuleSelectionView : UICollectionView
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, copy) ItemBlock block;;

- (void)clickCell:(ItemBlock)block;
@end
