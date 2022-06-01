//
//  HistoryController.swift
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

class HistoryController: BaseController {
  var viewModel: HistoryViewModelProtocol!
  
  private(set) lazy var collectionView: UICollectionView = {
    let layout = CardsCollectionViewLayout()
    layout.isRotated = true
    let collectionView = UICollectionView(
      frame: view.bounds,
      collectionViewLayout: layout
    )
    let screenWidth = UIScreen.main.bounds.width - 40
    layout.itemSize = CGSize(width: screenWidth,
                                 height: 260)
    collectionView.backgroundColor = .clear
    collectionView.isPagingEnabled = true
    collectionView.showsVerticalScrollIndicator = false
    return collectionView
  }()
  
  private(set) lazy var blob: UIImageView = {
    let imageView = UIImageView()
    imageView.image = R.image.bgWaves2()!
    imageView.frame = .init(x: -282, y: -80, width: 1041, height: 1041)
    return imageView
  }()
  
  private(set) lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
    return refreshControl
  }()
}

// MARK: - Lifecycle

extension HistoryController {
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

private extension HistoryController {
  func setup() {
    setupBlobs()
    setupTitleLabel()
    setupCollectionView()
    triggerInitialLoad()
  }
  
  func setupBlobs() {
    view.addSubview(blob)
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

private extension HistoryController {
  func bind() {

  }
}

// MARK: - Router

private extension HistoryController {
  func navigateToDetailView(withViewModel detailViewModel: DetailViewModelProtocol) {
    let vc = DetailController()
    vc.viewModel = detailViewModel
    navigationController?.pushViewController(vc, animated: true)
  }
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
  func handleTracksFetchingSuccess() -> VoidResult {
    return { [weak self] in
      SVProgressHUD.dismiss()
      self?.refreshControl.endRefreshing()
      self?.collectionView.reloadData()
    }
  }
}

// MARK: - Helpers

private extension HistoryController {
  func triggerInitialLoad() {
    SVProgressHUD.show(withStatus: "Fetching tracks")
  }
  
  @objc func fetchData() {
    viewModel.fetchAllLastVisited(
      onSuccess: handleTracksFetchingSuccess()
    )
  }
}

// MARK: - UICollectionViewDataSource

extension HistoryController: UICollectionViewDataSource {
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

extension HistoryController: UICollectionViewDelegate {
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
