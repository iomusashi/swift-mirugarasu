//
//  AboutController.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

class AboutController: BaseController {
  var viewModel: AboutViewModelProtocol!
  
  // @IBOutlet private(set) var label: UILabel!
  // @IBOutlet private(set) var field: APTextField!
  
  // private(set) var fieldInputController: MDCInputControllerBase!
}

// MARK: - Lifecycle

extension AboutController {
  override func viewDidLoad() {
    super.viewDidLoad()

    setup()
    bind()
  }
}

// MARK: - Setup

private extension AboutController {
  func setup() {

  }
}

// MARK: - Bindings

private extension AboutController {
  func bind() {

  }
}

// MARK: - Router

private extension AboutController {
//  func presentSomeController() {
//    let vc = R.storyboard.someController.SomeController()!
//    vc.viewModel = SomeViewModel()
//    navigationController?.pushViewController(vc, animated: true)
//  }
}

// MARK: - Actions

private extension AboutController {
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

private extension AboutController {
//  func handleSomeSuccess() -> VoidResult {
//    return { [weak self] in
//      guard let s = self else { return }
//      // TODO: Do something here
//    }
//  }
}

// MARK: - Helpers

private extension AboutController {

}

// MARK: - SomeControllerProtocol

//extension AboutController: SomeControllerProtocol {
//
//}
