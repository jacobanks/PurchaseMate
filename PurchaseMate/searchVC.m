//
//  searchVC.m
//  PurchaseMate
//
//  Created by Jacob Banks on 4/23/16.
//  Copyright © 2016 Jacobanks. All rights reserved.
//

#import "searchVC.h"
#import "searchCollectionViewCell.h"
#import "CorpInfo.h"

@interface searchVC ()

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *corpsArray;

@end

@implementation searchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [self.collectionView  setDataSource:self];
    [self.collectionView  setDelegate:self];
    
    [self.collectionView  registerClass:[searchCollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.collectionView  setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.collectionView];
    
    self.corpsArray = [[[CorpInfo alloc] init] getAllCorps];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.corpsArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    searchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor greenColor];

    cell.titleLabel.text = [NSString stringWithFormat:@"%@", self.corpsArray[indexPath.row]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(175, 175);
}

@end
