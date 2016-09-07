//
//  ACMacros.h
//  Nod
//
//  Created by Csaba Toth on 08/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#ifndef Nod_ACMacros_h
#define Nod_ACMacros_h

// MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

// View (x,y) (width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).bounds.size.width
#define HEIGHT(v)               (v).bounds.size.height

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)
#define RECT_CHANGE_x(v,x)          CGRectMake(x, Y(v), WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_y(v,y)          CGRectMake(X(v), y, WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_point(v,x,y)    CGRectMake(x, y, WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_width(v,w)      CGRectMake(X(v), Y(v), w, HEIGHT(v))
#define RECT_CHANGE_height(v,h)     CGRectMake(X(v), Y(v), WIDTH(v), h)
#define RECT_CHANGE_size(v,w,h)     CGRectMake(X(v), Y(v), w, h)

#define SLIDE_MENU_STYLE 0

//Color
#define Color(r,g,b,a)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
//#define NodMessageInputColor [UIColor colorWithRed:11.0f/255.0f green:76.0f/255.0f blue:103.f/255.0f alpha:1.0f]
#define NodMessageInputColor [UIColor grayColor]

#define API_URL @"http://104.43.194.176/api"
//#define API_URL @"http://nod.com/api"

//Checksums
#define strChecksum01 @"c998339034b269111d26e9ec5f07aaaadcca0b4a94b7e7d2374c5821ca82de6f"
#define strChecksum02 @"4405633f764bb876209556f8fe0a366e047ca5283c056707b48a34a665c56f5a"

#endif
