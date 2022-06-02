//
//  ModelID.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

/*!
 Typesafe identifiers. A concept by John Sundell.
 https://www.swiftbysundell.com/articles/type-safe-identifiers-in-swift/
 */
struct ModelID<V: ModelIdentifiable> {
  let rawValue: V.IDType
  
  init(_ rawValue: V.IDType) {
    self.rawValue = rawValue
  }
}

// MARK: - Codable

extension ModelID: Codable {
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    rawValue = try container.decode(V.IDType.self)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(rawValue)
  }
}

// MARK: - Equatable

extension ModelID: Equatable where V.IDType: Codable {
  static func == (lhs: ModelID<V>, rhs: ModelID<V>) -> Bool {
    return String(describing: lhs.rawValue) == String(describing: rhs.rawValue)
  }
}

// MARK: - ExpressibleByStringLiteral

extension ModelID: ExpressibleByStringLiteral,
                   ExpressibleByUnicodeScalarLiteral,
                   ExpressibleByExtendedGraphemeClusterLiteral where V.IDType == String {
  typealias StringLiteralType = String
  typealias UnicodeScalarLiteralType = String
  typealias ExtendedGraphemeClusterLiteralType = String
  
  init(stringLiteral value: String) {
    rawValue = value
  }
}

// MARK: - CustomStringConvertible

extension ModelID: CustomStringConvertible where V.IDType == String {
  var description: String {
    return rawValue
  }
}

// MARK: ExpressibleByIntegerLiteral

extension ModelID: ExpressibleByIntegerLiteral where V.IDType == Int64 {
  typealias IntegerLiteralType = Int64
  
  init(integerLiteral value: Int64) {
    rawValue = value
  }
}

// MARK: - ModelIdentifiable

// swiftlint:disable type_name
protocol ModelIdentifiable {
  associatedtype IDType: Codable = Int64
  typealias ID = ModelID<Self>
  var id: ID { get }
}
