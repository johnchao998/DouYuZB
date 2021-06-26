//
//  RecommendViewModel.swift
//  DYZB
//
//  Created by John on 2021/6/20.
//

import UIKit

class RecommendViewModel {

    //MARK:- 懒加载属性 主播数组
    //提供给外部使用，不要private
    lazy var anchorGroups : [AnchorGroup] = [AnchorGroup]()
    lazy var cycleModels : [CycleModel] = [CycleModel]()
    private lazy var bigDataGroups : AnchorGroup = AnchorGroup()
    private lazy var prettyGroups : AnchorGroup = AnchorGroup()
}

// MARK:-发送网络请求
extension RecommendViewModel{
    //数据请求完成后，回调闭包函数
    func requestData(_ finishCallback : @escaping () -> ()){
        //定义通用参数
        let paramters = ["limit":"4","offset":"0","time":NSDate.getCurrentTime()]
        //0.注意请求数据是异步执行，接收到的数据不一定是按请求的数据回复
        
        let dGroup = DispatchGroup()
        //1.请求第一部分推荐数据
        dGroup.enter()
        NetWorkRequest.sharedInstance.requestData(.get, URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom",parameters:["time":NSDate.getCurrentTime()]){
            (result) in
            //1.将result转成字典类型 {"error":0,"data":[]} 两个对象
            guard let resultDict = result as? [String : NSObject] else { return }
            print("推荐resultDict字典个数"+"\(resultDict.count)")
            
            //2.根据data的key，获取数组，解析 data对象数组
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            print("推荐data数组个数："+"\(dataArray.count)")
            
            //3.遍历数组，获取字典，并且将字典转成模型对象
        
            //3.1 设置组的属性
            self.bigDataGroups.tag_name = "推荐"
            self.bigDataGroups.icon_name = "home_header_hot"
            
            //3.2获取推荐数据
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.bigDataGroups.anchors.append(anchor)
                print("推荐主播："+"\(anchor.nickname)")
            }
            
            //3.4.离开组
            dGroup.leave()
            
        }
        
        //2.请求第二部分颜值数据
        dGroup.enter()
        NetWorkRequest.sharedInstance.requestData(.get, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom",parameters:paramters){
            (result) in
            //1.将result转成字典类型 {"error":0,"data":[]} 两个对象
            guard let resultDict = result as? [String : NSObject] else { return }
            print("颜值resultDict字典个数"+"\(resultDict.count)")
            
            //2.根据data的key，获取数组，解析 data对象数组
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            print("颜值data数组个数："+"\(dataArray.count)")
            
            //3.遍历数组，获取字典，并且将字典转成模型对象
            
            //3.1 设置组的属性
            self.prettyGroups.tag_name = "颜值"
            self.prettyGroups.icon_name = "home_header_phone"
            
            //3.2获取主播数据
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.prettyGroups.anchors.append(anchor)
                print("颜值主播："+"\(anchor.nickname)")
            }
            //3.4.离开组
            dGroup.leave()
            
        }
        
        //3.请求2-12部分游戏数据
        //http://capi.douyucdn.cn/api/v1/getHotCate?limit=4&offset=0&time=1624161106
        dGroup.enter()
        NetWorkRequest.sharedInstance.requestData(.get, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate",parameters:paramters){
            (result) in
            //print(result)
            /**JOSN数据格式如：{"error":0,"data":[ {"icon_url":"http","room_list":[{},{}]}, {} ]}*/
            print("游戏数据*********************")
            
            //1.将result转成字典类型 {"error":0,"data":[]} 两个对象
            guard let resultDict = result as? [String : NSObject] else { return }
            print("resultDict字典个数"+"\(resultDict.count)")
            
            //2.根据data的key，获取数组，解析 data对象数组
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            print("data数组个数："+"\(dataArray.count)")
            
            //3.遍历数组，获取字典，并且将字典转成模型对象
            for dict in dataArray {
                let group = AnchorGroup(dict : dict)
                
                self.anchorGroups.append(group)
            }
            
            for group in self.anchorGroups{
                //print("tag_name:"+"\(group.tag_name)")
                for anchor in group.anchors{
                    print("主播昵称："+"\(anchor.nickname)")
                }
                print("--------")
              
            }
            //4.离开组
            dGroup.leave()
            
        }
        
        //6.所有数据都请求到，之后再进行排序,把推荐与颜值组的数据加入到anchorGroups组中
        dGroup.notify(queue: .main) {
            print("所有数据请求完毕")
            self.anchorGroups.insert(self.prettyGroups, at: 0)
            self.anchorGroups.insert(self.bigDataGroups, at: 0)
            
            //回调外部函数
            finishCallback()
        }
    }
    
    //轮播数据请求完成后，回调闭包函数
    func requestCycleData(_ finishCallback : @escaping () -> ()){
        NetWorkRequest.sharedInstance.requestData(.get,URLString: "http://www.douyutv.com/api/v1/slide/6",parameters: ["version" : "2.300"]){
            (result) in
            
            //1.获取整体字典数据
            guard let resultDict = result as? [String : NSObject] else { return }
            
            //2.根据data的key获取数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            //3.字典转换模型对象
            for dict in dataArray {
                self.cycleModels.append(CycleModel(dict : dict))
               // print(dict)
            }
            
            finishCallback()
        }
    }
}
