//
//  MovieCell.swift
//  MVC
//
//  Created by Luciana Lemos on 18/03/24.
//
import UIKit

class MovieCell: UITableViewCell {
    let cover: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        return img
    }()
    let titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.preferredFont(forTextStyle: .headline)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.accessibilityIdentifier = "titleLabel"
        return title
    }()
    let descriptionLabel: UILabel = {
        let description = UILabel()
        description.font = UIFont.preferredFont(forTextStyle: .caption1)
        description.textColor = UIColor.gray
        description.numberOfLines = 3
        description.translatesAutoresizingMaskIntoConstraints = false
        return description
    }()
    let starImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(systemName: "star")
        img.tintColor = UIColor.gray
        img.contentMode = .scaleAspectFit
        return img
    }()
    let ratingLabel: UILabel = {
        let rating = UILabel()
        rating.font = UIFont.preferredFont(forTextStyle: .footnote)
        rating.textColor = UIColor.gray
        rating.translatesAutoresizingMaskIntoConstraints = false
        return rating
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configSubViews() {
        contentView.addSubview(cover)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(starImage)
        contentView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            cover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cover.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cover.widthAnchor.constraint(equalTo: cover.heightAnchor, multiplier: 0.66),
            cover.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: cover.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: cover.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            starImage.bottomAnchor.constraint(equalTo: cover.bottomAnchor),
            starImage.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            starImage.widthAnchor.constraint(equalToConstant: 18),
            starImage.heightAnchor.constraint(equalToConstant: 18),
            
            ratingLabel.leadingAnchor.constraint(equalTo: starImage.trailingAnchor, constant: 4),
            ratingLabel.centerYAnchor.constraint(equalTo: starImage.centerYAnchor),
        ])
    }
}
