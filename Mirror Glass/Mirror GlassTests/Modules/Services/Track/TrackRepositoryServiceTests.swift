//
//  TrackRepositoryServiceTests.swift
//  Mirror GlassTests
//
//  Created by インヤキ on 6/2/22.
//

import Foundation

import Quick
import Nimble

@testable import Mirror_Glass

class TrackRepositoryServiceTests: QuickSpec {
  override func spec() {
    describe("TrackRepositoryService") {
      var sut: TrackRepositoryService!
      var api: MockTrackAPI!

      beforeEach {
        api = MockTrackAPI()
        sut = TrackRepositoryService(
          api: api
        )
      }
      
      afterEach {
        api = nil
        sut = nil
      }
      
      it("calling search should call api.getTracks once") {
        expect(api.getTracksCallCount).to(equal(0))
        let params = TrackRequestParameters(cacheResultsToDisk: false)
        
        sut.search(
          parameters: params,
          onSuccess: { _ in },
          onFailure: { _ in }
        )
        
        expect(api.getTracksCallCount).to(equal(1))
      }

      context("when initialized with successful api") {
        beforeEach {
          api.errorToReturn = nil
        }
        
        it("should call onSuccess closure once on search") {
          var onSuccessCallCount = 0
          sut.search(
            parameters: TrackRequestParameters(),
            onSuccess: {_ in onSuccessCallCount += 1 },
            onFailure: {_ in }
          )
          expect(onSuccessCallCount).toEventually(equal(1))
        }
      }
    }
  }
}
