//
//  SearchTableViewCellWithPres.swift
//  Rutio
//
//  Created by Kateřina Černá on 03.07.2021.
//

import UIKit

class SearchTableViewCellWithPres: UITableViewCell {
    
    @IBOutlet weak var startLabel1: UILabel!
    @IBOutlet weak var destinationLabel1: UILabel!
    @IBOutlet weak var startLabel2: UILabel!
    @IBOutlet weak var destinationLabel2: UILabel!
    @IBOutlet weak var numberStartLabel: UILabel!
    @IBOutlet weak var numberDestinationLabel: UILabel!
    @IBOutlet weak var startTime1: UILabel!
    @IBOutlet weak var destiantionTime1: UILabel!
    @IBOutlet weak var startTime2: UILabel!
    @IBOutlet weak var destiantionTime2: UILabel!
    
    
    override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
}

override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
}

func commonInit(start: String, start2: String, destination: String,destination2: String, numberStart: Int, numberDestination: Int, timeStart: Int, timeDestination: Int, timeStart2: Int, timeDestination2: Int) {
    startLabel1.text = start
    destinationLabel1.text = destination
    numberStartLabel.text = String(numberStart)
    numberDestinationLabel.text = String(numberStart)
    startLabel2.text = start2
    destinationLabel2.text = destination2
    startTime1.text = String(timeStart)
    destiantionTime1.text = String(timeDestination)
    startTime2.text = String(timeStart2)
    destiantionTime2.text = String(timeDestination2)

}


}
