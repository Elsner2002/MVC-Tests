//
//  ViewController.swift
//  MVC
//
//  Created by Marina Yamaguti on 18/03/24.
//

import UIKit
import Combine

//MARK: UITableView Sections
enum Section: Int, CaseIterable {
    case nowPlaying
    case popular
    
    var value: String {
        switch self {
        case .nowPlaying:
            return "Now Playing"
        case .popular:
            return "Popular"
        }
    }
}

class MoviesViewController {
    
    static let shared = MoviesViewController()
    
    private init() {}
    
    private let movieService = MovieService.shared
    private var subscriptions = Set<AnyCancellable>()
    
    var sections: [Section] = Section.allCases
    var nowPlaying: [Movie] = []
    var popular: [Movie] = []
    
    func fetchAllMovies(tableView: UITableView) {
        movieService.fetchMovies(fromPlaylist: .nowPlaying)
            .flatMap({ movies in
                movies.publisher
            })
            .flatMap({ movie in
                return self.movieService.fetchMoviePosterFor(posterPath: movie.posterPath)
                    .map({ data in
                        var newMovie = movie
                        newMovie.imageCover = UIImage(data: data)
                        return newMovie
                    })
                    .catch { _ in Just(movie)}//If any publisher fails a midst pipeline, everything eles fails
            })
            .collect()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    return
                }
            }, receiveValue: { movie in
                self.nowPlaying = movie
                self.reloadData(tableView: tableView)
            })
            .store(in: &subscriptions)
        
        movieService.fetchMovies(fromPlaylist: .popular)
            .flatMap({ movies in
                movies.publisher
            })
            .flatMap({ movie in
                return self.movieService.fetchMoviePosterFor(posterPath: movie.posterPath)
                    .map({ data in
                        var newMovie = movie
                        newMovie.imageCover = UIImage(data: data)
                        return newMovie
                    })
                    .catch { _ in Just(movie)}
            })
            .collect()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    return
                }
            }, receiveValue: { movie in
                self.popular = movie
                self.reloadData(tableView: tableView)
            })
            .store(in: &subscriptions)
    }
    
    private func reloadData(tableView: UITableView) {
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
}

// MARK: - Cell Configuration Methods
extension MoviesViewController {
    func configureCell(_ cell: MovieCell, with movie: Movie) {
        var newMovie = movie
        
        if let image = movie.imageCover {
            cell.cover.image = image
        } else {
            if let imageURL = URL(string: movie.posterPath) {
                URLSession.shared.dataTask(with: imageURL) { data, response, error in
                    guard let data = data, error == nil else { return }
                    
                    if let image = UIImage(data: data) {
                        newMovie.imageCover = image
                        
                        DispatchQueue.main.async {
                            cell.cover.image = image
                        }
                    }
                }.resume()
            }
        }
        
        cell.titleLabel.text = newMovie.title
        cell.descriptionLabel.text = newMovie.overview
        cell.ratingLabel.text = String(format: "%.1f", newMovie.voteAverage)
    }
}
