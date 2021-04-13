//
//  NPConstant.h
//  NewsProduct
//
//  Created by yanxuezhou on 2021/4/12.
//

#ifndef NPConstant_h
#define NPConstant_h

#define NP_WINDOW [[UIApplication sharedApplication].windows firstObject]

#define NP_status_bar_h ({CGFloat statusH = 20;\
UIWindow *window= NP_WINDOW;\
if (window.windowScene) {\
    statusH=window.windowScene.statusBarManager.statusBarFrame.size.height;\
}else\
    statusH = [UIApplication sharedApplication].statusBarFrame.size.height;\
    (statusH);})
#define NP_BOTTOM_SAFE_H ({CGFloat bottomSafeH = 0;\
bottomSafeH=NP_WINDOW.safeAreaInsets.bottom;\
(bottomSafeH);})
#endif /* NPConstant_h */
