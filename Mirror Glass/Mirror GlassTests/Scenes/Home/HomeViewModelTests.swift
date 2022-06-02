//
//  HomeViewModelTests.swift
//  Mirror GlassTests
//
//  Created by インヤキ on 6/2/22.
//

import Foundation

import Quick
import Nimble

@testable import Mirror_Glass

class HomeViewModelTests: QuickSpec {
  override func spec() {
    describe("HomeViewModel") {
      var sut: HomeViewModel!
      var mockService: MockTrackRepositoryService!
      var mockApi: MockTrackAPI!
      
      beforeEach {
        mockApi = MockTrackAPI()
        mockService = MockTrackRepositoryService(api: mockApi)
        sut = HomeViewModel(service: mockService)
      }
      
      afterEach {
        mockService = nil
        sut = nil
      }
      
      it("Calling fetchTracks should call the service's search function") {
        expect(mockService.searchCallCount).to(equal(0))
        sut.fetchTracks(onSuccess: {}, onFailure: {_ in })
        expect(mockService.searchCallCount).to(equal(1))
        mockService.errorToReturn = NSError(domain: #function, code: 1)
        sut.fetchTracks(onSuccess: {}, onFailure: {_ in })
        expect(mockService.searchCallCount).to(equal(2))
      }
    }
  }
}
