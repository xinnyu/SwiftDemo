//
//  POPURLRequest.swift
//  POPURLRequestTest
//
//  Created by 潘新宇 on 2017/4/8.
//  Copyright © 2017年 潘新宇. All rights reserved.
//

import Foundation

protocol Request {
    var path:String{get}
    
    var method:HTTPMethod{get}
    var parameter:[String:Any]{get}
    
    associatedtype Response:Decodeable
}

enum HTTPMethod:String{
    case GET
    case POST
}

enum HTTPRequestError:Error{
    case ParameterError
}

protocol Client{
    func send<T:Request>(request:T, handle: @escaping (T.Response?)->()) throws
    var host:String{get}
}

protocol Decodeable{
    static func parse(data:Data) -> Self?
}


class POPURLRequest {
    
    struct User:Decodeable {
        let name:String
        let message:String
        
        init?(data:Data) {
            guard let user = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else{
                return nil
            }
            
            guard let name = user?["name"] as? String else {
                return nil
            }
            
            guard let message = user?["message"] as? String else {
                return nil
            }
            
            self.name = name
            self.message = message
        }
        
        static func parse(data: Data) -> User? {
            return User(data: data)
        }
        
    }
    
    struct UserRequest:Request{
        var method = HTTPMethod.GET
        var parameter: [String : Any] = [:]
        
        var name:String
        
        var path: String {
            return "/users/\(name)"
        }
        typealias Response = User
        
        init(name:String) {
            self.name = name
        }
    }

    struct URLSessionClient:Client{
        var host = "https://api.onevcat.com"
        func send<T>(request: T, handle: @escaping (T.Response?) -> ()) throws where T : Request {
            guard let url = URL(string:host + request.path) else {
                throw HTTPRequestError.ParameterError
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = request.method.rawValue
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let data = data, let result = T.Response.parse(data: data){
                    handle(result)
                }else{
                    handle(nil)
                }
            }
            task.resume()
        }
    }

    struct AlamofireClient:Client {
        var host: String
        func send<T>(request: T, handle: @escaping (T.Response?) -> ()) throws where T : Request {
            
        }
    }
}
