//
//  DateFormatter+Static.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

extension DateFormatter {
  static let iso8601: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    formatter.calendar = Calendar(identifier: .iso8601)
    return formatter
    }()
}
