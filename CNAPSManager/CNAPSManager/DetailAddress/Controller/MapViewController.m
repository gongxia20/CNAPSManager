//
//  MapViewController.m
//  CNAPSManager
//
//  Created by James on 2019/3/22.
//  Copyright © 2019 James. All rights reserved.
// 工商银行

#import "MapViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface MapViewController ()<BMKMapViewDelegate, BMKPoiSearchDelegate>
@property (nonatomic, strong) BMKMapView *mapView;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"位置仅供参考";
    
    // 进入界面强行关闭键盘
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    _mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    
    [_mapView setZoomLevel:10];
    //显示比例尺
    _mapView.showMapScaleBar = YES;
//    [_mapView setMapType:BMKMapTypeStandard]; //切换为标准地图
//    [_mapView setMapType:BMKMapTypeSatellite]; //切换为卫星地图
    
    //显示定位图层
//    _mapView.showsUserLocation = YES;
    
    // 1.初始化POI城市检索对象
    BMKPoiSearch *poiSearch = [[BMKPoiSearch alloc] init];
    // 2.设置POI城市检索代理
    poiSearch.delegate = self;  //此处需要先遵循协议<BMKPoiSearchDelegate>
    // 3.构造POI城市检索参数
    //初始化请求参数类BMKCitySearchOption的实例
    BMKPOICitySearchOption *cityOption = [[BMKPOICitySearchOption alloc] init];
    //检索关键字，必选。举例：小吃
//    cityOption.keyword = @"小吃";
    cityOption.keyword = self.branchBankName;

    //区域名称(市或区的名字，如北京市，海淀区)，最长不超过25个字符，必选
//    cityOption.city = @"北京市";
    cityOption.city = self.branchBankName;

    //检索分类，可选，与keyword字段组合进行检索，多个分类以","分隔。举例：美食,烧烤,酒店
    cityOption.tags = @[@"美食",@"烧烤"];
    //区域数据返回限制，可选，为YES时，仅返回city对应区域内数据
    cityOption.isCityLimit = YES;
    //POI检索结果详细程度
    //cityOption.scope = BMK_POI_SCOPE_BASIC_INFORMATION;
    //检索过滤条件，scope字段为BMK_POI_SCOPE_DETAIL_INFORMATION时，filter字段才有效
    //cityOption.filter = filter;
    //分页页码，默认为0，0代表第一页，1代表第二页，以此类推
    cityOption.pageIndex = 0;
    //单次召回POI数量，默认为10条记录，最大返回20条
    cityOption.pageSize = 10;
    
    
    // 4.发起地点输入提示检索请求
    BOOL flag = [poiSearch poiSearchInCity:cityOption];
    if (flag) {
        NSLog(@"POI城市内检索成功");
    }  else  {
        NSLog(@"POI城市内检索失败");
    }

    
    [self.view addSubview:_mapView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.view endEditing:YES];

    [_mapView viewWillAppear];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
}


#pragma mark - BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误码，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPOISearchResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    //BMKSearchErrorCode错误码，BMK_SEARCH_NO_ERROR：检索结果正常返回
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"检索结果返回成功：%@",poiResult.poiInfoList);
        NSMutableArray *annotations = [NSMutableArray array];
        for (NSUInteger i = 0; i < poiResult.poiInfoList.count; i ++) {
            //POI信息类的实例
            BMKPoiInfo *POIInfo = poiResult.poiInfoList[i];
            //初始化标注类BMKPointAnnotation的实例
            BMKPointAnnotation *annotaiton = [[BMKPointAnnotation alloc]init];
            //设置标注的经纬度坐标
            annotaiton.coordinate = POIInfo.pt;
            //设置标注的标题
            annotaiton.title = POIInfo.name;
            [annotations addObject:annotaiton];
        }
        //将一组标注添加到当前地图View中
        [_mapView addAnnotations:annotations];
        BMKPointAnnotation *annotation = annotations[0];
        //设置当前地图的中心点
        _mapView.centerCoordinate = annotation.coordinate;
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD) {
        NSLog(@"检索词有歧义");
    } else {
        NSLog(@"其他检索结果错误码相关处理");
    }
}
@end
