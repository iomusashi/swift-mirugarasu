//
//  ApiResponse.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

/// An object representation of the server's JSON response.
struct ApiResponse {
  /// Intentionally set to Optional-Any as it could be of any type or just be nil.
  /// It's up to the call site to determine the exact type of its value.
  /// If it's a Decodable type, use the method `decodedValue(forKeyPath:decoder:)`.
  let results: Any?
  let resultCount: Int
}

extension ApiResponse: Decodable {
  enum CodingKeys: String, CodingKey {
    case results, resultCount
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    results = (try container.decodeIfPresent(AnyDecodable.self, forKey: .results))?.value
    resultCount = try container.decodeIfPresent(Int.self, forKey: .resultCount) ?? .zero
  }
}

// MARK: - Helpers

extension ApiResponse {
  /// Decodes the contents of the `results` property, if available, into its inferred Decodable type.
  /// - parameter forKeyPath: Specify as needed. This only works with Dictionary types.
  ///       If nil, assumes `data` is for the inferred decodable type.
  /// - parameter decoder: A pre-configured JSONDecoder instance. Defaults to `GenericAPIModel`s decoder.
  ///
  /// - returns: The decoded value or nil.
  func decodedValue<T>(forKeyPath: String? = nil, decoder: JSONDecoder? = nil) -> T? where T: Decodable {
    guard var payload = results else { return nil }
    
    if let keyPath = forKeyPath {
      guard let d = nestedData(keyPath) else { return nil }
      payload = d
    }
    
    guard JSONSerialization.isValidJSONObject(payload) else {
      guard let val = payload as? T else { return nil }
      return val
    }
    
    do {
      let json = try JSONSerialization.data(withJSONObject: payload)
      return try (decoder ?? GenericAPIModel.decoder()).decode(T.self, from: json)
    } catch {
      return nil
    }
  }
  
  /// Returns the data at the given `keyPath`. Nil if path doesn't exist.
  private func nestedData(_ keyPath: String) -> Any? {
    guard let payload = results, !keyPath.isEmpty else { return nil }
    guard let dict = payload as? [String: Any] else { return nil }
    return dict[keyPath] as Any
  }
}
