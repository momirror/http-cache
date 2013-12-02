//
//  MSPViewController.m
//  http数据缓存
//
//  Created by msp on 13-12-2.
//  Copyright (c) 2013年 ___FULLUSERNAME___. All rights reserved.
//

#import "MSPViewController.h"

@interface MSPViewController ()

@end

@implementation MSPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIButton * pRequestBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pRequestBtn setFrame:CGRectMake(100, 100, 150, 20)];
    [pRequestBtn setTitle:@"请求" forState:UIControlStateNormal];
    [pRequestBtn addTarget:self action:@selector(requestHttp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pRequestBtn];
    
    UIButton * pClearCacheBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pClearCacheBtn setFrame:CGRectMake(100, 200, 150, 20)];
    [pClearCacheBtn setTitle:@"清空缓存" forState:UIControlStateNormal];
    [pClearCacheBtn addTarget:self action:@selector(clearDataCache:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pClearCacheBtn];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
	http请求
 */
- (void)requestHttp:(UIButton*)pBtn

{
    //下载一个文件
    NSURL * pUrl = [NSURL URLWithString:@"https://codeload.github.com/pokeb/asi-http-request/legacy.tar.gz/master"];
    ASIHTTPRequest * pRequest = [ASIHTTPRequest requestWithURL:pUrl];
    [pRequest setDelegate:self];
    
    //设备缓存路径及缓存策略
    NSString *cathPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    m_pDoloadCache = [[ASIDownloadCache alloc] init];
    [m_pDoloadCache setStoragePath:cathPath];
    m_pDoloadCache.defaultCachePolicy = ASIOnlyLoadIfNotCachedCachePolicy;
    
    pRequest.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
    pRequest.downloadCache = m_pDoloadCache;
    
    //跟踪看是否使用缓存
    [pRequest setCompletionBlock:^{
       if(pRequest.didUseCachedResponse)
       {
           NSLog(@"使用缓存数据");
       }
       else
       {
           NSLog(@"重新请求数据！");
       }
    }];
    
    
    [pRequest startAsynchronous];//异步请求
}

/**
	清空缓存
 */
- (void)clearDataCache:(UIButton*)pBtn

{
    [m_pDoloadCache clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
}

#pragma mark - asihttprequest delegate 
- (void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"开始请求");
    m_pRequestData = [[NSMutableData alloc] init];
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"收到响应头信息->%@",responseHeaders);
}

- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    NSLog(@"请求中。。。");
    [m_pRequestData appendData:data];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"请求结束");
    NSString * strData = [[NSString alloc] initWithData:m_pRequestData encoding:NSUTF8StringEncoding];
    NSLog(@"result->%@",strData);
    [strData release];
    

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"请求失败");
}


- (void)dealloc
{
    [m_pRequestData release];
    m_pRequestData = NULL;
    
    [m_pDoloadCache release];
    m_pDoloadCache = NULL;
    
    [super dealloc];
}


@end
