//
//  CharacterDetailViewController.swift
//  PruebaTecnicaKairos
//
//  Created by Daniel Personal on 11/11/21.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    @IBOutlet private weak var detailImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var comicsLabel: UILabel!
    @IBOutlet private weak var seriesLabel: UILabel!
    @IBOutlet private weak var storiesLabel: UILabel!
    @IBOutlet private weak var eventsLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private let id: Int
    
    private var characterDetatil: CharacterDetail?
    private var viewModel = CharacterDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
    }
    
    init?(id: Int, coder: NSCoder) {
        self.id = id
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getData() {
        activityIndicator.startAnimating()
        viewModel.getDetail(id: id) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.activityIndicator.stopAnimating()
            
            let detail = self.viewModel.characterDetail
            
            self.updateView(with: detail)
        }
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
}
