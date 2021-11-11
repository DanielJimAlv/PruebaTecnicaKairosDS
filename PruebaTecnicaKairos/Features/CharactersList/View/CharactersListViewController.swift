//
//  CharactersListViewController.swift
//  PruebaTecnicaKairos
//
//  Created by Daniel Personal on 11/11/21.
//

import UIKit

final class CharactersListViewController: UITableViewController {
    
    private let viewModel = CharacterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getCharacters { [weak self] maybeError in
            if let error = maybeError {
                self?.showError(error)
            }
            
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CharacterTableViewCell else {
            fatalError("Could not dequeue Cell")
        }
        cell.setup(character: viewModel.characters[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    private func showError(_ error: String) {
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        let alert = UIAlertController(title: appName, message: error, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
}
