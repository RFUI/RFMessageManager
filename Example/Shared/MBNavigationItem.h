/*!
 MBNavigationItem
 
 Copyright © 2018 RFUI. All rights reserved.
 Copyright © 2015 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
 https://github.com/RFUI/MBAppKit
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import <UIKit/UIKit.h>

/**
 可以用另一个 UINavigationItem 设置 MBNavigationItem 的状态，并可以恢复原始状态
 
 典型场景：在表单页面，切换到不同的 field 时可能需要导航按钮呈现不同的状态，field 失去焦点时还原原始的状态。这个场景下 vc 使用 MBNavigationItem，不同的 field 关联响应的 UINavigationItem，就很好做。
 */
@interface MBNavigationItem : UINavigationItem

/**
 用 sorceItem 的属性设置 destinationItem
 */
+ (void)applyNavigationItem:(nonnull UINavigationItem *)sorceItem toNavigationItem:(nonnull UINavigationItem *)destinationItem animated:(BOOL)animated;

/// 将 MBNavigationItem 应用成另一个 navigationItem 的样子
- (void)applyNavigationItem:(nullable UINavigationItem *)navigationItem animated:(BOOL)animated;

/// 还原 MBNavigationItem
- (void)restoreNavigationItemAnimated:(BOOL)animated;

@end
