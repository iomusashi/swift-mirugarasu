//
//  App.swift
//  Mirror Glass
//
//  Created by インヤキ on 5/31/22.
//

import Foundation
import UIKit

class App {
  static let shared = App()
  
  private(set) var api: ApiClient!
  private(set) var tracksRepository: TrackRepositoryServiceProtocol!
  
  private init() {}
  
  func bootstrap(
    with application: UIApplication,
    launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) {
    api = ApiClient(
      baseUrl: URL(string: "https://itunes.apple.com")!,
      version: ""
    )
    tracksRepository = TrackRepositoryService(api: api)
  }
}
