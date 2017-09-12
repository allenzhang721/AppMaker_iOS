//
//  HLTableComponent.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 25/10/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLTableComponent.h"
#import "HLTableCell.h"
#import "HLBehaviorEntity.h"

static NSUInteger count = 2;

@interface HLTableComponent () {
  NSUInteger defaultCount;
}

@property(nonatomic, strong) NSArray<NSDictionary<NSString *, id> *> *items;
@property(nonatomic, assign) BOOL firstRequstSuccess;

@end

@implementation HLTableComponent


- (id)initWithEntity:(HLContainerEntity *) entity
{
  self = [super init];
  if (self)
  {
    self.entity    = (HLTableEntity *)entity;
    //        self.customHeight = true;
    self.items = @[];
    [self p_setupUI];
  }
  return self;
}

- (void)p_setupUI {
  
  CGRect r = CGRectMake([_entity.x floatValue], [_entity.y floatValue], [_entity.width floatValue], [_entity.height floatValue]);
  
  UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
  
  _collectionView = [[UICollectionView alloc] initWithFrame:r collectionViewLayout:flowLayout];
  [_collectionView registerClass:[HLTableCell class] forCellWithReuseIdentifier:@"TableCell"];
  _collectionView.delegate = self;
  _collectionView.dataSource = self;
  
  _collectionView.backgroundColor = [self colorWithHexString:_entity.cellViewModel.BackgroundColor];
  
  self.uicomponent = _collectionView;
  
  defaultCount = [_entity.height floatValue] / _entity.cellViewModel.cellheight;
  
  if (_firstRequstSuccess == NO) {
    [self sendRequest:nil];
  }
  
}

//- (void)beginView {
//  [super beginView];
//  
//}

- (void)loadData:(NSData *)data {
//    [self alertResult:@"Will Load Data"];
  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//  count = [dic[@"count"] floatValue];
  
    NSArray<NSDictionary<NSString *, NSString *> *> *items = nil;
    NSString *parent = _entity.modelParent;
    if(![parent isEqualToString:@""]){
//        [self alertResult:@"Parent is Array"];
        @try {
            items = (NSArray *)[dic valueForKeyPath:parent];
//            [self alertResult:@"Get Parent's Array"];
        } @catch (NSException *exception) {
//            [self alertResult:@"Get Parent's Array Wrong"];
        } @finally {
        }
    }else {
//        [self alertResult:@"Parent is Dic"];
//        [self alertResult:@"Get Parent's Dic"];
        items = dic;
    }
  self.items = items;
  
  [(UICollectionView *)self.uicomponent reloadData];
    
//    [self alertResult:@"Did Load Data"];
}

//- (void)alertResult:(NSString *)result {
//    
//    UILabel *label =[uicomponent viewWithTag:666];
//    
//    if ( label == nil) {
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, 300, 400))];
//        label.tag = 666;
//        label.numberOfLines = 0;
//        
//        [uicomponent addSubview:label];
//    }
//    
//    NSString *text = label.text != nil ? label.text : @"";
//    [label setText:[text stringByAppendingString:[NSString stringWithFormat:@"\n%@", result]]];
//    
//    
////    
////    [alert addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
////    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:true completion:nil];
//}

- (void)sendRequest:(id)sender
{
  /* Configure session, choose between:
   * defaultSessionConfiguration
   * ephemeralSessionConfiguration
   * backgroundSessionConfigurationWithIdentifier:
   And set session-wide properties, such as: HTTPAdditionalHeaders,
   HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
   */
  
//  _entity.request.header = @"http://";
//  _entity.request.url = @"cta.curiosapp.com/publish/newPublishList";
//  _entity.request.requestType = @"POST";
//  _entity.request.parameters = @[@{@"data": @"{\"userID\":\"\",\"start\":0,\"size\":10}"}];
//  NSString * s = _entity.request.url;
  
  if (_entity.request.url == nil || [_entity.request.url isEqualToString:@""]) {
    return;
  }
  
  NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
  
  /* Create session, and optionally set a NSURLSessionDelegate. */
  NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
  
  /* Create the Request:
   Request (POST http://cta.curiosapp.com/publish/newPublishList)
   */
  
  NSURL* URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", _entity.request.header, _entity.request.url]];
  
  NSMutableDictionary *URLParams = [@{} mutableCopy];
  
  for (NSDictionary *dic in _entity.request.parameters) {
    for (NSString *key in dic.allKeys) {
      [URLParams setObject:dic[key] forKey:key];
    }
  }
  
//  NSDictionary* URLParams = @{
//                              @"data": @"{\"userID\":\"\",\"start\":0,\"size\":10}",
//                              };
  if (URLParams.count > 0) {
    URL = NSURLByAppendingQueryParameters(URL, URLParams);
  }
  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
  request.HTTPMethod = _entity.request.requestType;
  
  // Headers
  
  [request addValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
  
  /* Start a new Task */
  __block typeof(self) ws = self;
  NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error == nil) {
      // Success
      NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
      if ((ws == nil) || !([ws isKindOfClass:[HLTableComponent class]])) {
        return;
      }
      if ((ws != nil) && [ws isKindOfClass:[HLTableComponent class]]) {
      
        dispatch_async(dispatch_get_main_queue(), ^{
          if ([ws respondsToSelector:@selector(loadData:)]) {
            ws.firstRequstSuccess = YES;
//              [ws alertResult:@"Response Success"];
            [ws loadData:data];
              
              
          }
        });
      }
    }
    else {
      // Failure
      NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        
//        [self alertResult:[error localizedDescription]];
    }
  }];
  [task resume];
  [session finishTasksAndInvalidate];
}

/*
 * Utils: Add this section before your class implementation
 */

/**
 This creates a new query parameters string from the given NSDictionary. For
 example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
 string will be @"day=Tuesday&month=January".
 @param queryParameters The input dictionary.
 @return The created parameters string.
 */
static NSString* NSStringFromQueryParameters(NSDictionary* queryParameters)
{
  NSMutableArray* parts = [NSMutableArray array];
  [queryParameters enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
    NSString *part = [NSString stringWithFormat: @"%@=%@",
                      [key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding],
                      [value stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]
                      ];
    [parts addObject:part];
  }];
  return [parts componentsJoinedByString: @"&"];
}

/**
 Creates a new URL by adding the given query parameters.
 @param URL The input URL.
 @param queryParameters The query parameter dictionary to add.
 @return A new NSURL.
 */
static NSURL* NSURLByAppendingQueryParameters(NSURL* URL, NSDictionary* queryParameters)
{
  NSString* URLString = [NSString stringWithFormat:@"%@?%@",
                         [URL absoluteString],
                         NSStringFromQueryParameters(queryParameters)
                         ];
  return [NSURL URLWithString:URLString];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
  if (_items != nil && !([_items isKindOfClass:[NSNull class]])) {
    return _items.count;
  } else {
    return defaultCount;
  }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  HLTableCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TableCell" forIndexPath:indexPath];
  
  [cell configWithViewModels:_entity.cellViewModel entity:_entity];
  [cell configWithBindingModels:_entity.bindingModels];
  if (_items != nil && !([_items isKindOfClass:[NSNull class]]) && _items.count > 0) {
    [cell configWithData:_items[indexPath.item]];
//      [self alertResult:[NSString stringWithFormat:@"cell configed: %@", content]];
  }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
    cell.userInteractionEnabled = true;
    [cell addGestureRecognizer:tap];
    
   // cell.contentView.backgroundColor = [UIColor yellowColor];
  
  return cell;
}

- (void)imageTap:(UITapGestureRecognizer *)recognizer {
    
    HLTableCell *cell = (HLTableCell*)recognizer.view;
    if(cell != nil)
    {
        NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
        for (int i = 0; i < [_entity.behaviors count]; i++)
        {
            /*
             2、	列表(Table List)子项点击事件
             2.1、列表子项点击事件
             事件名称：BEHAVIOR_ON_LIST_ITEM_CLICK
             事件属性：为JSON字符  eg： {“key”:”publishID”,”value”:”aaaaa”}，当点击子项(cell中的子元素)对应的数据拥有key值属性((entity.bingdingModels.modelKey)，同时该属性等于 value值时，触发点击事件
             
             for example:
             behavior.behaviorValue = {"value":"2328AB28C0E642709F98F2D0026B3111/page","key":"publishURL"}
             _items =
             [
             {
             commentCount = 0;
             likeCount = 2;
             likeStatus = 0;
             nickName = "\U6625\U96e8\U6f47\U6f47";
             previewIconURL = "1A4639AD9A184A329016685F14A23AAE/43732.jpg";
             publishDate = "2017/02/03 07:47:40";
             publishDesc = "";
             publishID = 1A4639AD9A184A329016685F14A23AAE;
             publishIconURL = "1A4639AD9A184A329016685F14A23AAE/1BC3C.jpg";
             publishURL = "1A4639AD9A184A329016685F14A23AAE/page";
             rebuildCount = 0;
             relationType = 0;
             sex = 2;
             shareCount = 0;
             title = "";
             userDesc = "";
             userID = 248964a031a24ba48003a5139e5d1b32;
             userIconURL = "";
             }
             ]
             
             
             2.2、列表任意子项点击事件
             事件名称：BEHAVIOR_ON_LIST_EACHITEM_CLICK
             当任意子项被点击时，触发此事件
             
             2.3、点击触发通过属性值跳转外链
             列表中新增两个属性 IsClickOpenBrowser 和 ClikcOpenKey,
             IsClickOpenBrowser 是布尔型数据， 当为true 的时候
             当点击子项对应的数据拥有ClikcOpenKey 属性，以此属性为链接跳转。
             */
            
            HLBehaviorEntity *behavior = [_entity.behaviors objectAtIndex:i];
            if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_LIST_ITEM_CLICK"])
            {
                NSString *keyValue = behavior.behaviorValue; // {"value":"2328AB28C0E642709F98F2D0026B3111/page","key":"publishURL"}
                
                id dic = [NSJSONSerialization JSONObjectWithData:[keyValue dataUsingEncoding: NSUTF8StringEncoding] options:0 error:NULL];
                
                if (dic != NULL) {
                    NSString *key = dic[@"key"];
                    NSString *value = dic[@"value"];
                    NSString *indexValue = _items[indexPath.item][key];
                    if ([indexValue isEqualToString:value]) {
                        [self.container runBehaviorWithEntity:behavior];
                    }
                }
            }
            
            if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_LIST_EACHITEM_CLICK"])
            {
                [self.container runBehaviorWithEntity:behavior];
            }
        }
        if (_entity.isClickOpenBrowser == YES) {
            NSString *clikcOpenKeyValue = _items[indexPath.item][_entity.clikcOpenKey];
            if (clikcOpenKeyValue != NULL) {
                NSURL *url = [NSURL URLWithString:clikcOpenKeyValue];
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}

#pragma MARK: CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //[collectionView cellForItemAtIndexPath:indexPath].contentView.backgroundColor = [UIColor redColor];

//    
//    for (int i = 0; i < [_entity.behaviors count]; i++)
//    {
//        
//        HLBehaviorEntity *behavior = [_entity.behaviors objectAtIndex:i];
//        if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_LIST_ITEM_CLICK"])
//        {
//            NSString *keyValue = behavior.behaviorValue; // {"value":"2328AB28C0E642709F98F2D0026B3111/page","key":"publishURL"}
//            
//            id dic = [NSJSONSerialization JSONObjectWithData:[keyValue dataUsingEncoding: NSUTF8StringEncoding] options:0 error:NULL];
//            
//            if (dic != NULL) {
//                NSString *key = dic[@"key"];
//                NSString *value = dic[@"value"];
//                if ([_items[indexPath.item][key] isEqualToString:value]) {
//                    [self.container runBehaviorWithEntity:behavior];
//                }
//            }
//        }
//        
//        if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_LIST_EACHITEM_CLICK"])
//        {
//            [self.container runBehaviorWithEntity:behavior];
//        }
//    }
//    if (_entity.isClickOpenBrowser == YES) {
//        NSString *ClikcOpenKeyValue = _items[indexPath.item][_entity.clikcOpenKey];
//        if (ClikcOpenKeyValue != NULL) {
//            NSURL *url = [NSURL URLWithString:ClikcOpenKeyValue];
//            [[UIApplication sharedApplication] openURL:url];
//        }
//    }
}


#pragma MARK: CollectionView flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  return CGSizeMake(MIN(_entity.cellViewModel.cellWidth, _entity.width.floatValue), _entity.cellViewModel.cellheight);
  
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  
  return UIEdgeInsetsMake(_entity.cellViewModel.top, _entity.cellViewModel.left, _entity.cellViewModel.bottom, _entity.cellViewModel.right);
}

@end
