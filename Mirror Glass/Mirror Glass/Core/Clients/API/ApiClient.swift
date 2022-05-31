//
//  ApiClient.swift
//  Mirror Glass
//
//  Created by インヤキ on 5/31/22.
//

import Foundation

import Alamofire

typealias APIClientResultClosure = (Result<ApiResponse, Error>) -> Void

enum AppError: Error {
  case unknown
}

protocol ApiClientProtocol {
  /// The base URL of the REST API sans the version. E.g. `https://api.domain.com/`
  var baseUrl: URL { get }
  
  /// The default version of the API to use. E.g. `v1`, `v2.1`.
  var version: String { get }
  
  func halt()
}

extension ApiClientProtocol {
  /// Construct the Endpoint's URL based on the given `resourcePath` value.
  ///
  /// - parameters:
  ///   - resourcePath: The endpoint's resource path. E.g. `auth/mobile/verify`
  ///   - version: The version of the endpoint to use. Defaults to type's `version` property.
  ///
  /// - returns: URL
  func endpointURL(_ resourcePath: String, version: String? = nil) -> URL {
    return baseUrl.appendingPathComponent("\(version ?? self.version)/\(resourcePath)")
  }
}

class ApiClient: ApiClientProtocol {
  private(set) var sessionManager: Alamofire.Session
  private(set) var baseUrl: URL
  private(set) var version: String
  
  init(
    sessionManager: Alamofire.Session = .default,
    baseUrl: URL,
    version: String
  ) {
    self.sessionManager = sessionManager
    self.baseUrl = baseUrl
    self.version = version
  }
  
  func halt() {
    sessionManager.session.getAllTasks { tasks in
      tasks.forEach { $0.cancel() }
    }
  }
}

extension ApiClient {
  /// This wraps the call to `Alamofire.request(...).apiResponse(result:)`.
  ///
  /// - parameters:
  ///   - resourcePath: The path of the API resource.
  ///   - method: The HTTP method for this API resource.
  ///   - version: Optional. Defaults to whatever the value of `self.version` property is.
  ///   - parameters: The parameters for this API resource. `nil` by default.
  ///   - encoding: The parameter encoding to use. Defaults to `URLEncoding.default`.
  ///   - headers: The HTTP headers. Defaults to calling `httpRequestHeaders(withAuth:)`.
  ///   - success: Accepts `ApiResponse` instance.
  ///   - failure: Accepts `Error` instance.
  ///
  func request(
    _ resourcePath: String,
    method: HTTPMethod = .get,
    version: String? = nil,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = nil,
    success: @escaping (ApiResponse) -> Void,
    failure: @escaping (Error) -> Void
  ) -> DataRequest {
    return sessionManager
      .request(
        endpointURL(resourcePath, version: version),
        method: method,
        parameters: parameters,
        encoding: encoding,
        headers: headers
      )
      .apiResponse(completion: { result in
        switch result {
        case let .success(resp):
          success(resp)
        case let .failure(error):
          failure(error)
        }
      })
  }
}

// MARK: - Alamofire.DataRequest

extension DataRequest {
  @discardableResult
  func apiResponse(
    queue: DispatchQueue? = nil,
    completion: @escaping APIClientResultClosure
  ) -> DataRequest {
    return responseData(queue: queue ?? .main, completionHandler: { response in
      
      if let responseError = response.error {
        return completion(.failure(responseError))
      }
      
      guard let responseData = response.value else {
        return completion(.failure(AppError.unknown))
      }
      
      do {
        let resp = try JSONDecoder().decode(ApiResponse.self, from: self.utf8Data(from: responseData))
        completion(.success(resp))
      } catch {
        completion(.failure(error))
      }
    })
  }
  
  // TODO: Throw error
  private func utf8Data(from data: Data) -> Data {
    let encoding = detectEncoding(of: data)
    guard encoding != .utf8 else { return data }
    guard let responseString = String(data: data, encoding: encoding) else {
      preconditionFailure("Could not convert data to string with encoding \(encoding.rawValue)")
    }
    guard let utf8Data = responseString.data(using: .utf8) else {
      preconditionFailure("Could not convert data to UTF-8 format")
    }
    return utf8Data
  }
  
  private func detectEncoding(of data: Data) -> String.Encoding {
    var convertedString: NSString?
    let encoding = NSString.stringEncoding(
      for: data,
      encodingOptions: nil,
      convertedString: &convertedString,
      usedLossyConversion: nil
    )
    return String.Encoding(rawValue: encoding)
  }
}

// MARK: - Model Decoding

extension ApiClient {
  func decodeModel<T>(
    onSuccess: @escaping SingleResult<T>,
    onError: @escaping ErrorResult
  ) -> SingleResult<ApiResponse> where T: Decodable {
    return { apiResponse in
      guard let model: T = apiResponse.decodedValue() else {
        return onError(AppError.unknown)
      }
      onSuccess(model)
    }
  }
}
