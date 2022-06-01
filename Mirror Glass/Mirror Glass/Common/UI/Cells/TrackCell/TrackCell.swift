//
//  TrackCellCell.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation
import UIKit

import AlamofireImage
import PureLayout
import RxCocoa
import RxSwift

class TrackCell: UICollectionViewCell {
  static let reuseId = String(describing: TrackCell.self)
  
  var viewModel: TrackCellViewModelProtocol! {
    didSet {
      bind()
      refresh()
    }
  }
  
  private var disposeBag = DisposeBag()
  
  // MARK: UI Elements
  private(set) lazy var backgroundMaterialView: UIVisualEffectView = {
    let visualEffectView = UIVisualEffectView()
    visualEffectView.effect = UIBlurEffect(style: .systemThinMaterial)
    visualEffectView.layer.cornerRadius = 30
    visualEffectView.clipsToBounds = true
    return visualEffectView
  }()
  
  private(set) lazy var foregroundVibrancyView: UIVisualEffectView = {
    let visualEffectView = UIVisualEffectView()
    visualEffectView.effect = UIVibrancyEffect(
      blurEffect: UIBlurEffect(style: .systemThinMaterial),
      style: .label
    )
    return visualEffectView
  }()
  
  private(set) lazy var trackImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = nil
    imageView.backgroundColor = R.color.textSecondary()!
    imageView.frame = CGRect(x: 0, y: 0, width: 43, height: 64)
    return imageView
  }()
  
  private(set) lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .title3).bold()
    label.numberOfLines = 2
    label.textColor = R.color.textPrimary()!
    label.textAlignment = .natural
    return label
  }()
  
  private(set) lazy var genreLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .caption1)
    label.numberOfLines = 1
    label.textColor = R.color.textSecondary()!
    label.textAlignment = .natural
    return label
  }()
  
  private(set) lazy var kindLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .footnote).bold()
    label.numberOfLines = 1
    label.textColor = R.color.textSecondary()!
    label.textAlignment = .natural
    return label
  }()
  
  private(set) lazy var shortDescriptionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .body)
    label.numberOfLines = 2
    label.textColor = R.color.textSecondary()!
    label.textAlignment = .natural
    label.sizeToFit()
    return label
  }()
  
  private(set) lazy var separatorView: UIView = {
    let view = UIView()
    view.backgroundColor = R.color.separatorColor()!
    return view
  }()
  
  private(set) lazy var priceLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.font = UIFont.preferredFont(forTextStyle: .title3).bold()
    label.textColor = R.color.textPrimary()!
    label.textAlignment = .natural
    return label
  }()
  
  private(set) lazy var chevronImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "chevron.right")
    imageView.frame = CGRect(x: 0, y: 0, width: 35, height: 28)
    imageView.tintColor = R.color.textPrimary()!
    return imageView
  }()
  
  // MARK: Constructors
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: Lifecycle
  override func prepareForReuse() {
    super.prepareForReuse()
  }
}

// MARK: - Setup

private extension TrackCell {
  func setup() {
    setupBackgroundConfiguration()
    setupViews()
  }
  
  func setupBackgroundConfiguration() {
    var config = UIBackgroundConfiguration.listPlainCell()
    config.backgroundColor = nil
    backgroundConfiguration = config
  }
  
  func setupViews() {
    self.contentView.backgroundColor = .clear
    self.backgroundColor = .clear
    setupSubviews()
  }
  
  func setupSubviews() {
    contentView.addSubview(backgroundMaterialView)
    backgroundMaterialView.contentView.addSubview(foregroundVibrancyView)
    foregroundVibrancyView.contentView.addSubview(trackImageView)
    foregroundVibrancyView.contentView.addSubview(titleLabel)
    foregroundVibrancyView.contentView.addSubview(genreLabel)
    foregroundVibrancyView.contentView.addSubview(kindLabel)
    foregroundVibrancyView.contentView.addSubview(shortDescriptionLabel)
    foregroundVibrancyView.contentView.addSubview(separatorView)
    foregroundVibrancyView.contentView.addSubview(priceLabel)
    foregroundVibrancyView.contentView.addSubview(chevronImageView)
    setupAutoLayoutConstraints()
  }
  
  func setupAutoLayoutConstraints() {
    setupBackgroundMaterialViewConstraints()
    setupForegroundVibrancyViewConstraints()
    setupTrackImageViewConstraints()
    setupTitleLabelConstraints()
    setupGenreLabelConstraints()
    setupKindLabelViewConstraints()
    setupShortDescriptionLabelConstraints()
    setupSeparatorViewConstraints()
    setupPriceLabelConstraints()
    setupChevronImageViewConstraints()
  }
  
  func setupBackgroundMaterialViewConstraints() {
    backgroundMaterialView.autoPinEdgesToSuperviewEdges(
      with: .init(top: 8, left: 0, bottom: 8, right: 0)
    )
  }
  
  func setupForegroundVibrancyViewConstraints() {
    foregroundVibrancyView.autoPinEdgesToSuperviewEdges()
  }
  
  func setupTrackImageViewConstraints() {
    trackImageView.autoPinEdge(.top, to: .top, of: foregroundVibrancyView.contentView, withOffset: 30)
    trackImageView.autoPinEdge(.leading, to: .leading, of: foregroundVibrancyView.contentView, withOffset: 20)
    trackImageView.autoSetDimensions(to: .init(width: 43, height: 64))
  }
  
  func setupTitleLabelConstraints() {
    titleLabel.autoPinEdge(.top, to: .top, of: trackImageView)
    titleLabel.autoPinEdge(.leading, to: .trailing, of: trackImageView, withOffset: 12)
    titleLabel.autoPinEdge(.trailing, to: .trailing, of: foregroundVibrancyView.contentView, withOffset: -20)
  }
  
  func setupGenreLabelConstraints() {
    genreLabel.autoPinEdge(.top, to: .bottom, of: titleLabel)
    genreLabel.autoPinEdge(.leading, to: .trailing, of: trackImageView, withOffset: 12)
    genreLabel.autoPinEdge(.trailing, to: .trailing, of: foregroundVibrancyView.contentView, withOffset: -20)
  }
  
  func setupKindLabelViewConstraints() {
    kindLabel.autoPinEdge(.top, to: .bottom, of: trackImageView, withOffset: 12)
    kindLabel.autoPinEdge(.leading, to: .leading, of: foregroundVibrancyView.contentView, withOffset: 20)
    kindLabel.autoPinEdge(.trailing, to: .trailing, of: foregroundVibrancyView.contentView, withOffset: 20)
    kindLabel.autoSetDimension(.height, toSize: 18)
  }
  
  func setupShortDescriptionLabelConstraints() {
    shortDescriptionLabel.autoPinEdge(.top, to: .bottom, of: kindLabel, withOffset: 12)
    shortDescriptionLabel.autoPinEdge(.leading, to: .leading, of: foregroundVibrancyView.contentView, withOffset: 20)
    shortDescriptionLabel.autoPinEdge(.trailing, to: .trailing, of: foregroundVibrancyView.contentView, withOffset: -20)
  }
  
  func setupSeparatorViewConstraints() {
    separatorView.autoPinEdge(.top, to: .bottom, of: shortDescriptionLabel, withOffset: 12)
    separatorView.autoPinEdge(.leading, to: .leading, of: foregroundVibrancyView.contentView, withOffset: 20)
    separatorView.autoPinEdge(.trailing, to: .trailing, of: foregroundVibrancyView.contentView, withOffset: -20)
    separatorView.autoSetDimension(.height, toSize: 1)
  }
  
  func setupPriceLabelConstraints() {
    priceLabel.autoPinEdge(.top, to: .bottom, of: separatorView, withOffset: 12)
    priceLabel.autoPinEdge(.leading, to: .leading, of: foregroundVibrancyView.contentView, withOffset: 20)
    priceLabel.autoPinEdge(.bottom, to: .bottom, of: foregroundVibrancyView.contentView, withOffset: -30)
    priceLabel.autoSetDimension(.height, toSize: 30)
  }
  
  func setupChevronImageViewConstraints() {
    chevronImageView.autoPinEdge(.bottom, to: .bottom, of: priceLabel, withOffset: -4)
    chevronImageView.autoPinEdge(.trailing, to: .trailing, of: separatorView)
  }
}

// MARK: - Bindings

private extension TrackCell {
  func bind() {
    disposeBag = DisposeBag()
    guard viewModel != nil else { return }
  }
}

// MARK: - Refresh

private extension TrackCell {
  func refresh() {
    guard viewModel != nil else { return }
    trackImageView.af_setImage(withURL: viewModel.trackImageUrl)
    titleLabel.text = viewModel.title
    genreLabel.text = viewModel.genre
    kindLabel.text = viewModel.kind
    shortDescriptionLabel.text = viewModel.shortDescription
    priceLabel.text = viewModel.price
    chevronImageView.isHidden = !viewModel.showChevronIcon
    shortDescriptionLabel.isHidden = !viewModel.showDescription
  }
}

// MARK: - Helpers

private extension TrackCell {

}
