//
//  MovieCellViewModel.swift
//  Netflox
//
//  Created by Budia Tirado, Guillem on 2/26/21.
//

import Foundation
import Combine

class MovieCellViewModel: ObservableObject {
    
    @Published private(set) var title: String?
    @Published private(set) var overview: String?
    @Published private(set) var posterURL: URL?
    @Published private(set) var isSaved: Bool = false
    @Published private(set) var isSaving: Bool = false
    
    private let service: MovieServing
    
    var movie: Movie {
        didSet {
            updatePublishers()
        }
    }
    
    init(with movie: Movie, service: MovieServing = MovieService()) {
        self.movie = movie
        self.service = service
        updatePublishers()
    }
    
    private func updatePublishers() {
        title = movie.getTitle()
        overview = movie.getOverview()
        posterURL = movie.getPosterURL()
        isSaved = movie.saved
    }
    
    func update(with movie: Movie) {
        self.movie = movie
    }
    
    func toggleSaved() {
        
        if isSaving { return }
        isSaving = true
        
        service.toggleSave(movie: movie) { [weak self] (movie) in
            DispatchQueue.main.async {
                self?.isSaving = false
                guard let movie = movie else { return }
                self?.update(with: movie)
            }
        }
    }

}

extension MovieCellViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(movie.getID())
    }
}

extension MovieCellViewModel: Equatable {
    static func == (lhs: MovieCellViewModel, rhs: MovieCellViewModel) -> Bool {
        return lhs.movie.getID() == rhs.movie.getID()
    }
}
