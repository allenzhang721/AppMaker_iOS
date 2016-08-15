     //
//  IAPPurchseHandle.m
//  IAPpurchse2_TEST
//
//  Created by Mouee-iMac on 13-10-16.
//  Copyright (c) 2013年 Organization. All rights reserved.
//

#import "HLIAPPurchseHandle.h"

@interface HLIAPPurchseHandle ()
{
    UIAlertView *alertView;
}

@end

@implementation HLIAPPurchseHandle

+(HLIAPPurchseHandle *)shareInstance{
    
    static HLIAPPurchseHandle *handle = nil;
    
    if (!handle) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            handle = [[HLIAPPurchseHandle alloc] init];
            [[SKPaymentQueue defaultQueue] addTransactionObserver:handle];
        });
    }
    return handle;
}

//判断能否进行购买
- (BOOL) canMakePayment{
    
    return [SKPaymentQueue canMakePayments];
}

//根据产品ID获取
- (void)getProductInfoWithPoductID:(NSString *)productID{
    NSLog(@"productID:%@",productID);

    NSSet *nsset = [NSSet setWithArray:@[productID]];
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    request.delegate=self;
    [request start];
    alertView = [[UIAlertView alloc] initWithTitle:Nil message:NSLocalizedString(@"Connectting to Apple Server...",NULL) delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
}

//交易成功处理
- (void)completeTransaction:(SKPaymentTransaction *)trasaction{
    
    if (self.compeleteTransactionBlock)
    {
        _compeleteTransactionBlock(trasaction);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: trasaction];
    
}

//交易失败处理
- (void)failedTransaction:(SKPaymentTransaction *)trasaction
{
    NSLog(@"transaction.errordescription:%@",trasaction.error.description);
    if (self.failedTransactionBlock)
    {
        _failedTransactionBlock(trasaction);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: trasaction];
}

//交易恢复处理
- (void)restoreTransaction:(SKPaymentTransaction *)trasaction
{
    if (self.restoredTransactionBlock)
    {
        _restoredTransactionBlock(trasaction);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: trasaction];
}

#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    
    if (self.updatedTransactionsBlock) {
        _updatedTransactionsBlock(queue,transactions);
    }
    
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
                NSLog(@"transactionIdentifier = %@", transaction.transactionIdentifier);
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                NSLog(@"SKPaymentTransactionStateFailed");
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                NSLog(@"SKPaymentTransactionStateRestored");
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"商品添加进列表");
                break;
            default:
                break;
        }
    }
}

#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    
    if (self.requestdidReceiveResponseBlock) {
        _requestdidReceiveResponseBlock(request, response);
    }
    
    NSArray *products = response.products;
    for(SKProduct *product in products){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
    }
    
    if (products.count == 0)
    {
        
        NSString *attention = nil;
        NSString *failGet = nil;
        NSString *confirm = nil;
        
        attention = kAttention;
        failGet = kPurchseFail;
//        cancel = kCancel;
        confirm = kConfire;
        
//#if SIMP == 1
//        attention = @"提醒";
//        failGet = @"无法获取产品信息，购买失败";
//        confirm = @"确定";
//#elif TAIWAN == 1
//        attention = @"确定";
//        failGet = @"無法獲取產品信息，購買失敗";
//        confirm = @"";
//        
//#elif JAP == 1
//        attention = @"情報";
//        failGet = @"購入失敗";
//        confirm = @"確定";
//#endif
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:attention message:failGet delegate:Nil cancelButtonTitle:confirm otherButtonTitles:nil,nil];
        [alert show];
        [alert release];
    }
    else
    {
        SKPayment * payment = [SKPayment paymentWithProduct:products[0]];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    
}


#pragma mark - SKRequestDelegate
- (void)requestDidFinish:(SKRequest *)request{
    
    if (self.requestDidFinishBlock) {
        _requestDidFinishBlock(request);
    }
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
    [alerView release];

    if (self.didFailWithErrorBlock) {
        _didFailWithErrorBlock(request, error);
    }
}

- (void)dealloc{
    
    Block_release(_compeleteTransactionBlock);
    Block_release(_restoredTransactionBlock);
    Block_release(_failedTransactionBlock);
    Block_release(_updatedTransactionsBlock);
    Block_release(_requestdidReceiveResponseBlock);
    Block_release(_requestDidFinishBlock);
    Block_release(_didFailWithErrorBlock);
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
    [super dealloc];
}

@end
