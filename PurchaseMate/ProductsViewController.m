//
//  productsVC.m
//  PurchaseMate
//
//  Created by Jacob Banks on 4/23/16.
//  Copyright © 2016 Jacobanks. All rights reserved.
//

#import "ProductsViewController.h"
#import "CorpInfo.h"
#import "SearchCollectionViewCell.h"
#import "MBProgressHUD.h"
#import "ResultsViewController.h"

@interface ProductsViewController ()

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *productsArray;

@end

@implementation ProductsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if (delegate.isReachable) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            self.productsArray = [[[CorpInfo alloc] init] getAllProductsWithCorpName:self.corpString];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50);
                self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
                [self.collectionView setDataSource:self];
                [self.collectionView setDelegate:self];
                
                [self.collectionView registerClass:[SearchCollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
                [self.collectionView setBackgroundColor:[UIColor whiteColor]];
                
                [self.view addSubview:self.collectionView];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.title = self.corpString;
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
    return self.productsArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor darkGrayColor];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor colorWithRed:6.0/255.0 green:181.0/255.0 blue:124.0/255.0 alpha:1].CGColor;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 6;
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", self.productsArray[indexPath.row]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.frame.size.width / 3) - 20, (self.view.frame.size.width / 3) - 20);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 12, 10, 12);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if (delegate.isReachable) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            NSDictionary *corpData = [[[CorpInfo alloc] init] getPoliticalInfoWithCorpName:self.corpString andProductName:self.productsArray[indexPath.row]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (corpData != nil) {
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ResultsViewController *vc = (ResultsViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"results"];
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
                    [self presentViewController:navController animated:YES completion:nil];
                }
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
        
    }
}

@end
