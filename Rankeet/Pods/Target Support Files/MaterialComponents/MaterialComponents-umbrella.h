#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MaterialAppBar.h"
#import "MDCAppBar.h"
#import "MDCAppBarContainerViewController.h"
#import "MaterialButtonBar.h"
#import "MDCButtonBar.h"
#import "MaterialButtons.h"
#import "MDCButton.h"
#import "MDCFlatButton.h"
#import "MDCFloatingButton+Animation.h"
#import "MDCFloatingButton.h"
#import "MDCRaisedButton.h"
#import "MaterialFlexibleHeader.h"
#import "MDCFlexibleHeaderContainerViewController.h"
#import "MDCFlexibleHeaderView.h"
#import "MDCFlexibleHeaderViewController.h"
#import "MaterialHeaderStackView.h"
#import "MDCHeaderStackView.h"
#import "MaterialInk.h"
#import "MDCInkGestureRecognizer.h"
#import "MDCInkTouchController.h"
#import "MDCInkView.h"
#import "MaterialNavigationBar.h"
#import "MDCNavigationBar.h"
#import "MaterialPageControl.h"
#import "MDCPageControl.h"
#import "MaterialShadowElevations.h"
#import "MDCShadowElevations.h"
#import "MaterialShadowLayer.h"
#import "MDCShadowLayer.h"
#import "MaterialTypography.h"
#import "MDCFontTextStyle.h"
#import "MDCTypography.h"
#import "UIFont+MaterialTypography.h"
#import "UIFontDescriptor+MaterialTypography.h"
#import "MaterialApplication.h"
#import "UIApplication+AppExtensions.h"
#import "MaterialIcons.h"
#import "MDCIcons+BundleLoader.h"
#import "MDCIcons.h"
#import "MaterialIcons+ic_arrow_back.h"
#import "MaterialMath.h"
#import "MDCMath.h"
#import "MaterialUIMetrics.h"
#import "MDCLayoutMetrics.h"

FOUNDATION_EXPORT double MaterialComponentsVersionNumber;
FOUNDATION_EXPORT const unsigned char MaterialComponentsVersionString[];

