//
//  HomeController.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation
import UIKit

import PureLayout
import RxCocoa
import RxSwift
import SVProgressHUD

class HomeController: BaseController {
  var viewModel: HomeViewModelProtocol!
  var onSearchButtonTapped: VoidResult?
  
  private(set) lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(
      frame: view.bounds,
      collectionViewLayout: TrackListCollectionLayout().createLayout()
    )
    collectionView.backgroundColor = .clear
    return collectionView
  }()
  
  private(set) lazy var blob1: UIImageView = {
    let imageView = UIImageView()
    imageView.image = R.image.imgBlob()!
    imageView.frame = .init(x: -282, y: 200, width: 1041, height: 608)
    return imageView
  }()
  
  private(set) lazy var searchView: UIView = {
    let view = UIView()
    view.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
    view.layer.cornerRadius = 12
    view.clipsToBounds = true
    view.backgroundColor = R.color.background()!
    
    let effectsView = UIVisualEffectView(
      effect: UIBlurEffect(style: .systemThinMaterial)
    )
    effectsView.frame = view.bounds
    view.addSubview(effectsView)
    
    let button = UIButton(type: .system)
    button.frame = view.bounds
    button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
    button.tintColor = R.color.navTitleColor()!
    button.addTarget(self, action: #selector(searchButtonTapped(_:)), for: .touchUpInside)
    view.addSubview(button)
    return view
  }()
  
  private(set) lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
    return refreshControl
  }()
}

// MARK: - Lifecycle

extension HomeController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bind()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    fetchData()
  }
}

// MARK: - Setup

private extension HomeController {
  func setup() {
    setupBlobs()
    setupSearchButton()
    setupTitleLabel()
    setupCollectionView()
    triggerInitialLoad()
  }
  
  func setupBlobs() {
    view.addSubview(blob1)
  }
  
  func setupSearchButton() {
    let searchButton = UIBarButtonItem(customView: searchView)
    navigationItem.setRightBarButton(searchButton, animated: false)
  }
  
  func setupTitleLabel() {
    let titleLabel = UILabel()
    titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle).bold()
    titleLabel.numberOfLines = 1
    titleLabel.text = navigationItem.title
    titleLabel.textColor = R.color.navTitleColor()!
    
    let leftTitleBar = UIBarButtonItem(customView: titleLabel)
    navigationItem.setLeftBarButton(leftTitleBar, animated: false)
  }
  
  func setupCollectionView() {
    view.addSubview(collectionView)
    collectionView.autoPinEdge(toSuperviewSafeArea: .top)
    collectionView.autoPinEdge(.leading, to: .leading, of: view)
    collectionView.autoPinEdge(.trailing, to: .trailing, of: view)
    collectionView.autoPinEdge(.bottom, to: .bottom, of: view)
    collectionView.addSubview(refreshControl)
    
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

private extension HomeController {
  func bind() {

  }
}

// MARK: - Router

private extension HomeController {
  func navigateToDetailView(withViewModel detailViewModel: DetailViewModelProtocol) {
    let vc = DetailController()
    vc.viewModel = detailViewModel
    navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: - Actions

private extension HomeController {
  @IBAction
  func searchButtonTapped(_ sender: UIButton) {
    onSearchButtonTapped?()
  }
}

// MARK: - Event Handlers

private extension HomeController {
  func handleTracksFetchingSuccess() -> VoidResult {
    return { [weak self] in
      SVProgressHUD.dismiss()
      self?.refreshControl.endRefreshing()
      self?.collectionView.reloadData()
    }
  }
  
  func handleTracksFetchingFailure() -> ErrorResult {
    return { [weak self] error in
      self?.refreshControl.endRefreshing()
      SVProgressHUD.dismiss()
      SVProgressHUD.showError(withStatus: error.localizedDescription)
    }
  }
}

// MARK: - Helpers

private extension HomeController {
  func triggerInitialLoad() {
    SVProgressHUD.show(withStatus: "Fetching tracks")
  }

  @objc func fetchData() {
    viewModel.fetchTracks(
      onSuccess: handleTracksFetchingSuccess(),
      onFailure: handleTracksFetchingFailure()
    )
  }
}

// MARK: - UICollectionViewDataSource

extension HomeController: UICollectionViewDataSource {
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

extension HomeController: UICollectionViewDelegate {
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
