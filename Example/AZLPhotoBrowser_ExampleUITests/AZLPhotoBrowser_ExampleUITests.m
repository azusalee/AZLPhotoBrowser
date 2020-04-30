//
//  AZLPhotoBrowser_ExampleUITests.m
//  AZLPhotoBrowser_ExampleUITests
//
//  Created by lizihong on 2020/4/23.
//  Copyright © 2020 azusalee. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface AZLPhotoBrowser_ExampleUITests : XCTestCase

@end

@implementation AZLPhotoBrowser_ExampleUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

// 圖片瀏覽操作測試
- (void)testPhotoBrowser {
    // UI tests must launch the application that they test.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    
    // 點擊圖片，進入瀏覽
    XCUIElement *element2 = [[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    XCUIElement *element = [element2 childrenMatchingType:XCUIElementTypeOther].element;
    [[[element childrenMatchingType:XCUIElementTypeImage] elementBoundByIndex:0] tap];
    
    XCUIElementQuery *collectionViewsQuery = app.collectionViews;
    XCUIElement *image = [collectionViewsQuery/*@START_MENU_TOKEN@*/.scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ childrenMatchingType:XCUIElementTypeImage].element;
    // 滑動點擊等操作
    [image swipeUp];
    [image tap];
    [image tap];
    [image tap];
    [image tap];
    [image swipeLeft];
    [image pinchWithScale:3 velocity:1];
    sleep(2);
    [image tap];
    [image tap];
    [image pinchWithScale:0.3 velocity:-0.2];
    sleep(2);
    [image swipeLeft];
    [image swipeLeft];
    [image swipeRight];
    [image swipeRight];
    [image swipeRight];
    
    [image pressForDuration:1.3];
    [app.sheets.scrollViews.otherElements.buttons[@"\u53d6\u6d88"] tap];
    
    [image tap];
    sleep(2);
    
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

// 相冊操作測試
- (void)testAlbum{
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    
    // 點擊相冊
    [app.buttons[@"\u76f8\u518a"] tap];
    
    XCUIElementQuery *collectionViewsQuery = app.collectionViews;
   
    // 挑選圖片
    [[[[collectionViewsQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:0].otherElements childrenMatchingType:XCUIElementTypeButton].element tap];
    [[[[collectionViewsQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:1].otherElements childrenMatchingType:XCUIElementTypeButton].element tap];
    [[[[collectionViewsQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:2].otherElements childrenMatchingType:XCUIElementTypeButton].element tap];
    // 取消選擇圖片
    [[[[collectionViewsQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:2].otherElements childrenMatchingType:XCUIElementTypeButton].element tap];
    
    // 點擊圖片進入編輯
    [[[collectionViewsQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:2] tap];
    
    XCUIElement *element2 = [[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    XCUIElement *element = [[[[[element2 childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:0];
    // 選擇圖片
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1] tap];
    // 取消選擇圖片
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1] tap];
    
    XCUIElement *image = [collectionViewsQuery/*@START_MENU_TOKEN@*/.scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ childrenMatchingType:XCUIElementTypeImage].element;
    // 隱藏編輯欄
    [image tap];
    sleep(1);
    // 顯示編輯欄
    [image tap];
    // 進入詳細編輯
    [app.buttons[@"编辑"] tap];
    
    // 顯示編輯欄
    [[app.scrollViews childrenMatchingType:XCUIElementTypeImage].element tap];
    sleep(1);
    // 隱藏編輯欄
    [[app.scrollViews childrenMatchingType:XCUIElementTypeImage].element tap];
    
    // 返回
    [[[[element2 childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeButton].element tap];
    // 返回
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0] tap];
    // 完成
    [app.buttons[@"完成"] tap];
    
    // 點擊相冊
    [app.buttons[@"\u76f8\u518a"] tap];
    
    XCUIElement *staticText = app.staticTexts[@"\u5168\u90e8"];
    [staticText tap];
    [staticText tap];
    [staticText tap];
    [[app.tables.staticTexts elementBoundByIndex:0] tap];
    
    // 關閉相冊
    [app.buttons[@"\u53d6\u6d88"] tap];
    
    
}

// 圖片編輯測試
- (void)testEdit{
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    
    XCUIElement *element6 = [[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    XCUIElement *image = [[[element6 childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeImage] elementBoundByIndex:5];
    [image tap];
    
    XCUIElement *image2 = [app.scrollViews childrenMatchingType:XCUIElementTypeImage].element;
    [image2 tap];
    sleep(2);
    [image2 tap];
    
    XCUIElement *button = app.buttons[@"\u94c5"];
    [button tap];
    
    XCUIElement *element = [[image2 childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1];
    [element swipeDown];
    
    XCUIElement *element4 = [[element6 childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:2];
    XCUIElement *element2 = [[element4 childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:0];
    [element2 tap];
    [element swipeDown];
    
    XCUIElement *button2 = app.buttons[@"\u94a2"];
    [button2 tap];
    [element swipeRight];
    [[element2 childrenMatchingType:XCUIElementTypeOther].element swipeRight];
    [element swipeRight];
    [button tap];
    [button tap];
    
    XCUIElement *button3 = app.buttons[@"\u9a6c"];
    [button3 tap];
    
    XCUIElement *element3 = [[image2 childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:0];
    [element3 swipeDown];
    [element3 swipeRight];
    [button3 tap];
    [button2 tap];
    [button2 tap];
    
    XCUIElement *button4 = app.buttons[@"\u88c1"];
    [button4 tap];
    [button4 tap];
    [button4 tap];
    [app.buttons[@"\u88c1\u526a"] tap];
    [button4 tap];
    
    XCUIElement *element5 = [[element6 childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:0];
    [[element5 childrenMatchingType:XCUIElementTypeButton].element tap];
    [image tap];
    [button tap];
    
    XCUIElement *button5 = [[element4 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0];
    [button5 tap];
    [button4 tap];
    
    XCUIElement *element7 = [[element6 childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:3];
    XCUIElement *button6 = [[element7 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0];
    [button6 tap];
    [button3 tap];
    [button5 tap];
    [button5 tap];
    [button5 tap];
    [button5 tap];
    [button2 tap];
    [button5 tap];
    [button5 tap];
    
    XCUIElement *button7 = [[element4 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1];
    [button7 tap];
    [button7 tap];
    [button7 tap];
    [button tap];
    [button5 tap];
    [button5 tap];
    [button5 tap];
    [button5 tap];
    [button5 tap];
    [button5 tap];
    [button7 tap];
    [button5 tap];
    [button3 tap];
    [button7 tap];
    [button7 tap];
    [button5 tap];
    [button5 tap];
    [button4 tap];
    [[[element7 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1] tap];
    [button6 tap];
    [[[element5 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0] tap];
    sleep(2);
}

//- (void)testLaunchPerformance {
//    if (@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)) {
//        // This measures how long it takes to launch your application.
//        [self measureWithMetrics:@[XCTOSSignpostMetric.applicationLaunchMetric] block:^{
//            [[[XCUIApplication alloc] init] launch];
//        }];
//    }
//}

@end
