//
//  IAPPurchseHandle.h
//  IAPpurchse2_TEST
//
//  Created by Mouee-iMac on 13-10-16.
//  Copyright (c) 2013年 Organization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef void (^updatedTransactionsBlock)(SKPaymentQueue *queue,NSArray * transactions);
typedef void (^requestdidReceiveResponseBlock)(SKProductsRequest *request, SKProductsResponse * response);
typedef void (^compeleteTransactionBlock)(SKPaymentTransaction * transaction);
typedef void (^FailedTransactionBlock)(SKPaymentTransaction * transaction);
typedef void (^RestoredTransactionBlock)(SKPaymentTransaction * transaction);
typedef void (^requestDidFinishBlock)(SKRequest * request);
typedef void (^didFailWithErrorBlock)(SKRequest * request, NSError * error);

@interface IAPPurchseHandle : NSObject<SKPaymentTransactionObserver,SKProductsRequestDelegate,SKRequestDelegate>

@property (copy, nonatomic) updatedTransactionsBlock       updatedTransactionsBlock;
@property (copy, nonatomic) requestdidReceiveResponseBlock requestdidReceiveResponseBlock;
@property (copy, nonatomic) compeleteTransactionBlock      compeleteTransactionBlock;
@property (copy, nonatomic) FailedTransactionBlock         failedTransactionBlock;
@property (copy, nonatomic) RestoredTransactionBlock       restoredTransactionBlock;
@property (copy, nonatomic) requestDidFinishBlock          requestDidFinishBlock;
@property (copy, nonatomic) didFailWithErrorBlock          didFailWithErrorBlock;

+(IAPPurchseHandle *)shareInstance;

- (BOOL) canMakePayment;    //判断能否进行购买
- (void)getProductInfoWithPoductID:(NSString *)productID;   //根据产品ID获取

@end
