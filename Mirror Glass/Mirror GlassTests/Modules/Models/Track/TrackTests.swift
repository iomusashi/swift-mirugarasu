//
//  TrackTests.swift
//  Mirror GlassTests
//
//  Created by インヤキ on 6/2/22.
//

import Foundation

import CoreData
import Nimble
import Quick

@testable import Mirror_Glass

class TrackTests: QuickSpec {
  override func spec() {
    describe("Track") {
      var sut: Track!
      context("ManagedObjectSerializing") {
        beforeEach {
          sut = nil
        }
        afterEach {
          sut = nil
        }
        it("should turn into an NSManagedObject using asManagedObject") {
          sut = Track()
          let mo = sut.asManagedObject(context: CoreData.stack.viewContext)
          expect(mo).toNot(beNil())
        }
        it ("should be created from an NSManagedObject using fromEntity") {
          let trackEntity = TrackEntity()
          sut = Track.from(entity: trackEntity)
          expect(sut).toNot(beNil())
          expect(sut.id.rawValue).to(equal(trackEntity.id))
        }
      }
    }
  }
}

extension Track {
  init() {
    self.init(
      id: Track.ID(-1),
      title: "Title",
      price: -1,
      currency: "USD",
      genre: "genre",
      longDescription: "long description",
      artworkUrl: URL(string: "https://example.org")!,
      previewUrl: nil,
      kind: .featureMovie,
      isFavorite: true
    )
  }
}

extension TrackEntity {
  convenience init() {
    self.init(context: CoreData.stack.viewContext)
    self.id = -2
    self.title = "Title MO"
    self.price = -2
    self.currency = "USD"
    self.genre = "genre"
    self.longDescription = "long description"
    self.artworkUrl = URL(string: "https://example.org")
    self.previewUrl = nil
    self.kind = "feature-movie"
    self.isFavorite = true
  }
}
