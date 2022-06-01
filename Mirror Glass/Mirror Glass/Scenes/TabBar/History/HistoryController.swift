//
//  HistoryController.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

class HistoryController: BaseController {
  var viewModel: HistoryViewModelProtocol!
  
  // @IBOutlet private(set) var label: UILabel!
  // @IBOutlet private(set) var field: APTextField!
  
  // private(set) var fieldInputController: MDCInputControllerBase!
}

// MARK: - Lifecycle

extension HistoryController {
  override func viewDidLoad() {
    super.viewDidLoad()

    setup()
    bind()
  }
}

// MARK: - Setup

private extension HistoryController {
  func setup() {

  }
}

// MARK: - Bindings

private extension HistoryController {
  func bind() {

  }
}

// MARK: - Router

private extension HistoryController {
//  func presentSomeController() {
//    let vc = R.storyboard.someController.SomeController()!
//    vc.viewModel = SomeViewModel()
//    navigationController?.pushViewController(vc, animated: true)
//  }
}

// MARK: - Actions

private extension HistoryController {
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

private extension HistoryController {
//  func handleSomeSuccess() -> VoidResult {
//    return { [weak self] in
//      guard let s = self else { return }
//      // TODO: Do something here
//    }
//  }
}

// MARK: - Helpers

private extension HistoryController {

}

// MARK: - SomeControllerProtocol

//extension HistoryController: SomeControllerProtocol {
//
//}
