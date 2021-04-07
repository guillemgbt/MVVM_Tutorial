//
//  MovieSearchHostingController.swift
//  Netflox
//
//  Created by Budia Tirado, Guillem on 3/4/21.
//

import UIKit
import SwiftUI

class MovieSearchHostingController: UIHostingController<MovieSearchContentView> {
    
    fileprivate var searchController: UISearchController!
    
    private let viewModel: MovieSearchViewModel


    init() {
        self.viewModel = MovieSearchViewModel()
        super.init(rootView: MovieSearchContentView(viewModel: viewModel))
        
        title = "Netflox"
        setSearchController()
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
}

extension MovieSearchHostingController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            viewModel.searchMovies(with: query)
        }
    }
    
    //Clear results when cancel button is clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.clearResults()
    }
}

struct MovieSearchContentView: View {
    
    @ObservedObject var viewModel: MovieSearchViewModel
    
    var body: some View {
        if viewModel.isLoading {
            ProgressView()
        } else {
            List {
                ForEach(viewModel.movieViewModels, id: \.self) { movieViewModel in
                    MovieCellView(viewModel: movieViewModel)
                        .onTapGesture {
                            viewModel.movieSelected(movieViewModel: movieViewModel)
                        }
                }
            }.alert(item: $viewModel.message) {
                Alert(title: Text($0.title),
                      message: Text($0.description ?? ""))
            }
        }
    }
}

struct MovieCellView: View {
    
    @ObservedObject var viewModel: MovieCellViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            RemoteImage(url: viewModel.posterURL)
                .frame(width: 80, height: 120)
                .background(Color(.systemGroupedBackground))
            VStack(alignment: .leading) {
                Text(viewModel.title ?? "")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(viewModel.overview ?? "")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(6)
            }
            if viewModel.isSaving {
                ProgressView()
            } else {
                Button(action: {
                    viewModel.toggleSaved()
                }, label: {
                    Image(systemName: viewModel.isSaved ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                    
                })
                .frame(width: 32, height: 32)
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

