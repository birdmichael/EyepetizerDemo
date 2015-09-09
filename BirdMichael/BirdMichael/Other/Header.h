//
//  Header.h
//  kaiyan
//
//  Created by 李 阳 on 15/9/2.
//  Copyright (c) 2015年 BirdMIchael. All rights reserved.
//

#ifndef kaiyan_Header_h
#define kaiyan_Header_h

/**
 *  个人常用宏
 *
 *  @param r 红
 *  @param g 绿
 *  @param b 蓝
 *
 *  @return UIcolor
 */
#define BMcolor(r ,g ,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define BMcolorWithAlpha(r ,g ,b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#endif
/**
 *  屏幕尺寸
 */
#define ScreenSize [[UIScreen mainScreen] bounds].size



/** font */
#define Font_EnglishFont(FontSize) [UIFont fontWithName:@"Lobster 1.4" size:FontSize]
#define Font_ChinaBold(FontSize) [UIFont fontWithName:@"FZLTZCHJW--GB1-0" size:FontSize]
#define Font_China(FontSize) [UIFont fontWithName:@"FZLTXIHJW--GB1-0" size:FontSize]

#define coverViewColor [UIColor colorWithRed:(20)/255.0 green:(20)/255.0 blue:(20)/255.0 alpha:0.2]
