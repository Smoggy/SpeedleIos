
//
//  SLCategoriesTableViewController.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/13/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLAdCategoriesTableViewController.h"
#import "SLCategoryTableViewCell.h"
#import "SLNewAdConstants.h"
#import "SLCategory.h"
#import "SLAdvert.h"

@interface SLAdCategoriesTableViewController ()
@property (nonatomic, strong) RLMResults *categories;
@end

@implementation SLAdCategoriesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateCategories];
}

#pragma mark - Data Loading

- (void)updateCategories {
    self.categories = [SLCategory allObjects];
}

- (IBAction)doRefresh:(UIRefreshControl *)sender {
    [self updateCategories];
    
    [self.tableView reloadData];
    [sender endRefreshing];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"SELECT A CATEGORY TO SEARCH", nil);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SLNewAdTableViewHeaderMargin;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SLCategoryInfoTableViewCellIdentifier
                                                            forIndexPath:indexPath];
    SLCategory *category = [self.categories objectAtIndex:indexPath.row];
    cell.textLabel.text = category.name;
    cell.isChecked = [self.advertisement.categories indexOfObject:category] != NSNotFound;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SLCategory *category = [self.categories objectAtIndex:indexPath.row];
    SLCategoryTableViewCell *cell = (SLCategoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.isChecked = [self.advertisement updateCategoriesWithCategory:category];
}

@end
