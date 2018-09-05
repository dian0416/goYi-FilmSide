//
//  UIView+ViewDebug.m
//  N+Store
//
//  Created by 米翊米 on 16/8/3.
//  Copyright © 2016年 天宫. All rights reserved.
//

#ifdef DEBUG

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "UIView+ViewDebug.h"

@implementation UIView (ViewDebug)

+ (void)load
{
    Method original = class_getInstanceMethod(self, @selector(viewForBaselineLayout));
    class_addMethod(self, @selector(viewForFirstBaselineLayout), method_getImplementation(original), method_getTypeEncoding(original));
    class_addMethod(self, @selector(viewForLastBaselineLayout), method_getImplementation(original), method_getTypeEncoding(original));
}

@end

#endif
