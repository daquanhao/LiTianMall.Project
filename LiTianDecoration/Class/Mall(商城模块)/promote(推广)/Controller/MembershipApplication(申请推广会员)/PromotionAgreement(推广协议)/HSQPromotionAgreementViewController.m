//
//  HSQPromotionAgreementViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/12.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPromotionAgreementViewController.h"
#import "HSQAccountTool.h"
#import <WebKit/WebKit.h>

@interface HSQPromotionAgreementViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation HSQPromotionAgreementViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    // 1.添加网页视图
    [self addWebViewAndProgressView];
    
    // 2.请求协议的数据
    [self RequestUserRegisterDataFromeServer];
}

/**
 * @brief 添加网页视图和进度条
 */
- (void)addWebViewAndProgressView{
    
    // 网页视图
    WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight)];
    webview.navigationDelegate = self;
    [webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    [self.view addSubview:webview];
    self.webView = webview;
    
    // 进度条
    CGFloat ProgressHeight = 2;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    UIProgressView *progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, navigationBarBounds.size.height - ProgressHeight,KScreenWidth,ProgressHeight)];
    progressView.backgroundColor = [UIColor clearColor];
    progressView.trackTintColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:progressView];
    self.progressView = progressView;
}

/**
 * @brief 请求协议的数据
 */
- (void)RequestUserRegisterDataFromeServer{
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    NSDictionary *Params = @{@"token":[HSQAccountTool account].token};
    
    [RequestTool.manger POST:UrlAdress(KGetPromotionAgreementUrl) parameters:Params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
         HSQLog(@"==%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.navigationItem.title = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"joinAgreement"][@"title"]];

            [self.webView loadHTMLString:responseObject[@"datas"][@"joinAgreement"][@"content"] baseURL:nil];
        }
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        HSQLog(@"==%@",error.description);
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出问题啦！" SupView:self.view];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// WKNavigationDelegate 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    //修改字体大小 300%
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'" completionHandler:nil];
    
    //修改字体颜色  #9098b8
    //    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#9098b8'" completionHandler:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqual: @"estimatedProgress"] && object == _webView) {
        
        [self.progressView setAlpha:1.0f];
        
        [self.progressView setProgress:_webView.estimatedProgress animated:YES];
        
        if(_webView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                [self.progressView setAlpha:0.0f];
                
            } completion:^(BOOL finished) {
                
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    [self.webView setNavigationDelegate:nil];
    
}















@end
