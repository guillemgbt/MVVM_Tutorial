//
//  MovieSearchViewModelTests.swift
//  NetfloxTests
//
//  Created by Budia Tirado, Guillem on 2/26/21.
//

import XCTest
import Combine
@testable import Netflox

class MovieSearchViewModelTests: XCTestCase {
    
    var service: MovieServiceMock!
    var viewModel: MovieSearchViewModel!
    
    var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        service = MovieServiceMock()
        viewModel = MovieSearchViewModel(service: service)
    }

    override func tearDown() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    func testLoadingState() {
        viewModel.searchMovies(with: "Harry")
        
        XCTAssert(viewModel.isLoading)
        XCTAssert(viewModel.movieViewModels.isEmpty)
        XCTAssertNil(viewModel.message)
    }
    
    func testResultsState() {
        
        let expectation = XCTestExpectation()
        
        viewModel.searchMovies(with: "Harry")
        
        viewModel
            .$movieViewModels
            .dropFirst()
            .sink { (movies) in
                XCTAssertFalse(movies.isEmpty)
                XCTAssertEqual(movies.first?.title, "Harry Potter")
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testErrorState() {
        let expectation = XCTestExpectation()
        
        service.shouldFail = true
        
        viewModel.searchMovies(with: "Harry")
        
        viewModel
            .$message
            .dropFirst()
            .sink { (message) in
                XCTAssertNotNil(message)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssert(viewModel.movieViewModels.isEmpty)
    }
    
    func testClearResults() {
        let expectation = XCTestExpectation()
        
        viewModel.searchMovies(with: "Harry")
        
        viewModel
            .$movieViewModels
            .dropFirst()
            .sink { (movies) in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 0.5)
        
        viewModel.clearResults()
        
        XCTAssert(viewModel.movieViewModels.isEmpty)
    }
    
    func testMovieSelection() {
        let expectation = XCTestExpectation()
        
        viewModel.searchMovies(with: "Harry")
        
        viewModel
            .$movieViewModels
            .dropFirst()
            .sink { (movies) in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 0.5)
        
        viewModel.movieSelected(in: IndexPath(row: 0, section: 0))
        
        XCTAssertNotNil(viewModel.message)
    }

}

class MovieServiceMock: MovieServing {
    
    var shouldFail: Bool = false
    
    func search(query: String, onCompletion: @escaping ([Movie]?) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+0.1, execute: {
            let movies = [Movie(id: 1, original_title: "Harry Potter", overview: "Magic movie", poster_path: nil, popularity: 10),
                          Movie(id: 2, original_title: "Harry Potter 2", overview: "Magic movie 2", poster_path: nil, popularity: 10)]
            
            onCompletion(self.shouldFail ? nil : movies)
        })
    }
    
    func toggleSave(movie: Movie, onCompletion: @escaping (Movie?) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+0.1, execute: {
            if self.shouldFail {
                onCompletion(nil)
                return
            }
            movie.saved.toggle()
            onCompletion(movie)
        })
    }
}
