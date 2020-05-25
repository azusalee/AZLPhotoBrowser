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
    //[image swipeUp];
    [image tap];
    [image tap];
    [image tap];
    [image tap];
    sleep(2);
    [image pinchWithScale:3 velocity:1];
    sleep(2);
    [image tap];
    [image tap];
    [image pinchWithScale:0.3 velocity:-0.2];
    sleep(2);
    [image swipeLeft];
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
    
    XCUIElement *window = [[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0];
    XCUIElement *element6 = [[window childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    XCUIElement *image = [[[element6 childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeImage] elementBoundByIndex:5];
    [image tap];
    
    XCUIElement *button = app.buttons[@"\u7b14"];
    [button tap];
    [button tap];
    
    XCUIElement *button2 = app.buttons[@"\u9a6c"];
    [button2 tap];
    [button2 tap];
    
    XCUIElement *button3 = app.buttons[@"\u88c1"];
    [button3 tap];
    [button3 tap];
    
    XCUIElement *button4 = app.buttons[@"\u8d34"];
    [button4 tap];
    [button4 tap];
    [button tap];
    [app.buttons[@"\u94c5"] tap];
    
    XCUIElement *element = [[element6 childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:2];
    [[[element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] tap];
    
    XCUIElement *image2 = [app.scrollViews childrenMatchingType:XCUIElementTypeImage].element;
    XCUIElement *element2 = [[image2 childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1];
    [element2 swipeDown];
    [element2 swipeDown];
    [app.buttons[@"\u94a2"] tap];
    [element2 swipeDown];
    [element2 swipeDown];
    [button2 tap];
    
    XCUIElement *element3 = [[image2 childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:0];
    [element3 swipeRight];
    [element3 swipeDown];
    
    XCUIElement *button5 = [[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0];
    [button5 tap];
    [button5 tap];
    
    XCUIElement *button6 = [[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1];
    [button6 tap];
    [button6 tap];
    [button tap];
    
    XCUIElement *button7 = [[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:2];
    [button7 tap];
    [button7 tap];
    [button7 tap];
    [button7 tap];
    [button7 tap];
    
    XCUIElement *button8 = [[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:3];
    [button8 tap];
    [button8 tap];
    [button8 tap];
    [button8 tap];
    [button8 tap];
    [button4 tap];
    [app.buttons[@"\u6dfb\u52a0"] tap];
    
    XCUIElement *aKey = app/*@START_MENU_TOKEN@*/.keys[@"A"]/*[[".keyboards.keys[@\"A\"]",".keys[@\"A\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [aKey tap];
    
    XCUIElement *bKey = app/*@START_MENU_TOKEN@*/.keys[@"b"]/*[[".keyboards.keys[@\"b\"]",".keys[@\"b\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [bKey tap];
    
    XCUIElement *cKey = app/*@START_MENU_TOKEN@*/.keys[@"c"]/*[[".keyboards.keys[@\"c\"]",".keys[@\"c\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [cKey tap];
    
    XCUIElement *dKey = app/*@START_MENU_TOKEN@*/.keys[@"d"]/*[[".keyboards.keys[@\"d\"]",".keys[@\"d\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [dKey tap];
    
    XCUIElement *eKey = app/*@START_MENU_TOKEN@*/.keys[@"e"]/*[[".keyboards.keys[@\"e\"]",".keys[@\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [eKey tap];
    
    XCUIElement *fKey = app/*@START_MENU_TOKEN@*/.keys[@"f"]/*[[".keyboards.keys[@\"f\"]",".keys[@\"f\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [fKey tap];
    
    XCUIElement *gKey = app/*@START_MENU_TOKEN@*/.keys[@"g"]/*[[".keyboards.keys[@\"g\"]",".keys[@\"g\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [gKey tap];
    
//    XCUIElement *element4 = [[[window.scrollViews childrenMatchingType:XCUIElementTypeImage].element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:2];
//    
//    XCUIElement *textView = [[[[[app.scrollViews childrenMatchingType:XCUIElementTypeImage].element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:2] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeTextView].element;
//    [textView swipeUp];
//    [element4 tap];
    XCUIElement *button9 = [[[element6 childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeButton].element;
    [button9 tap];
    [image tap];
    
    [image2 tap];
    sleep(1);
    [image2 tap];
    
    [button3 tap];
   
    [app.buttons[@"\u88c1\u526a"] tap];
    
    XCUIElement *element5 = [[element6 childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:3];
    [[[element5 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1] tap];
    [[[element5 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:2] tap];
    
    
    [button9 tap];
    
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
