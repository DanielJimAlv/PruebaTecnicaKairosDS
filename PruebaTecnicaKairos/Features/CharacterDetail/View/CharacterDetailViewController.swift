//
//  CharacterDetailViewController.swift
//  PruebaTecnicaKairos
//
//  Created by Daniel Personal on 11/11/21.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var comicsLabel: UILabel!
    @IBOutlet weak var seriesLabel: UILabel!
    @IBOutlet weak var storiesLabel: UILabel!
    @IBOutlet weak var eventsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var id: Int!
    private var viewModel: CharacterDetailViewModelProtocol!
    
    static let identifier = String(describing: CharacterDetailViewController.self)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppeareance()
        getData()
    }
    
    static func create(id: Int, viewModel: CharacterDetailViewModelProtocol) -> CharacterDetailViewController {
        guard let result = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: identifier) as? CharacterDetailViewController else {
            fatalError("Coult not cast to \(identifier)")
        }
        result.viewModel = viewModel
        result.id = id
        
        return result
    }
    
    private func getData() {
        activityIndicator.startAnimating()
        viewModel.getDetail(id: id, sessionConfiguration: nil) { [weak self] maybeError in
            guard let self = self else {
                return
            }
            self.activityIndicator.stopAnimating()
            
            if let error = maybeError {
                self.showError(error)
                return
            }
            
            let detail = self.viewModel.characterDetail
            
            self.updateView(with: detail)
        }
    }
    
    private func setupAppeareance() {
        descriptionLabel.text = nil
        comicsLabel.text = nil
        seriesLabel.text = nil
        storiesLabel.text = nil
        eventsLabel.text = nil
    }
    
    private func updateView(with detail: CharacterDetail?) {
        if let imageUrl = detail?.imageUrl {
            self.detailImageView.loadImage(url: imageUrl)
        }
        title = detail?.name
        descriptionLabel.text = detail?.description
        comicsLabel.text = detail?.comics
        seriesLabel.text = detail?.series
        storiesLabel.text = detail?.stories
        eventsLabel.text = detail?.events
    }
    
    private func showError(_ error: String) {
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        let alert = UIAlertController(title: appName, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
}
