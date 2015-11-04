//
//  ELCitiesListController.m
//  ElanicTest
//
//  Created by Manohar T on 03/11/15.
//  Copyright © 2015 Manohar T. All rights reserved.
//

#import "ELCitiesListController.h"
#import "ELCityInfoViewController.h"
#import "ELCityMapViewController.h"
#import "ELCitiesListCell.h"
#import "ELCity.h"
#import "ELAPIManager.h"
#import "ELConstants.h"

@interface ELCitiesListController () <UITableViewDataSource, UITableViewDelegate, ELCitiesListViewCellDelegate>

@property (assign, nonatomic)NSInteger indexOfCellShowingMenu;

@end

@implementation ELCitiesListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.indexOfCellShowingMenu = -1;

//    [self.tableview registerClass:[ELCitiesListCell class] forCellReuseIdentifier:@"CityListCell"];

}

-(void)viewDidAppear:(BOOL)animated
{
    [self downloadImagesWithInfo:self.citiesList];
    [self.tableview reloadData];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateCitiesList:(NSArray *)list
{
    self.citiesList = [NSArray arrayWithArray:list];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([@"PushCityInfo" isEqualToString:segue.identifier])
    {
        
    }
    else if ([@"PushCityMap" isEqualToString:segue.identifier])
    {
        
    }
}


#pragma mark -
#pragma mark - UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = [self.citiesList count];
    return numberOfRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELCitiesListCell *cell = nil;
    static NSString *cellIdentifier = @"CityListCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    
    ELCity *city = [self.citiesList objectAtIndex:indexPath.row];
    
    cell.titleLabe.text = [city.info objectForKey:@"name"];
    
    [cell setButtonTagsTo:indexPath.row];
    [cell setDelegate:self];

    [cell hideMenuWithAnimation:NO];
    [cell showHideStatusImageView:city.isFavorite];
    
    BOOL imageDownloading = NO;
    if(eFileDownloading == city.imageDownloadStatus)
    {
        imageDownloading = YES;
    }
    [cell updateActivityIndicatorStatus:imageDownloading];
    
    NSString *name = [city.info objectForKey:@"name"];
    NSString *cacheDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    __block NSString *filePath = @"";
    filePath = [cacheDirectoryPath stringByAppendingPathComponent:name];
    filePath = [NSString stringWithFormat:@"%@.jpg", filePath];
        
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        city.imageDownloadStatus = eFileDownloaded;
        NSData *retrievedData = [NSData dataWithContentsOfFile:filePath];
        cell.citImageView.image = [UIImage imageWithData:retrievedData];
    }
    return cell;
}

#pragma mark -
#pragma mark - UITableView Delegate

-(CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 75.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELCity *city = [self.citiesList objectAtIndex:indexPath.row];
    ELCityInfoViewController *cityInfoController = [self.storyboard instantiateViewControllerWithIdentifier:@"CityInfoController"];
    
    NSString *name = [city.info objectForKey:@"name"];
    NSString *cacheDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    __block NSString *filePath = @"";
    filePath = [cacheDirectoryPath stringByAppendingPathComponent:name];
    filePath = [NSString stringWithFormat:@"%@.jpg", filePath];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        city.imageDownloadStatus = eFileDownloaded;
        NSData *retrievedData = [NSData dataWithContentsOfFile:filePath];
        [cityInfoController setImage:[UIImage imageWithData:retrievedData]];
    }
    
    
    [cityInfoController setCity:city];
    [self.navigationController pushViewController:cityInfoController animated:YES];
}

-(void)downloadImagesWithInfo:(NSArray *)citiesList
{
    //Downloads the audio files and saves them in the local storage.
    
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
    [backgroundQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    
    NSMutableArray *operationsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [citiesList count]; i++)
    {
        ELCity *city = [citiesList objectAtIndex:i];
        NSString *name = [city.info objectForKey:@"name"];
        NSString *cacheDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        __block NSString *filePath = @"";
        filePath = [cacheDirectoryPath stringByAppendingPathComponent:name];
        filePath = [NSString stringWithFormat:@"%@.jpg", filePath];
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            NSDictionary *photos = [[city.info objectForKey:@"photos"] objectAtIndex:0];
            NSString *photo_Reference = [photos objectForKey:@"photo_reference"];
            NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=600&photoreference=%@&key=%@",photo_Reference , kGooglePlacesAPIKey];
            __block NSInteger modelIndex = i;
            
            __block NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
            
            city.imageDownloadStatus = eFileDownloading;
            NSBlockOperation *blockOperation = [[NSBlockOperation alloc] init];
            [blockOperation setQueuePriority:NSOperationQueuePriorityHigh];
            [blockOperation addExecutionBlock:^{
                
                
                NSURLResponse *urlResponse = nil;
                NSError *error = nil;
                
                NSData *data = nil;
                data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
                
                if(!error && data)
                {
                    [data writeToFile:filePath atomically:YES];
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        [[self.citiesList objectAtIndex:modelIndex] setImageDownloadStatus:eFileDownloaded];
                        [self checkCellVisibilityAndreloadTableViewCellAtRow:modelIndex];
                    }];
                    
                }
                else
                {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        [[self.citiesList objectAtIndex:modelIndex] setImageDownloadStatus:eFileNotDownloaded];
                        [self checkCellVisibilityAndreloadTableViewCellAtRow:modelIndex];
                    }];
                }
                
            }];
            [operationsArray addObject:blockOperation];
        }
        
    }
    if([operationsArray count] > 0)
    {
        [backgroundQueue addOperations:operationsArray waitUntilFinished:NO];
    }
}

-(void)checkCellVisibilityAndreloadTableViewCellAtRow:(NSInteger)rowNo
{
    //Checks the visibilty if the cell in the screen and updates the if it visible.
    
    NSArray *indexPaths = [self.tableview indexPathsForVisibleRows];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowNo inSection:0];
    __block BOOL needToReloadCell = NO;
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *obj, NSUInteger idx, BOOL *stop) {
        
        if(obj.row == indexPath.row)
        {
            needToReloadCell = YES;
            *stop = NO;
        }
    }];
    if(needToReloadCell)
    {
        [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - 
#pragma mark - ELCitiesListDelegte methods

- (void)showMapForCity:(UIButton *)sender
{
    ELCity *city = [self.citiesList objectAtIndex:sender.tag];
    NSDictionary *geometry = [city.info objectForKey:@"geometry"];
    NSDictionary *location = [geometry objectForKey:@"location"];
    
    ELCityMapViewController *mapController = [self.storyboard instantiateViewControllerWithIdentifier:@"CityMapController"];
    [mapController setLatitude:[[location objectForKey:@"lat"] doubleValue]];
    [mapController setLongitude:[[location objectForKey:@"lng"] doubleValue]];
    [self.navigationController pushViewController:mapController animated:YES];

}

- (void)markCityAsFavourite:(UIButton *)sender
{
    ELCity *city = [self.citiesList objectAtIndex:sender.tag];
    [city setIsFavorite:YES];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)swipeStarted
{
    
}

- (void)rightSwipeStarted
{
    self.indexOfCellShowingMenu = -1;
}

- (void)showMenuForSenderWithTag:(NSInteger)tag
{
    //animates the menu from within each item of the message list.
    if(-1 != self.indexOfCellShowingMenu)
    {
        ELCitiesListCell *cityCell = (ELCitiesListCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.indexOfCellShowingMenu inSection:0]];
        [cityCell hideMenuWithAnimation:NO];
    }
    self.indexOfCellShowingMenu = tag;
}

@end
