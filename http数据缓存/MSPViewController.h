//
//  MSPViewController.h
//  http数据缓存
//
//  Created by msp on 13-12-2.
//  Copyright (c) 2013年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@interface MSPViewController : UIViewController<ASIHTTPRequestDelegate>
{
    NSMutableData       * m_pRequestData;
    ASIDownloadCache    * m_pDoloadCache;
}
- (void)requestHttp:(UIButton*)pBtn;
- (void)clearDataCache:(UIButton*)pBtn;

@end
