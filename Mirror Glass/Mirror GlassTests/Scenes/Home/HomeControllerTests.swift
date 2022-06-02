//
//  HomeControllerTests.swift
//  Mirror GlassTests
//
//  Created by インヤキ on 6/2/22.
//

import Foundation

import Quick
import Nimble

@testable import Mirror_Glass

class HomeControllerTests: QuickSpec {
  override func spec() {
    describe("HomeController") {
      var sut: HomeController!
      var viewModel: MockHomeViewModel!

      beforeEach {
        viewModel = MockHomeViewModel()
        sut = HomeController()
        sut.viewModel = viewModel
      }

      afterEach {
        sut = nil
        viewModel = nil
      }

      context("when view is loaded") {
        beforeEach {
          sut.loadViewIfNeeded()
        }
        
        it("should have non-nil collectionView") {
          expect(sut.collectionView).toNot(beNil())
        }
        
        it("should be the data source of the collectionview") {
          expect(sut.collectionView.dataSource).to(be(sut))
        }
        
        it("should be the delegate of the collectionview") {
          expect(sut.collectionView.delegate).to(be(sut))
        }

        it("should have a refresh control") {
          expect(sut.refreshControl).toNot(beNil())
        }
        
        it("should call viewModel.fetchTracks when collectionView triggers pull to refresh") {
          expect(viewModel.fetchTracksCallCount).to(equal(0))
          sut.refreshControl.sendActions(for: .valueChanged)
          expect(viewModel.fetchTracksCallCount).to(equal(1))
        }
      }
    }
  }
}
