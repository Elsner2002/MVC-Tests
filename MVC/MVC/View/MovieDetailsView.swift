//
//  MovieDetailsView.swift
//  MVC
//
//  Created by Waldyr Schneider on 19/03/24.
//

import UIKit

#warning("Ver o que testar da UI")
class MovieDetailsView: UIViewController, UIScrollViewDelegate {
    
    weak var coordinator: MainCoordinator?
    
    let controller: MovieDetailsViewController = MovieDetailsViewController.shared
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.contentSize.width = UIScreen.main.bounds.width
        scrollView.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : .white
        }
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private var cover: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        return img
    }()
    
    private var titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.preferredFont(forTextStyle: .headline)
        title.numberOfLines = 2
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private var tagsLabel: UILabel = {
        let tags = UILabel()
        tags.font = UIFont.preferredFont(forTextStyle: .footnote)
        tags.textColor = UIColor.gray
        tags.numberOfLines = 3
        tags.translatesAutoresizingMaskIntoConstraints = false
        return tags
    }()
    
    private let starImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(systemName: "star")
        img.tintColor = UIColor.gray
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private var ratingLabel: UILabel = {
        let rating = UILabel()
        rating.font = UIFont.preferredFont(forTextStyle: .footnote)
        rating.textColor = UIColor.gray
        rating.translatesAutoresizingMaskIntoConstraints = false
        return rating
    }()
    
    private let overviewLabel: UILabel = {
        let overview = UILabel()
        overview.font = UIFont.preferredFont(forTextStyle: .headline)
        overview.text = "Overview"
        overview.translatesAutoresizingMaskIntoConstraints = false
        return overview
    }()
    
    private var descriptionLabel: UILabel = {
        let description = UILabel()
        description.font = UIFont.preferredFont(forTextStyle: .callout)
        description.textColor = UIColor.gray
        description.numberOfLines = 0
        description.translatesAutoresizingMaskIntoConstraints = false
        return description
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.accessibilityIdentifier = "movieDetailsNavigationBar"

        title = "Details"
        
        if let movie = controller.movie {
            cover.image = movie.imageCover
            titleLabel.text = movie.title
            tagsLabel.text = movie.description
            ratingLabel.text = String(format: "%.1f", movie.voteAverage)
            descriptionLabel.text = movie.overview
        } else {
            print("Error loading the movie")
        }

        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.delegate = self
        contentView.addSubview(cover)
        contentView.addSubview(titleLabel)
        contentView.addSubview(tagsLabel)
        contentView.addSubview(starImage)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(descriptionLabel)
        configScrollView()
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        scrollView.contentOffset.x = 0
//    }
    
    private func configScrollView() {
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            cover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cover.topAnchor.constraint(equalTo: contentView.topAnchor),
            cover.widthAnchor.constraint(equalToConstant: 128),
            cover.heightAnchor.constraint(equalToConstant: 194),
            
            titleLabel.centerYAnchor.constraint(equalTo: cover.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: cover.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            tagsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            tagsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            tagsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            starImage.bottomAnchor.constraint(equalTo: cover.bottomAnchor, constant: -8),
            starImage.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            starImage.widthAnchor.constraint(equalToConstant: 18),
            starImage.heightAnchor.constraint(equalToConstant: 18),
            
            ratingLabel.leadingAnchor.constraint(equalTo: starImage.trailingAnchor, constant: 4),
            ratingLabel.centerYAnchor.constraint(equalTo: starImage.centerYAnchor),
            
            overviewLabel.topAnchor.constraint(equalTo: cover.bottomAnchor, constant: 16),
            overviewLabel.leadingAnchor.constraint(equalTo: cover.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: cover.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}
