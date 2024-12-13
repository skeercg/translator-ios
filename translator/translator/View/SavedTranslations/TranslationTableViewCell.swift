//
//  TranslationTableViewCell.swift
//  translator
//
//  Created by Чингис Богдатов on 14.12.2024.
//

import UIKit

class TranslationTableViewCell: UITableViewCell {
    
    public static let identifier = "translationItemCell"
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    
    public func configure(item: TranslationItem){
        mainLabel.text = item.firstLanguageText
        secondaryLabel.text = item.secondLanguageText
        let starImageName = item.isSaved ? "star.fill" : "star"
        starImageView.image = UIImage(systemName: starImageName)
    }

    private func setupConstraints(){
        contentView.addSubview(mainLabel)
        contentView.addSubview(secondaryLabel)
        contentView.addSubview(starImageView)
        
        contentView.backgroundColor = .black
        
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

}
