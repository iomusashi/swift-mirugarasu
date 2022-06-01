//
//  SearchController.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

class SearchController: BaseController {
  var viewModel: SearchViewModelProtocol!
  
  // @IBOutlet private(set) var label: UILabel!
  // @IBOutlet private(set) var field: APTextField!
  
  // private(set) var fieldInputController: MDCInputControllerBase!
}

// MARK: - Lifecycle

extension SearchController {
  override func viewDidLoad() {
    super.viewDidLoad()

    setup()
    bind()
  }
}

// MARK: - Setup

private extension SearchController {
  func setup() {

  }
}

// MARK: - Bindings

private extension SearchController {
  func bind() {

  }
}

// MARK: - Router

private extension SearchController {
//  func presentSomeController() {
//    let vc = R.storyboard.someController.SomeController()!
//    vc.viewModel = SomeViewModel()
//    navigationController?.pushViewController(vc, animated: true)
//  }
}

// MARK: - Actions

private extension SearchController {
//  @IBAction
//  func someButtonTapped(_ sender: Any) {
//    viewModel.someFunction2(
//      param1: 0,
//      param2: "",
//      onSuccess: handleSomeSuccess(),
//      onError: handleError()
//    )
//  }
}

// MARK: - Event Handlers

private extension SearchController {
//  func handleSomeSuccess() -> VoidResult {
//    return { [weak self] in
//      guard let s = self else { return }
//      // TODO: Do something here
//    }
//  }
}

// MARK: - Helpers

private extension SearchController {

}

// MARK: - SomeControllerProtocol

//extension SearchController: SomeControllerProtocol {
//
//}
