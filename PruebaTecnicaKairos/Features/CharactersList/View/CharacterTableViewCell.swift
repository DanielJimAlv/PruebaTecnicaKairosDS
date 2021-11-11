//
//  CharacterTableViewCell.swift
//  PruebaTecnicaKairos
//
//  Created by Daniel Personal on 11/11/21.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    @IBOutlet private weak var imageViewImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func prepareForReuse() {
        imageViewImage.image = nil
    }
    
    func setup(character: CharacterMarvel) {
        nameLabel.text = character.name
        descriptionLabel.text = character.description
        imageViewImage.loadImage(url: character.imageUrl)
    }
}
