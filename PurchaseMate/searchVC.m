//
//  searchVC.m
//  PurchaseMate
//
//  Created by Jacob Banks on 4/23/16.
//  Copyright © 2016 Jacobanks. All rights reserved.
//

#import "searchVC.h"
#import "productsVC.h"
#import "searchCollectionViewCell.h"
#import "CorpInfo.h"

@interface searchVC ()

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *corpsArray;

@end

@implementation searchVC

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGRect frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, (self.view.frame.size.height - 113));
    self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    [self.collectionView  setDataSource:self];
    [self.collectionView  setDelegate:self];
    
    [self.collectionView  registerClass:[searchCollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.collectionView  setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.collectionView];
    
    self.corpsArray = [[[CorpInfo alloc] init] getAllCorps];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.tabBarController.title = @"Discover";
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @""
                                   style: UIBarButtonItemStylePlain
                                   target: nil action: nil];
    
    [self.tabBarController.navigationItem setBackBarButtonItem: backButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.corpsArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    searchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:105.0/255.0 blue:12.0/255.0 alpha:0.75];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 6;
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", self.corpsArray[indexPath.row]];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(170, 170);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 12, 10, 12);  // top, left, bottom, right
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    searchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    productsVC *vc = (productsVC *)[mainStoryboard instantiateViewControllerWithIdentifier:@"products"];
    vc.corpString = [NSString stringWithFormat:@"%@", self.corpsArray[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
