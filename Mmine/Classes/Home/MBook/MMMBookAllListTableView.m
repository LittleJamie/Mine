//
//  MMMBookAllListTableView.m
//  Mmine
//
//  Created by Jamie on 16/8/25.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMMBookAllListTableView.h"

@implementation MMMBookAllListTableView
static NSString * cellID = @"allListCell";
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contentArray.count;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = _contentArray[indexPath.row];
    cell.backgroundColor = MRandomColor;
    return cell;
}

@end
