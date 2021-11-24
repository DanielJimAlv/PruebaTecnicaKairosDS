//
//  CharactersListViewController.swift
//  PruebaTecnicaKairos
//
//  Created by Daniel Personal on 11/11/21.
//

import UIKit

final class CharactersListViewController: UITableViewController {
    
    static let identifier = String(describing: CharactersListViewController.self)
    var viewModel: CharacterViewModelProtocol = CharacterViewModel()
    private let activiyIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        getData()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        tableView.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isLoadingSection(section) {
            return 1
        } else {
            return viewModel.characters.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.isLoadingSection(indexPath.section) {
            let cell = tableView.getLoadingCell(with: getData)
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CharacterTableViewCell else {
            fatalError("Could not dequeue Cell")
        }
        cell.setup(character: viewModel.characters[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let id = viewModel.characters[indexPath.row].id
        let detailViewController = CharacterDetailViewController.create(id: id, viewModel: CharacterDetailViewModel())
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    private func showError(_ error: String) {
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        let alert = UIAlertController(title: appName, message: error, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
    
    private func getData() {
        guard !viewModel.isLoadingData, viewModel.hasMoreData else {
            return
        }
        viewModel.getCharacters(with: nil) { [weak self] maybeError in
            if let error = maybeError {
                self?.showError(error)
            }
            
            self?.tableView.reloadData()
        }
    }
    
    private func setupTable() {
        tableView.numberOfSections = 1
    }
}
