//
//  SLCategoriesToSearchTableViewController.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/22/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLCategoriesToSearchTableViewController.h"
#import "SLCategory.h"
#import "SLNewAdConstants.h"
#import "SLCategoryTableViewCell.h"

@interface SLCategoriesToSearchTableViewController ()
@property (nonatomic, strong) RLMResults *categories;
@end

@implementation SLCategoriesToSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateCategories];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateCategories {
    self.categories = [SLCategory allObjects];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"SELECT A CATEGORY TO SEARCH", nil);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SLNewAdTableViewHeaderMargin;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SLCategoryInfoTableViewCellIdentifier
                                                                    forIndexPath:indexPath];
    SLCategory *category = [self.categories objectAtIndex:indexPath.row];
    cell.textLabel.text = category.name;
    cell.isChecked = [self.selectedCategory.categoryId isEqualToString:category.categoryId];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SLCategoryTableViewCell *cell = (SLCategoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    self.homeController.classifieds = nil;
    if ([self.homeController.category isEqual:[self.categories objectAtIndex:indexPath.row]]) {
        cell.isChecked = NO;
        self.homeController.category = nil;
    } else {
        self.homeController.category = [self.categories objectAtIndex:indexPath.row];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
