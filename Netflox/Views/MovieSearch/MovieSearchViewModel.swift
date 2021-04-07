//
//  MovieSearchViewModel.swift
//  Netflox
//
//  Created by Budia Tirado, Guillem on 2/26/21.
//

import Foundation
import Combine

class MovieSearchViewModel: NSObject, ObservableObject {
    
    /// 1) What does the view model expose so the view can render all the states?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var movieViewModels: [MovieCellViewModel] = []
    @Published var message: Message?
    
    private let service: MovieServing
    
    init(service: MovieServing = MovieService()) {
        self.service = service
    }
    
    /// 2) What actions does the view model execute from the view?
    
    func searchMovies(with query: String) {
        
        isLoading = true
        clearResults()
        
        service.search(query: query) { [weak self] (movies) in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                guard let movies = movies else {
                    self?.message = Message(title: "Ups!",
                                            description: "Could not get movies")
                    return
                }
                
                self?.movieViewModels = movies.map { MovieCellViewModel(with: $0) }
            }
        }
    }
    
    func movieSelected(in indexPath: IndexPath) {
        let movieViewModel = movieViewModels[indexPath.row]
        self.movieSelected(movieViewModel: movieViewModel)
    }
    
    func movieSelected(movieViewModel: MovieCellViewModel) {
        self.message = Message(title: movieViewModel.movie.getTitle(),
                               description: movieViewModel.movie.getOverview())
    }
    
    func clearResults() {
        movieViewModels.removeAll()
    }


}
