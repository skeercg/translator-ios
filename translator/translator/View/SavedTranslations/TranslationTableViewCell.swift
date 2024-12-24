//
//  TranslationTableViewCell.swift
//  translator
//
//  Created by Чингис Богдатов on 14.12.2024.
//

import UIKit

class TranslationTableViewCell: UITableViewCell {
    
    public static let identifier = "translationItemCell"
    
    public var onStarClick: (() -> Void)?
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor(hex: 0x202020)
        setupConstraints()
        setupGestureRecognizers()
    }
    
    
    public func configure(item: TranslationItem, onStarClick: @escaping () -> Void){
        mainLabel.text = item.sourceText
        secondaryLabel.text = item.targetText
        let starImageName = item.isSaved ? "star.fill" : "star"
        starImageView.image = UIImage(systemName: starImageName)
        self.onStarClick = onStarClick

    }

    private func setupConstraints(){
        contentView.addSubview(mainLabel)
        contentView.addSubview(secondaryLabel)
        contentView.addSubview(starImageView)
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            mainLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            secondaryLabel.leadingAnchor.constraint(equalTo: mainLabel.leadingAnchor),
            secondaryLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4),
            secondaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            starImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            starImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            starImageView.widthAnchor.constraint(equalToConstant: 20),
            starImageView.heightAnchor.constraint(equalToConstant: 20)
            
        ])
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(starImageTapped))
        starImageView.addGestureRecognizer(tapGesture)
    }
        
    @objc private func starImageTapped() {
        onStarClick?()
    }

}
