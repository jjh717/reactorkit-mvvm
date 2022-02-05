//
//  UserEndpoint.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/03.
//


import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}

enum UserEndpoint: APIConfiguration {
    case getRandomImageList(page: Int, per_page: Int)
    case searchTerm(query: String, page: Int, per_page: Int)
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .getRandomImageList, .searchTerm:
            return .get
        }
    }

    // MARK: - Path
    var path: String {
        switch self {
        case .getRandomImageList:
            return "/photos"
        case .searchTerm:
            return "/search/photos"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .getRandomImageList(let page, let per_page):
            return ["page" : "\(page)",
                    "per_page" : "\(per_page)"]
        case .searchTerm(let term, let page, let per_page):
            return ["query" : "\(term)",
                    "page" : "\(page)",
                    "per_page" : "\(per_page)"]
        }
    }
    
    // MARK: - URLRequest
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.unSplash_baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("Client-ID \(Constants.unSplash_appKey)", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        
        if let parameters = parameters {
            do {
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
