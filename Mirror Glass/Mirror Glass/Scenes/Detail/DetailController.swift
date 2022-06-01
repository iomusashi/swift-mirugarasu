//
//  DetailController.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation
import UIKit

import PureLayout
import RxCocoa
import RxSwift

class DetailController: BaseController {
  var viewModel: DetailViewModelProtocol!
  
  private(set) lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(
      frame: view.bounds,
      collectionViewLayout: TrackListCollectionLayout().createLayout()
    )
    collectionView.backgroundColor = .clear
    return collectionView
  }()
  
  private(set) lazy var blob: UIImageView = {
    let imageView = UIImageView()
    imageView.image = R.image.bgDetail()!
    imageView.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    return imageView
  }()
  
  private(set) lazy var blobMaterial: UIVisualEffectView = {
    let view = UIVisualEffectView()
    view.effect = UIBlurEffect(style: .systemMaterial)
    return view
  }()
  
  private(set) lazy var blob2: UIImageView = {
    let imageView = UIImageView()
    imageView.image = R.image.imgCardBlob()!
    let width = UIScreen.main.bounds.width
    imageView.frame = .init(x: 0, y: width*3/4, width: width, height: width*2/3)
    return imageView
  }()
}

// MARK: - Lifecycle

extension DetailController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bind()
  }
}

// MARK: - Setup

private extension DetailController {
  func setup() {
    setupSubviews()
    setupAutoLayoutConstraints()
    setupCollectionView()
  }
  
  func setupSubviews() {
    view.addSubview(blob)
    view.addSubview(blobMaterial)
    view.addSubview(blob2)
  }
  
  func setupAutoLayoutConstraints() {
    setupBlobConstraints()
    setupBlobMaterialConstraints()
  }
  
  func setupBlobConstraints() {
    blob.autoPinEdge(toSuperviewEdge: .top)
    blob.autoPinEdge(toSuperviewEdge: .leading)
    blob.autoPinEdge(toSuperviewEdge: .trailing)
    blob.autoSetDimensions(to: .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
  }
  
  func setupBlobMaterialConstraints() {
    blobMaterial.autoPinEdge(toSuperviewEdge: .top)
    blobMaterial.autoPinEdge(toSuperviewEdge: .leading)
    blobMaterial.autoPinEdge(toSuperviewEdge: .trailing)
    blobMaterial.autoSetDimensions(to: .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
  }
  
  func setupCollectionView() {
    view.addSubview(collectionView)
    collectionView.autoPinEdge(toSuperviewSafeArea: .top)
    collectionView.autoPinEdge(.leading, to: .leading, of: view)
    collectionView.autoPinEdge(.trailing, to: .trailing, of: view)
    collectionView.autoPinEdge(.bottom, to: .bottom, of: view)
    
    setupCollectionViewDelegates()
    setupCell()
  }
  
  func setupCollectionViewDelegates() {
    collectionView.delegate = self
    collectionView.dataSource = self
  }
  
  func setupCell() {
    collectionView.register(TrackCell.self, forCellWithReuseIdentifier: TrackCell.reuseId)
  }
}

// MARK: - Bindings

private extension DetailController {
  func bind() {

  }
}

// MARK: - Router

private extension DetailController {
//  func presentSomeController() {
//    let vc = R.storyboard.someController.SomeController()!
//    vc.viewModel = SomeViewModel()
//    navigationController?.pushViewController(vc, animated: true)
//  }
}

// MARK: - Actions

private extension DetailController {
  @IBAction
  func playbackControlTapped(_ sender: UIButton) {
    
  }
}

// MARK: - Event Handlers

private extension DetailController {
//  func handleSomeSuccess() -> VoidResult {
//    return { [weak self] in
//      guard let s = self else { return }
//      // TODO: Do something here
//    }
//  }
}

// MARK: - Helpers

private extension DetailController {

}

// MARK: - UICollectionViewDataSource

extension DetailController: UICollectionViewDataSource {
  func numberOfSections(
    in collectionView: UICollectionView
  ) -> Int {
    return 1
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return 1
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: TrackCell.reuseId,
      for: indexPath
    ) as? TrackCell else { return UICollectionViewCell() }
    cell.viewModel = viewModel.trackViewModel
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension DetailController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: false)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    cell.layoutIfNeeded()
  }
}
