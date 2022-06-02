//
//  SearchController.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation
import UIKit

import NSObject_Rx
import PureLayout
import RxCocoa
import RxSwift
import SVProgressHUD

class SearchController: BaseController {
  var viewModel: SearchViewModelProtocol!
  
  private(set) lazy var backgroundSearchView: UIVisualEffectView = {
    let visualEffectView = UIVisualEffectView()
    visualEffectView.effect = UIBlurEffect(style: .systemThinMaterial)
    visualEffectView.layer.cornerRadius = 20
    visualEffectView.clipsToBounds = true
    return visualEffectView
  }()
  
  private(set) lazy var vibrancySearchView: UIVisualEffectView = {
    let visualEffectView = UIVisualEffectView()
    visualEffectView.effect = UIVibrancyEffect(
      blurEffect: UIBlurEffect(style: .systemThinMaterial),
      style: .label
    )
    return visualEffectView
  }()
  
  private(set) lazy var searchField: UITextField = {
    let field = UITextField()
    field.placeholder = "Search"
    field.backgroundColor = .clear
    return field
  }()
  
  private(set) lazy var searchView: UIView = {
    let view = UIView()
    view.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
    view.layer.cornerRadius = 12
    view.clipsToBounds = true
    view.backgroundColor = R.color.background()!
    
    let button = UIButton(type: .system)
    button.frame = view.bounds
    button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
    button.tintColor = R.color.navTitleColor()!
    view.addSubview(button)
    return view
  }()
  
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
    imageView.image = R.image.imgBlob()!
    imageView.frame = .init(x: 0, y: -150, width: 1041, height: 608)
    return imageView
  }()
}

// MARK: - Lifecycle

extension SearchController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchField.becomeFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
}

// MARK: - Setup

private extension SearchController {
  func setup() {
    setupBlobs()
    setupSearchBar()
    setupCollectionView()
  }
  
  func setupBlobs() {
    view.addSubview(blob)
  }
  
  func setupSearchBar() {
    view.addSubview(backgroundSearchView)
    backgroundSearchView.contentView.addSubview(vibrancySearchView)
    vibrancySearchView.contentView.addSubview(searchField)
    vibrancySearchView.contentView.addSubview(searchView)
    
    backgroundSearchView.autoPinEdge(toSuperviewSafeArea: .top, withInset: 16)
    backgroundSearchView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
    backgroundSearchView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
    backgroundSearchView.autoSetDimension(.height, toSize: 52)
    
    vibrancySearchView.autoPinEdgesToSuperviewEdges()
    
    searchView.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
    searchView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 8)
    searchView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 8)
    searchView.autoSetDimensions(to: .init(width: 36, height: 36))
    
    searchField.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
    searchField.autoPinEdge(toSuperviewEdge: .leading, withInset: 24)
    searchField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 8)
    searchField.autoPinEdge(.trailing, to: .leading, of: searchView, withOffset: 8)
  }
  
  func setupCollectionView() {
    view.addSubview(collectionView)
    collectionView.autoPinEdge(.top, to: .bottom, of: backgroundSearchView, withOffset: 8)
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

private extension SearchController {
  func bind() {
    searchField.rx.text.orEmpty
      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: "")
      .drive(onNext: handleSearchQuery())
      .disposed(by: rx.disposeBag)
  }
}

// MARK: - Router

private extension SearchController {
  func navigateToDetailView(withViewModel detailViewModel: DetailViewModelProtocol) {
    let vc = DetailController()
    vc.viewModel = detailViewModel
    navigationController?.pushViewController(vc, animated: true)
  }
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
  func handleSearchQuery() -> SingleResult<String> {
    return { [weak self] query in
      guard let self = self, !query.isEmpty else { return }
      self.viewModel.fetchTracks(
        query: query,
        onSuccess: self.handleTracksFetchingSuccess(),
        onFailure: self.handleTracksFetchingFailure()
      )
    }
  }
  
  func handleTracksFetchingSuccess() -> VoidResult {
    return { [weak self] in
      SVProgressHUD.dismiss()
      self?.collectionView.reloadData()
    }
  }
  
  func handleTracksFetchingFailure() -> ErrorResult {
    return { error in
      SVProgressHUD.dismiss()
      SVProgressHUD.showError(withStatus: error.localizedDescription)
    }
  }
}

// MARK: - Helpers

private extension SearchController {

}

// MARK: - UICollectionViewDataSource

extension SearchController: UICollectionViewDataSource {
  func numberOfSections(
    in collectionView: UICollectionView
  ) -> Int {
    return 1
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return viewModel.trackCellViewModels.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: TrackCell.reuseId,
      for: indexPath
    ) as? TrackCell else { return UICollectionViewCell() }
    cell.viewModel = viewModel.trackCellViewModels[indexPath.item]
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension SearchController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: false)
    let detailViewModel = viewModel.detailViewModel(at: indexPath)
    navigateToDetailView(withViewModel: detailViewModel)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    cell.layoutIfNeeded()
  }
}
