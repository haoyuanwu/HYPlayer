//
//  NSString+DES3.h
//  DDMoney
//
//  Created by 吴昊原 on 2017/8/22.
//  Copyright © 2017年 wuhaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CommonCrypto/CommonCryptor.h>
//#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"

@interface NSString (DES3)
/**
 字符串MD5加密
 */
- (NSString *)md5;

/**
 3DES加密和解密
 
 @param plainText        加密字符串
 @param encryptOrDecrypt 0 加密 1 解密
 @param key              加密的可key
 ！！！！！！！  使用此方法需要GTMBase64文件  cocoapods引用
 */
//+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key;
@end
