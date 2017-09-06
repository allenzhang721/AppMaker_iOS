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
  
  UICollectionView *v = [[UICollectionView alloc] initWithFrame:r collectionViewLayout:flowLayout];
  [v registerClass:[HLTableCell class] forCellWithReuseIdentifier:@"TableCell"];
  v.delegate = self;
  v.dataSource = self;
  
  v.backgroundColor = [self colorWithHexString:_entity.cellViewModel.BackgroundColor];
  
  self.uicomponent = v;
  
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
  
  NSLog(@"%@", URL);
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
  
  return cell;
}

#pragma MARK: CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    for (int i = 0; i < [_entity.behaviors count]; i++)
    {
        HLBehaviorEntity *behavior = [_entity.behaviors objectAtIndex:i];
        if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_LIST_ITEM_CLICK"])
        {
//            if ([self.container runBehaviorWithEntity:behavior])
//            {
//                return;
//            }
        }
    }
}


#pragma MARK: CollectionView flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  return CGSizeMake(MIN(_entity.cellViewModel.cellWidth, _entity.width.floatValue), _entity.cellViewModel.cellheight);
  
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  
  return UIEdgeInsetsMake(_entity.cellViewModel.top, _entity.cellViewModel.left, _entity.cellViewModel.bottom, _entity.cellViewModel.right);
}

@end
