//
//  MMMBookReentlyListTableView.h
//  Mmine
//
//  Created by Jamie on 16/8/25.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMBookRecentlyListTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *contentArray;
@end
