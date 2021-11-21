//
//  CharactersListViewController.swift
//  PruebaTecnicaKairos
//
//  Created by Daniel Personal on 11/11/21.
//

import UIKit

final class CharactersListViewController: UITableViewController {

    private let viewModel = CharacterViewModel()
    private let activiyIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppeareance()
        getData()
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

    @IBSegueAction func segue(_ coder: NSCoder) -> CharacterDetailViewController? {
        guard let selectCharacter = tableView.indexPathForSelectedRow else {
            return nil
        }
        let id = viewModel.characters[selectCharacter.row].id
        return CharacterDetailViewController(id: id, coder: coder)
    }
    
    private func showError(_ error: String) {
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        let alert = UIAlertController(title: appName, message: error, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
    
    private func getData() {
        activiyIndicator.startAnimating()
        viewModel.getCharacters { [weak self] maybeError in
            self?.activiyIndicator.stopAnimating()
            if let error = maybeError {
                self?.showError(error)
            }
            
            self?.tableView.reloadData()
        }
    }
    
    private func setupAppeareance() {
        activiyIndicator.hidesWhenStopped = true
        activiyIndicator.stopAnimating()
        activiyIndicator.style = .large
        view.addSubview(activiyIndicator)
        activiyIndicator.translatesAutoresizingMaskIntoConstraints = false
        activiyIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activiyIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
