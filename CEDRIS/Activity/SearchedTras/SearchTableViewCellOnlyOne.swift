//
//  SearchTableViewCellOnlyOne.swift
//  Rutio
//
//  Created by Kateřina Černá on 03.07.2021.
//

import UIKit

class SearchTableViewCellOnlyOne: UITableViewCell {
    
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var destinationTime: UILabel!
    @IBOutlet weak var destionationTime: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var timeStart: UILabel!
    @IBOutlet weak var timeDestination: UILabel!
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var destination: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func commonInit(startt: String, destinationn: String, numberTransLabel: Int, timeStartt: Int, timeDestinationn: Int) {
        start.text = startt
        destination.text = destinationn
        number.text = String(numberTransLabel)
        timeStart.text = String(timeStartt)
        timeDestination.text = String(timeDestinationn)
        
    }
    
    
}
