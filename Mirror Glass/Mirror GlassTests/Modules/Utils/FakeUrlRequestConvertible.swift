//
//  FakeUrlRequestConvertible.swift
//  Mirror GlassTests
//
//  Created by インヤキ on 6/2/22.
//

import Foundation
import Alamofire

extension String: URLRequestConvertible {
  static var mock: String { "https://example.org" }
  
  public func asURLRequest() throws -> URLRequest {
    return try URLRequest(url: self, method: .get)
  }
}
