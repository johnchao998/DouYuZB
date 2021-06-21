//
//  NetworkTools.swift
//  AlamofireTest
//
//  Created by John on 2021/6/19.
//

import UIKit
import Alamofire
import SwiftyJSON

enum MethodType {
    case get
    case post
}


/**
 外部调用方法：
 NetWorkRequest.sharedInstance.getRequest(UrlString:BaseUrl, params:nil, success: { (response) in
             print(response)
         }) { (error) in

         }
 */
let BaseUrl = "http://httpbin.org/get"

private let NetWorkRequestShareInstance = NetWorkRequest()

class NetWorkRequest{
    class var sharedInstance:NetWorkRequest {
        return NetWorkRequestShareInstance
    }
}

extension NetWorkRequest{
    func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> ()) {
        
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error ?? -1)
                return
            }
            
            // 4.将结果回调出去
            finishedCallback(result)
        }
    }
    
    
    func getRequest(UrlString:String,params:[String:Any]?,success:@escaping(_ response:[String:Any])->(),failure:@escaping(_ error:Error)->()) {
            let PathUrl = UrlString
        Alamofire.request(PathUrl, method: .get, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                 //当响应成功是，使用临时变量value接受服务器返回的信息并判断是否为[String: AnyObject]类型 如果是那么将其传给其定义方法中的success
                if let value = response.result.value as? [String:Any]{
                    success(value)
                }
                let json = JSON(value)
                print(json)

            case .failure(let error):
                failure(error)
                //print(error)
            }

        }
    }


    //paramer mark===post请求 =
    func postRequest(UrlString:String,paramer:[String:Any],success:@escaping(_ response:[String:AnyObject])->(),failure:@escaping(_ error:Error)->()){
        let PathUrl = BaseUrl+UrlString
        Alamofire.request(PathUrl, method: HTTPMethod.post, parameters: paramer).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String:AnyObject]{
                    success(value)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }


    ///上传图片

    func upLoadImageRequest(UrlString:String,params:[String:String],data:[Data],name:[String],success:@escaping(_ response:[String:AnyObject])->(),failure:@escaping(_ error:Error)->()){
        let headers = ["content-type":"multipart/form-data"]
       let PathUrl = BaseUrl+UrlString
        Alamofire.upload(multipartFormData: { (multipartforData) in
            let flag = params["flag"]
            let userId = params["userId"]
            multipartforData.append((flag?.data(using: String.Encoding.utf8))!, withName: "flag")
            multipartforData.append((userId?.data(using: String.Encoding.utf8))!, withName: "userId")
            for i in 0..<data.count{
                multipartforData.append(data[i], withName: "appPhoto", fileName: name[i], mimeType: "image/png")
            }

        }, to: PathUrl,
           headers: headers,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let value = response.result.value as? [String: AnyObject]{
                        success(value)
                        let json = JSON(value)
                        print(json)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)

            }
        }
    )
}
}
