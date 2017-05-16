//
//  NetworkManager.swift
//  SwiftDemo
//
//  Created by panxinyu on 15/05/2017.
//  Copyright © 2017 panxinyu. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class NetworkManager {

    static let manager = NetworkManager()

    private init() { }

    typealias NetworkCompletionHandler = (Alamofire.Result<Any>) -> Void

    @discardableResult
    func fetchDataWithAPI(api: API,
                          method: Alamofire.HTTPMethod = .get,
                          responseKey: String,
                          networkCompletionHandler: @escaping NetworkCompletionHandler) -> Cancellable? {
        
        guard let url = api.url else {
            printLog("URL Invalid: \(api)")
            return nil
        }
        return Alamofire.request(url, method: method, parameters: api.parameter).responseJSON {
            networkCompletionHandler( self.parseResult(result: $0.result, responseKey: responseKey))
        }
    }

    private func hanlderError(response: DataResponse<Any>) {
        var statusCode = response.response?.statusCode
        if let error = response.result.error as? AFError {
            statusCode = error._code // statusCode private
            switch error {
            case .invalidURL(let url):
                printError("Invalid URL: \(url) - \(error.localizedDescription)")
            case .parameterEncodingFailed(let reason):
                printError("Parameter encoding failed: \(error.localizedDescription)")
                printError("Failure Reason: \(reason)")
            case .multipartEncodingFailed(let reason):
                printError("Multipart encoding failed: \(error.localizedDescription)")
                printError("Failure Reason: \(reason)")
            case .responseValidationFailed(let reason):
                printError("Response validation failed: \(error.localizedDescription)")
                printError("Failure Reason: \(reason)")
                switch reason {
                case .dataFileNil, .dataFileReadFailed:
                    printError("Downloaded file could not be read")
                case .missingContentType(let acceptableContentTypes):
                    printError("Content Type Missing: \(acceptableContentTypes)")
                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                    printError("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                case .unacceptableStatusCode(let code):
                    printError("Response status code was unacceptable: \(code)")
                    statusCode = code
                }
            case .responseSerializationFailed(let reason):
                printError("Response serialization failed: \(error.localizedDescription)")
                printError("Failure Reason: \(reason)")
                // statusCode = 3840 ???? maybe..
            }
            printError("Underlying error: \(String(describing: error.underlyingError))")
        } else if let error = response.result.error as? URLError {
            printError("URLError occurred: \(error)")
        } else {
            printError("Unknown error: \(String(describing: response.result.error))")
        }
    }


    /// 请求JSON数据
    ///
    /// - Parameters:
    ///   - api: 请求的API
    ///   - method: HTTP方法
    ///   - responseKey: 相应的key, 可以用. 符号取值
    ///   - jsonHandler: handle
    /// - Returns: 返回请求用于取消请求
    @discardableResult
    func fetchJSONWithAPI<T: Mappable>(api: API,
                                       method: Alamofire.HTTPMethod = .get,
                                       responseKey: String,
                                       jsonHandler: @escaping ((Alamofire.Result<T>) -> Void)) -> Cancellable? {
        return fetchDataWithAPI(api: api, method: method, responseKey: responseKey, networkCompletionHandler: {
            jsonHandler($0.flatMap(transform: { (obj) -> T? in
                Mapper().map(JSONObject: obj)
            }))
        })
    }


    /// 请求JSON数组
    ///
    /// - Parameters:
    ///   - api: 请求的API
    ///   - method: HTTP方法
    ///   - responseKey: 相应的key, 可以用. 符号取值
    ///   - jsonArrayHandler: handle
    /// - Returns: 返回请求用于取消请求
    @discardableResult
    func fetchJSONArrayWithAPI<T: Mappable>(api: API,
                                            method: Alamofire.HTTPMethod = .get,
                                            responseKey: String,
                                            jsonArrayHandler: @escaping (Result<[T]>) -> Void) -> Cancellable? {
        return fetchDataWithAPI(api: api, method: method, responseKey: responseKey) {
            jsonArrayHandler($0.flatMap(transform: { (obj) -> [T]? in
                Mapper().mapArray(JSONObject: obj)
            }))
        }
    }

    func parseResult(result: Alamofire.Result<Any>, responseKey: String) -> Alamofire.Result<Any> {
        return result
            .flatMap { $0 as? [String: Any] }
            .flatMap { $0?.valueFor(key: responseKey) }
            .mapError(transform: { (error) -> Error in
                return error
            })
    }
}


// MARK: - 自定义的操作符, 配合ObjectMap使用
postfix operator =>

postfix func =><T: Mappable>(object: Any) -> T? {
    return Mapper().map(JSONObject: object)
}

postfix func =><T: Mappable>(object: Any) -> [T]? {
    return Mapper().mapArray(JSONObject: object)
}

// MARK: - 对字典扩展，实现ValueForKey方法，可以用.符号取值
extension Dictionary {
    var dictObject: Any? { return self}
    func valueFor(key: Key) -> Value? {
        guard let stringKey = (key as? String), stringKey.contains(".") else {
            return self[key]
        }
        let keys = stringKey.components(separatedBy: ".")

        guard !keys.isEmpty else {
            return nil
        }
        let results: Any? = keys.reduce(dictObject, fetchValueInObject)
        return results as? Value
    }
}

func fetchValueInObject(object: Any?, forKey key: String) -> Any? {
    return (object as? [String: Any])?[key]
}

// MARK: - 定义一个协议，让返回的request能取消请求
protocol Cancellable {
    func cancel()
}

extension Alamofire.Request: Cancellable {}


// MARK: - 错误类型
enum HTTPError: LocalizedError {
    case transformError
    case unknow

    var errorDescription: String? {
        switch self {
        case .transformError:
            return NSLocalizedString("transform json data error", comment: "transformError")
        case .unknow:
            return NSLocalizedString("unknow error", comment: "unknowError")
        }
    }
}


// MARK: - 扩展Alamofire 的 Result<Any>
extension Result {

    // Note: rethrows 用于参数是一个会抛出异常的闭包的情况，该闭包的异常不会被捕获，会被再次抛出，所以可以直接使用 try，而不用 do－try－catch

    // U 可能为 Optional
    func map<T>(transform: (Value) throws -> T) rethrows -> Result<T> {
        switch self {
        case .failure(let error):
            return .failure(error)
        case .success(let value):
            return .success(try transform(value))
        }
    }

    // 若 transform 的返回值为 nil 则作为异常处理
    func flatMap<T>(transform: (Value) throws -> T?) rethrows -> Result<T> {
        switch self {
        case .failure(let error):
            return .failure(error)
        case .success(let value):
            guard let transformedValue = try transform(value) else {
                return .failure(HTTPError.transformError)
            }
            return .success(transformedValue)
        }
    }

    // 适用于 transform(value) 之后可能产生 error 的情况
    func flatMap<T>(transform: (Value) throws -> Result<T>) rethrows -> Result<T> {
        switch self {
        case .failure(let error):
            return .failure(error)
        case .success(let value):
            return try transform(value)
        }
    }

    // 处理错误，并向下传递
    func mapError(transform: (Error) throws -> Error) rethrows -> Result<Value> {
        switch self {
        case .failure(let error):
            return .failure(try transform(error))
        case .success(let value):
            return .success(value)
        }
    }

    // 处理数据（不再向下传递数据，作为数据流的终点）
    func handleValue(handler: (Value) -> Void) {
        switch self {
        case .failure(_):
            break
        case .success(let value):
            handler(value)
        }
    }

    // 处理错误（终点）
    func handleError(handler: (Error) -> Void) {
        switch self {
        case .failure(let error):
            handler(error)
        case .success(_):
            break
        }
    }
}

