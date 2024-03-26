//
//  ViewController.swift
//  MVC
//
//  Created by Marina Yamaguti on 18/03/24.
//

import UIKit
import Combine

#warning("Ver o que testar da UI")
class MoviesView: UIViewController {
    weak var coordinator: MainCoordinator?
    
    //MARK: - UITableView Sections    
    private let tableView = UITableView()
    
    private var controller: MoviesViewController  = MoviesViewController.shared
    
    
    private var searchController = UISearchController()
    private var searchedMovies = [Movie]()
    private var isSearching: Bool = false
    
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.controller.fetchAllMovies(tableView: tableView)
        configViews()
    }

    
    private func configViews() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
        tableView.rowHeight = 118
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension MoviesView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var movie: Movie!
        
        if isSearching {
            movie = searchedMovies[indexPath.row]
        } else {
            if indexPath.section == 0 {
                movie = controller.nowPlaying[indexPath.row]
            } else if indexPath.section == 1 {
                movie = controller.popular[indexPath.row]
            }
        }
        
        MovieDetailsViewController.shared.setMovie(movie)
        coordinator?.goToDetails(movie: movie)
       
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - TableView DataSource
extension MoviesView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? 1 : controller.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isSearching ? "" : controller.sections[section].value
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchedMovies.count
        }
        
        let currentSection = controller.sections[section]
        
        switch currentSection {
        case .nowPlaying:
            return controller.nowPlaying.count
        case .popular:
            return controller.popular.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = controller.sections[indexPath.section]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else { fatalError() }
        var movie: Movie
        controller.movieInRow(cell: cell, indexPath, tableView)
        if isSearching {
            movie = searchedMovies[indexPath.row]
        } else {
            switch currentSection {
            case .nowPlaying:
                movie = controller.nowPlaying[indexPath.row]
            case .popular:
                movie = controller.popular[indexPath.row]
            }
        }
        
        controller.configureCell(cell, with: movie)
    
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CGFloat.greatestFiniteMagnitude)
        
        return cell
    }
    
}

extension MoviesView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let allMovies = getMoviesToSearch()
        
        searchedMovies = allMovies.filter { $0.title.prefix(searchText.count) == searchText }
        isSearching = true
        tableView.reloadData()
    }
    
    private func getMoviesToSearch() -> [Movie] {
        var allMovies: [Movie] = controller.popular + controller.nowPlaying
        var moviesIDS: [Int] = allMovies.compactMap { $0.id }
        moviesIDS = Array(Set(moviesIDS))
        
        var unrepeatedMovies: [Movie] = []
        for id in moviesIDS {
            guard let movie = allMovies.first(where: { $0.id == id }) else { return [] }
            unrepeatedMovies.append(movie)
        }
        
        allMovies = unrepeatedMovies
        
        return allMovies
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        tableView.reloadData()
    }
}

