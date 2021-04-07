//
//  MovieCell.swift
//  Netflox
//
//  Created by Budia Tirado, Guillem on 2/25/21.
//

import UIKit
import Combine

class MovieCell: UITableViewCell {
    
    private let titleLabel = UILabel.construct {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.font = .boldSystemFont(ofSize: 17)
        $0.textColor = .label
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    private let overviewLabel = UILabel.construct {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 6
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .secondaryLabel
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    private let textStackView = UIStackView.construct {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 4
    }
    
    private let contentStackView = UIStackView.construct {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .top
        $0.distribution = .fill
        $0.spacing = 8
    }
    
    private let posterImageView = UIImageView.construct {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .secondarySystemBackground
        $0.contentMode = .scaleAspectFill
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.heightAnchor.constraint(equalToConstant: 120).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 80).isActive = true
        $0.clipsToBounds = true
    }
    
    private lazy var saveButton = UIButton.construct {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.heightAnchor.constraint(equalToConstant: 24).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 24).isActive = true
        $0.clipsToBounds = true
        $0.setImage(.add, for: .normal)
        $0.addTarget(self, action: #selector(didTapSaveIcon), for: .touchUpInside)
    }
    
    private let activityIndicator = UIActivityIndicatorView.construct {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.style = .medium
        $0.hidesWhenStopped = true
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    private var viewModel: MovieCellViewModel?
    private var subscriptions = Set<AnyCancellable>()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    
    private func initialSetup() {
        [titleLabel, overviewLabel]
            .forEach { textStackView.addArrangedSubview($0) }
        [posterImageView, textStackView, activityIndicator, saveButton]
            .forEach { contentStackView.addArrangedSubview($0) }
                
        contentStackView.pin(inside: contentView,
                             insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
                             isToSafeArea: false)
    }
    
    func setUp(with viewModel: MovieCellViewModel) {
        self.viewModel = viewModel
        bindView()
    }
    
    private func bindView() {
        bindTitle()
        bindOverview()
        bindPosterURL()
        bindIsSaving()
        bindIsSaved()
    }
    
    private func bindTitle() {
        viewModel?
            .$title
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: titleLabel)
            .store(in: &subscriptions)
    }
    
    private func bindOverview() {
        viewModel?
            .$overview
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: overviewLabel)
            .store(in: &subscriptions)
    }
    
    private func bindPosterURL() {
        viewModel?
            .$posterURL
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] (url) in
                self?.posterImageView.loadImage(from: url)
            })
            .store(in: &subscriptions)
    }
    
    private func bindIsSaving() {
        viewModel?
            .$isSaving
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] (isSaving) in
                isSaving ?
                    self?.activityIndicator.startAnimating() :
                    self?.activityIndicator.stopAnimating()
                
                self?.saveButton.isHidden = isSaving
            })
            .store(in: &subscriptions)
    }
    
    private func bindIsSaved() {
        viewModel?
            .$isSaved
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] (isSaved) in
            
                self?.saveButton.setImage(isSaved ? .checkmark : .add, for: .normal)
            })
            .store(in: &subscriptions)
    }
    
    override func prepareForReuse() {
        viewModel = nil
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    @objc func didTapSaveIcon() {
        viewModel?.toggleSaved()
    }
}
