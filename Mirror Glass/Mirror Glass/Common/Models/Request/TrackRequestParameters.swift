//
//  TrackRequestParameters.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

struct TrackRequestParameters: Codable {
  var term: String
  var country: String
  var media: ITunesMediaType
  
  init(
    term: String = "star",
    country: String = "au",
    media: ITunesMediaType = .movie
  ) {
    self.term = term
    self.country = country
    self.media = media
  }
}
