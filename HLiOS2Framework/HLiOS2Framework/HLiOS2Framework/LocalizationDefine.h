//
//  LocalizationDefine.h
//  MoueeiOS2Framework
//
//  Created by 星宇陈 on 13-11-22.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#ifndef MoueeiOS2Framework_LocalizationDefine_h
#define MoueeiOS2Framework_LocalizationDefine_h



#endif

/*
 "Attention"                         = "提示";
 "Password"                          = "密码";
 "Password is wrong"                 = "密码错误";
 "Connection timeout"                = "连接超时";
 "Purchse"                           = "购买";
 "Purchse Fail"                      = "购买失败";
 "Cancel"                            = "取消";
 "the book has out if date"          = "电子书过期";
 "the bookID or password is wrong"   = "书籍id或密码错误";
 "unkown error"                      = "未知错误";
 "User forbid Purchsing"             = "失败，用户禁止应用内购买";
 "Confirm Purching ?"                = "将要看到的为付费页，确定要购买吗?";
 "Confire"                           = "确定";
 
 
 "Saving"                            = "保存している";
 "Are you sure want to clear?"       = "あなたを空にしますか？";
 */
#define kLocalStringsTableName @"InfoPlist"
#define kResourceBundleName @"appMakerResources.bundle"

#define kResourceBundlePath [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kResourceBundleName]
#define kResourceBundle [NSBundle bundleWithPath:kResourceBundlePath]

#define kAttention                        NSLocalizedStringFromTableInBundle(@"Attention", kLocalStringsTableName, kResourceBundle, @"")
//#define kPassword                         NSLocalizedStringFromTableInBundle(@"Attention", @"kLocalStringsTableName", kResourceBundle, @"")
//#define kPasswordIsWrong                  NSLocalizedString(@"Password is wrong",               @"密码错误")
//#define kConnectionTimeout                NSLocalizedString(@"Connection timeout",              @"连接超时")
#define kPurchse                          NSLocalizedStringFromTableInBundle(@"Purchase", kLocalStringsTableName, kResourceBundle, @"")
#define kPurchseFail                      NSLocalizedStringFromTableInBundle(@"PurchaseFail", kLocalStringsTableName, kResourceBundle, @"")
#define kCancel                           NSLocalizedStringFromTableInBundle(@"cancel", kLocalStringsTableName, kResourceBundle, @"")
//#define kTheBookHasOutOfDate              NSLocalizedString(@"the book has out if date",        @"电子书过期")
//#define kTheBookIDOrPasswordIsWrong       NSLocalizedString(@"the bookID or password is wrong", @"书籍id或密码错误")
//#define kUnkownError                      NSLocalizedString(@"unkown error",                    @"未知错误")
#define kUserForbidPurchsing              NSLocalizedStringFromTableInBundle(@"CancelPurchase", kLocalStringsTableName, kResourceBundle, @"")
#define kConfirmPurching                  NSLocalizedStringFromTableInBundle(@"whetherPurchase", kLocalStringsTableName, kResourceBundle, @"")
#define kConfire                          NSLocalizedStringFromTableInBundle(@"confirm", kLocalStringsTableName, kResourceBundle, @"")
#define kSaving                           NSLocalizedStringFromTableInBundle(@"saving", kLocalStringsTableName, kResourceBundle, @"")
#define kSureToClear                      NSLocalizedStringFromTableInBundle(@"cleanAll", kLocalStringsTableName, kResourceBundle, @"")
//added by Adward 13-11-26
#define kNotice                           NSLocalizedString(@"You have not installed Wechat!",     @"您还没有安装微信!")

