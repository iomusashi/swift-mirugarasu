//
//  Track.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import CoreData
import Foundation

struct Track: APIModel, ModelIdentifiable, Codable {
  var id: ID
  var title: String
  var price: Double? = 0.0
  var currency: String? = nil
  var genre: String
  var longDescription: String
  
  var artworkUrl: URL
  var previewUrl: URL?
  
  var kind: Kind = .featureMovie
  var isFavorite: Bool = false
  
  enum Kind: String, Codable {
    case featureMovie = "feature-movie"
    case song
    
    func uppercased() -> String {
      switch self {
      case .featureMovie: return "feature movie".uppercased()
      case .song: return "song".uppercased()
      }
    }
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "trackId"
    case title = "trackName"
    case price = "trackPrice"
    case genre = "primaryGenreName"
    case artworkUrl = "artworkUrl100"
    case currency, longDescription, previewUrl, kind
  }
}

extension Track: ManagedObjectSerializing {
  enum IgnoredNetworkDecodingKeys: String {
    case isFavorite, lastVisited
  }
  
  static func from(entity mo: TrackEntity) -> Track {
    return Track(
      id: Track.ID(mo.id),
      title: mo.title!,
      price: mo.price,
      currency: mo.currency,
      genre: mo.genre!,
      longDescription: mo.longDescription!,
      artworkUrl: mo.artworkUrl!,
      previewUrl: mo.previewUrl,
      kind: Track.Kind(rawValue: mo.kind!)!,
      isFavorite: mo.isFavorite
    )
  }
  
  func asManagedObject(context: NSManagedObjectContext) -> NSManagedObject? {
    if let fetchedMo = CoreData.stack.saveContext.findFirst(TrackEntity.self, withId: id.rawValue) {
      let mirror = Mirror(reflecting: self)
      guard mirror.displayStyle == Mirror.DisplayStyle.struct else { return nil }
      for case let (key?, value) in mirror.children {
        guard IgnoredNetworkDecodingKeys(rawValue: key) == nil else { continue }
        guard let unwrapped = Self.unwrap(value) else { continue }
        fetchedMo.setValue(unwrapped, forKey: key)
      }
      return fetchedMo
    } else {
      let entityName = type(of: self).entityName
      guard
        let entityDescription = NSEntityDescription.entity(
          forEntityName: entityName,
          in: context
        )
      else { return nil }
      let mo = NSManagedObject(entity: entityDescription, insertInto: context)
      let mirror = Mirror(reflecting: self)
      guard mirror.displayStyle == Mirror.DisplayStyle.struct else { return nil }
      for case let (key?, value) in mirror.children {
        guard let unwrapped = Self.unwrap(value) else { continue }
        mo.setValue(unwrapped, forKey: key)
      }
      return mo
    }
  }
}
