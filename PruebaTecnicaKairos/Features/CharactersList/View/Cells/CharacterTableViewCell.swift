//
//  CharacterTableViewCell.swift
//  PruebaTecnicaKairos
//
//  Created by Daniel Personal on 11/11/21.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func prepareForReuse() {
        imageViewImage.image = nil
    }
    
    func setup(character: CharacterMarvel) {
        nameLabel.text = character.name
        descriptionLabel.text = character.description
        imageViewImage.loadImage(url: character.imageUrl)
    }
}
