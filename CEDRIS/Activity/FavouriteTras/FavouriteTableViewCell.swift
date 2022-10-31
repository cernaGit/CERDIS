//
//  FavouriteTableViewCell.swift
//  Rutio
//
//  Created by Kateřina Černá on 03.04.2021.
//


import UIKit

class FavouriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func commonInit(name: String, start: String, destination: String) {
        nameLabel.text = name
        startLabel.text = start
        destinationLabel.text = destination

        
        
        
    }
}
