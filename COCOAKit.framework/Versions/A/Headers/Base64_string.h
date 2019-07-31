//
//  Base64_string.h
//  DDMoney
//
//  Created by 吴昊原 on 2017/7/19.
//  Copyright © 2017年 wuhaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64_string : NSObject

+ (NSString*)encodeBase64String:(NSString* )input;

+ (NSString*)decodeBase64String:(NSString* )input;

+ (NSString*)encodeBase64Data:(NSData*)data;

+ (NSString*)decodeBase64Data:(NSData*)data;
@end
