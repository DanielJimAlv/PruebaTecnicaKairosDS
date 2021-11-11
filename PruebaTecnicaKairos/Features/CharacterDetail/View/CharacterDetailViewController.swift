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
 
    private let id: Int
    
    private var characterDetatil: CharacterDetail?
    private var viewModel = CharacterDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.getDetail(id: id) { [weak self] maybeError in
            guard let self = self else {
                return
            }
            let detail = self.viewModel.characterDetail
            
            if let imageUrl = detail?.imageUrl {
                self.detailImageView.loadImage(url: imageUrl)
            }
            self.title = detail?.name
            self.descriptionLabel.text = detail?.description
            self.comicsLabel.text = detail?.comics
            self.seriesLabel.text = detail?.series
            self.storiesLabel.text = detail?.stories
            self.eventsLabel.text = detail?.events
        }
    }
    
    init?(id: Int, coder: NSCoder) {
        self.id = id
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
