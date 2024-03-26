//
//  Movie.swift
//  MVC
//
//  Created by Waldyr Schneider on 18/03/24.
//

import Foundation
import UIKit

struct MovieResponse: Decodable {
    var results: [Movie]
}

struct Movie: Decodable, CustomStringConvertible, Hashable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
    }
    
    var id: Int
    var title: String
    var overview: String
    var voteAverage: Double
    var posterPath: String
    
    var imageCover: UIImage?
    
    var description: String {
        return "\(self.id)" + " - " + self.title
    }
}

class MovieDBService {
    
    static func setupFetchRequest(url urlString: String) -> URLRequest? {
        
        let headers = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyZDRiNGFiYmNmMTM5MmNhNzY5MWJmN2Q5M2Y0MTVjOSIsInN1YiI6IjY0OWM2NDQ0ZmQ0ZjgwMDBlY2IzZTZkNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.1KVIGHOCX3Kc8HmFRMQR36R9sMkRVlz81ikniCVMig8"
        ]
        
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        
        for (key, value) in headers{
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
    static func fetchImage(posterPath path: String, completionBlock: @escaping (Data) -> Void) {
        guard let request = setupFetchRequest(url: "https://image.tmdb.org/t/p/w342\(path)") else { return }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  error == nil,
                  let data = data
            else { return }
            
            completionBlock(data)
            
        }.resume()
    }
}
