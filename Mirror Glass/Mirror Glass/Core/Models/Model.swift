//
//  Model.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

protocol Model {
  /// Returns a **JSONDecoder** instance that's configured for the conforming type.
  static func decoder() -> JSONDecoder
  
  /// Returns a **JSONEncoder** instance that's configured for the conforming type.
  static func encoder() -> JSONEncoder
}

// MARK: - Decodable

extension Model where Self: Decodable {
  static func decoder() -> JSONDecoder {
    return JSONDecoder()
  }
  
  static func decode(_ data: Data) throws -> Self {
    return try decoder().decode(self, from: data)
  }
  
  static func decode(_ dictionary: [String: Any]) throws -> Self {
    return try decode(try JSONSerialization.data(withJSONObject: dictionary))
  }
}

// MARK: - Encodable

extension Model where Self: Encodable {
  static func encoder() -> JSONEncoder {
    return JSONEncoder()
  }
  
  func encode() throws -> Data {
    return try Self.encoder().encode(self)
  }
  
  func dictionary() -> [String: Any]? {
    do {
      if let dict = try JSONSerialization.jsonObject(
        with: try encode(),
        options: .allowFragments
      ) as? [String: Any] {
        return dict.filter { !($0.value is NSNull) }
      }
    } catch {
      return nil
    }
    return nil
  }
  
  func json() -> String? {
    do {
      return String(data: try encode(), encoding: .utf8)
    } catch {
      return nil
    }
  }
}

// MARK: - APIModel

protocol APIModel: Model {}

extension APIModel {
  static func decoder() -> JSONDecoder {
    // You can set your preferred decoding strategies here.
    let d = JSONDecoder()
    d.dateDecodingStrategy = .formatted(.iso8601)
    d.keyDecodingStrategy = .useDefaultKeys
    return d
  }
  
  static func encoder() -> JSONEncoder {
    // You can set your preferred encoding strategies here.
    let e = JSONEncoder()
    e.dateEncodingStrategy = .formatted(.iso8601)
    e.keyEncodingStrategy = .useDefaultKeys
    return e
  }
}

/// Just a stand-in model for us to access the static **APIModel**
/// functions like `decoder()` and `encoder()`.
struct GenericAPIModel: APIModel {}

// MARK: - APIRequestParameters

/// A Model type that is intended for parameterized API endpoint wrapper methods. Specifically,
/// those methods that have more than two non-Closure parameters.
protocol APIRequestParameters: APIModel, Codable {}
