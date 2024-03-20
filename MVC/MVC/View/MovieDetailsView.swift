//
//  MovieDetailsView.swift
//  MVC
//
//  Created by Waldyr Schneider on 19/03/24.
//

import UIKit

class MovieDetailsView: UIViewController, UIScrollViewDelegate {
    
    let controller: MovieDetailsViewController
    
    init(controller: MovieDetailsViewController) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : .white
        }
        return scrollView
    }()
    
    private var cover: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 10
        return img
    }()
    
    private var titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.preferredFont(forTextStyle: .headline)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private var tagsLabel: UILabel = {
        let tags = UILabel()
        tags.font = UIFont.preferredFont(forTextStyle: .footnote)
        tags.textColor = UIColor.gray
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
        
        cover = UIImageView(image: controller.movie.imageCover)
        titleLabel.text = controller.movie.title
        tagsLabel.text = controller.movie.description
        ratingLabel.text = String(format: "%.1f", controller.movie.voteAverage)
        descriptionLabel.text = controller.movie.overview
        
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.addSubview(cover)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(tagsLabel)
        scrollView.addSubview(starImage)
        scrollView.addSubview(ratingLabel)
        scrollView.addSubview(overviewLabel)
        scrollView.addSubview(descriptionLabel)
        configScrollView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
    
    private func configScrollView() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            cover.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            cover.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            cover.topAnchor.constraint(equalTo: scrollView.topAnchor),
            cover.widthAnchor.constraint(equalToConstant: 128),
            cover.heightAnchor.constraint(equalToConstant: 194),
            
            titleLabel.centerYAnchor.constraint(equalTo: cover.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: cover.trailingAnchor, constant: 12),
            
            tagsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            tagsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
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
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}
