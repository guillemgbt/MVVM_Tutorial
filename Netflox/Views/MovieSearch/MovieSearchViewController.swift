//
//  MovieSearchViewController.swift
//  Netflox
//
//  Created by Budia Tirado, Guillem on 2/25/21.
//

import UIKit
import Combine

class MovieSearchViewController: UIViewController {
    
    typealias DataSource = UITableViewDiffableDataSource<MovieSearchViewController.Section, MovieCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<MovieSearchViewController.Section, MovieCellViewModel>
    
    enum Section {
        case main
    }
    
    fileprivate var activityIndicator: UIActivityIndicatorView!
    fileprivate var searchController: UISearchController!
    fileprivate var tableView: UITableView!
    private var dataSource: DataSource!
    
    private let viewModel: MovieSearchViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        self.viewModel = MovieSearchViewModel()
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Netflox"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchController()
        setTableView()
        setTableDataSource()
        setActivityIndicator()
        
        bindView()
    }
    
    private func bindView() {
        bindMovies()
        bindIsLoading()
        bindMessage()
    }
    
    private func bindMovies() {
        viewModel
            .$movieViewModels
            .map { movies -> Snapshot in
                var snapshot = Snapshot()
                snapshot.appendSections([.main])
                snapshot.appendItems(movies, toSection: .main)
                return snapshot
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (snapshot) in
                self?.dataSource.apply(snapshot)
            }
            .store(in: &subscriptions)
    }
    
    private func bindIsLoading() {
        viewModel
            .$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (isLoading) in
                
                isLoading ?
                    self?.activityIndicator.startAnimating() :
                    self?.activityIndicator.stopAnimating()
            
            }
            .store(in: &subscriptions)
    }
    
    private func bindMessage() {
        viewModel
            .$message
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (message) in
                guard let message = message else { return }
                self?.show(message: message)
            }
            .store(in: &subscriptions)
    }
    
    private func setSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    private func setTableView() {
        tableView = UITableView()
        tableView.pin(inside: view)
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register(MovieCell.self)
        tableView.alwaysBounceVertical = true
        tableView.delegate = self
    }
    
    private func setActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.pin(inside: view)
    }
    
    private func setTableDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, movieViewModel) -> UITableViewCell? in
            let cell: MovieCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUp(with: movieViewModel)
            return cell
        })
    }
    
}

extension MovieSearchViewController: UISearchBarDelegate {
    
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

extension MovieSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.movieSelected(in: indexPath)
    }
    
}
