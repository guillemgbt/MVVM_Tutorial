//
//  API.swift
//  MovieSearch
//
//  Created by Guillem Budia Tirado on 31/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation


typealias APISuccessResponse = (Dictionary<String, Any>)->()
typealias APIErrorResponse = (String)->()


/// REST API interface to work with HTTP requests
class API: NSObject {
    
    static let shared = API()
    
    private let rootURL = "url"
    private let XToken: String
    
    private let urlSession: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.urlSession = session
        self.XToken = UUID().uuidString
        super.init()
    }
    
    
    private func getRequest(for endpoint: Endpoint) -> URLRequest? {
        var request = buildBaseRequest(with: endpoint)
        
        request?.httpMethod = "GET"
                
        return request
    }
    
    private func postRequest(for endpoint: Endpoint, data: Data) -> URLRequest? {
        var request = buildBaseRequest(with: endpoint)

        request?.httpMethod = "POST"
        request?.httpBody = data
        
        return request
    }
    
    private func buildBaseRequest(with endpoint: Endpoint) -> URLRequest? {
        
        guard let url = endpoint.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue(url.host, forHTTPHeaderField: "Referer")
        request.setValue(XToken, forHTTPHeaderField: "X-User-Session-Token")
        
        return request
    }
    
    @discardableResult
    func GET(_ endpoint: Endpoint, onSuccess: @escaping APISuccessResponse, onError: @escaping APIErrorResponse) -> URLSessionDataTask? {
        
        guard let request = getRequest(for: endpoint) else {
            Utils.printError(sender: self, message: "Could not request \(endpoint.path)")
            onError("Could not request \(endpoint.path)")
            return nil
        }
        
        let task = performRequest(request, onSuccess: onSuccess, onError: onError)
        
        return task
    }
    
    
    @discardableResult
    func POST(_ endpoint: Endpoint, dataDict: [String : Any], onSuccess: @escaping APISuccessResponse, onError: @escaping APIErrorResponse) -> URLSessionDataTask? {
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted)
            
            guard let request = postRequest(for: endpoint, data: jsonData) else {
                Utils.printError(sender: self, message: "Could not request \(endpoint.path)")
                onError("Could not request \(endpoint.path)")
                return nil
            }
            
            let task = performRequest(request, onSuccess: onSuccess, onError: onError)
            
            return task
            
        } catch let catchError {
            onErrorOcurred(catchError, for: endpoint.path, onError: onError)
        }
        
        return nil
    }
    
    private func performRequest(_ request: URLRequest, onSuccess: @escaping APISuccessResponse, onError: @escaping APIErrorResponse) -> URLSessionDataTask? {
        
        let task = urlSession.dataTask(with: request, completionHandler: { _data, response, _error -> Void in
            
            if let error = _error {
                
                if (error as NSError).code == NSURLErrorCancelled {return}
                
                self.onErrorOcurred(error, for: request.url?.absoluteString, onError: onError)
                return
            }
            
            if let statusCode = response?.getStatusCode(), statusCode >= 400 {
                Utils.printError(sender: self,
                                 message: "error for path \(request.url?.absoluteString ?? ""). statusCode: \(statusCode)")
                
                onError("Status Code: \(statusCode).")
                return
            }
            
            
            guard let data = _data else {
                Utils.printError(sender: self, message: "error for path \(request.url?.absoluteString ?? ""): no data received")
                onError("no data received")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, Any>
                onSuccess(json)
                
            } catch let catchError {
                self.onErrorOcurred(catchError, for: request.url?.absoluteString, onError: onError)
                return
            }
            
            
        })
        
        task.resume()
        return task
    }
    
    
    private func onErrorOcurred(_ error: Error, for path: String?, onError: @escaping APIErrorResponse) {
        Utils.printError(sender: self, message: "error for path \(path ?? ""): \(error.localizedDescription)")
        onError(error.localizedDescription)
    }
}
