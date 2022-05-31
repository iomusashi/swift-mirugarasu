//
//  AnyDecodable.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

/// It's not possible to decode data into `[String: Any]` type yet (as of Swift 4.0).
///
/// SO: [How to decode a property with type of JSON dictionary...](https://stackoverflow.com/a/48226813)
struct AnyDecodable: Decodable {
  var value: Any
  
  private struct CodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int?
    init?(intValue: Int) {
      stringValue = "\(intValue)"
      self.intValue = intValue
    }
    
    init?(stringValue: String) { self.stringValue = stringValue }
  }
  
  init(from decoder: Decoder) throws {
    if let container = try? decoder.container(keyedBy: CodingKeys.self) {
      var result = [String: Any]()
      try container.allKeys.forEach { (key) throws in
        result[key.stringValue] = try container.decodeIfPresent(AnyDecodable.self, forKey: key)?.value
      }
      value = result
    } else if var container = try? decoder.unkeyedContainer() {
      var result = [Any]()
      while !container.isAtEnd {
        if let val = try container.decodeIfPresent(AnyDecodable.self)?.value {
          result.append(val)
        }
      }
      value = result
    } else if let container = try? decoder.singleValueContainer() {
      if let intVal = try? container.decode(Int.self) {
        value = intVal
      } else if let doubleVal = try? container.decode(Double.self) {
        value = doubleVal
      } else if let boolVal = try? container.decode(Bool.self) {
        value = boolVal
      } else if let stringVal = try? container.decode(String.self) {
        value = stringVal
      } else {
        throw DecodingError.dataCorruptedError(
          in: container,
          debugDescription: "the container contains nothing serialisable"
        )
      }
    } else {
      throw DecodingError.dataCorrupted(DecodingError.Context(
        codingPath: decoder.codingPath,
        debugDescription: "Could not serialise"
      ))
    }
  }
}
