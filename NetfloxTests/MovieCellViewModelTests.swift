//
//  MovieCellViewModelTests.swift
//  NetfloxTests
//
//  Created by Budia Tirado, Guillem on 2/26/21.
//

import XCTest
import Combine
@testable import Netflox

class MovieCellViewModelTests: XCTestCase {
    
    var movie: Movie!
    var service: MovieServiceMock!
    var viewModel: MovieCellViewModel!
    
    var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        movie = Movie(id: 1, original_title: "Harry Potter", overview: "Magic movie", poster_path: nil, popularity: 10)
        service = MovieServiceMock()
        viewModel = MovieCellViewModel(with: movie, service: service)
    }

    override func tearDown() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    func testSaveMovieLoading() {
        
        viewModel.toggleSaved()
        
        XCTAssertFalse(viewModel.isSaved)
        XCTAssert(viewModel.isSaving)
    }
    
    func testSavedMovie() {
        
        let expectation = XCTestExpectation()
        
        viewModel.toggleSaved()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            XCTAssert(self.viewModel.isSaved)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }

}
