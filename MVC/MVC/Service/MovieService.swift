//
//  MovieService.swift
//  MVC
//
//  Created by Waldyr Schneider on 19/03/24.
//

import Foundation
import Combine
import UIKit

protocol Service {
    func apiCall()
}

protocol HTTPClient {
    func perform(_ apiAddress: String)
}

struct URLSessionClient: HTTPClient {
    func perform(_ apiAddress: String) {
        
        guard let url = URL(string: apiAddress) else { return }
        
        URLSession.shared.dataTask(with: url) { dataURL, response, error in
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  error == nil,
                  let dataURL = dataURL
            else {
                print(error ?? "error")
                return
            }
            
            if apiAddress.contains("popular"){
                self.decodeByManualKeys(data: dataURL, type: .popular)
            }
            else {
                self.decodeByManualKeys(data: dataURL, type: .nowPlaying)
            }
        }
        .resume()
    }
    
    func decodeByManualKeys(data: Data, type: Section) {
        do {
            
            guard let rawJSON = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any],
                  let json = rawJSON["results"] as? [[String: Any]]
            else {
                print("Error while parsing JSON")
                return
            }
            
            //get the API data info from it's id
            for movies in json {
                guard let id = movies["id"] as? Int,
                      let title = movies["original_title"] as? String,
                      let overview = movies["overview"] as? String,
                      let posterPath = movies["poster_path"] as? String,
                      let voteAverage = movies["vote_average"] //as? Double,
//                      let genreIDs = movies["genre_ids"] as? [Int]
                else {
                    continue
                }
                
                //save in the respective array
                let movie = Movie(id: id, title: title, overview: overview, voteAverage: voteAverage as! Double, posterPath: posterPath/*, genreIDs: genreIDs*/)
                switch(type){
                case .nowPlaying:
                    MoviesViewController.shared.nowPlaying.append(movie)
                case .popular:
                    MoviesViewController.shared.popular.append(movie)
                }
            }
        } catch {
            print(error)
        }
    }
}

struct MovieService: Service {
    
//    static let shared = MovieService()
    
    var client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    //MARK: Movie Types
    enum MoviePlaylist: String {
        case popular = "popular"
        case nowPlaying = "now_playing"
    }
    //MARK: Poster Sizes
    enum PosterSize: String {
        case w92 = "92"
        case w154 = "154"
        case w185 = "185"
        case w342 = "342"
        case w500 = "500"
        case w780 = "780"
        case original = "original"
    }
    typealias MovieJSON = [String: Any]
    func apiCall() {
        //get the popular movies in API
        client.perform("https://api.themoviedb.org/3/movie/popular?api_key=29e140b5aab9879b19e9118a0af356c9&language=en-US&page=1)")
        
        //get the now playing movies in API
        client.perform("https://api.themoviedb.org/3/movie/now_playing?api_key=2d4b4abbcf1392ca7691bf7d93f415c9&language=en-US&page=1")
    }
    
//    func fetchMovies(fromPlaylist type: MoviePlaylist = .popular, atPage page: Int = 1) -> AnyPublisher<[Movie], Error> {
//        let url = self.buildAPIUrlFor(movieCategory: type.rawValue, atPage: page)
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .tryMap(\.data)
//            .decode(type: MovieResponse.self, decoder: JSONDecoder())
//            .map(\.results)
//            .mapError({ $0 as Error })
//            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
    
    func fetchMoviePosterFor(posterPath: String, withSize size: PosterSize = .w500) -> AnyPublisher<Data, Error> {
        let url = self.buildPosterURLFor(posterPath: posterPath)
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap(\.data)
            .mapError({ $0 as Error })
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension MovieService {
    private func buildAPIUrlFor(movieCategory: String, atPage page: Int) -> URL {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieCategory)?api_key=29e140b5aab9879b19e9118a0af356c9&language=en-US&page=\(page)"
        guard let url = URL(string: urlString) else {
            //in case something happens, return a default first page of popular movies
            return URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=29e140b5aab9879b19e9118a0af356c9&language=en-US&page=1")!
        }
        
        return url
    }
    
    private func buildPosterURLFor(posterPath: String, withSize size: PosterSize = .w500) -> URL {
        let urlString = "https://image.tmdb.org/t/p/\(size)\(posterPath)"
        guard let url = URL(string: urlString) else {
            //in case something happens, return a default poster size of 500
            return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")!
        }
        return url
    }
}
