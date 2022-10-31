//
//  SearchTableViewCell.swift
//  Rutio
//
//  Created by Kateřina Černá on 02.04.2021.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    static let identifier = "SearchedTrasView"
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var startLabel2: UILabel!
    @IBOutlet weak var startLabel3: UILabel!
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var destinationLabel2: UILabel!
    @IBOutlet weak var destinationLabel3: UILabel!
    
    @IBOutlet weak var numberStartLabel: UILabel!
    @IBOutlet weak var numberMeziLabel: UILabel!
    @IBOutlet weak var numberDestionationLabel: UILabel!
    
    @IBOutlet weak var startTrasnsportImage: UIImageView!
    @IBOutlet weak var meziTransportImage: UIImageView!
    @IBOutlet weak var destinationTransportImage: UIImageView!
    
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var startTime2: UILabel!
    @IBOutlet weak var startTime3: UILabel!
    
    @IBOutlet weak var destiantionTime: UILabel!
    @IBOutlet weak var destinationTime2: UILabel!
    @IBOutlet weak var destinationTime3: UILabel!
    
    @IBOutlet weak var walkLabel2: UILabel!
    @IBOutlet weak var walkLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        startLabel.text = nil
        startLabel2.text = nil
        startLabel3.text = nil
        
        destinationLabel.text = nil
        destinationLabel2.text = nil
        destinationLabel3.text = nil
        
        numberStartLabel.text = nil
        numberMeziLabel.text = nil
        numberDestionationLabel.text = nil
        
        startTime.text = nil
        startTime2.text = nil
        startTime3.text = nil
        
        destiantionTime.text = nil
        destinationTime2.text = nil
        destinationTime3.text = nil
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func commonInit(start: String, destination: String, numberStart: Int,  timeStart: Int, timeDestination: Int, start2: String, destination2: String, numberStart2: Int,  timeStart2: Int, timeDestination2: Int, start3: String, destination3: String, numberStart3: Int,  timeStart3: Int, timeDestination3: Int, walk: String, walk2: String) {
        startLabel.text = start
        destinationLabel.text = destination
        numberStartLabel.text = String(numberStart)
        startTime.text = String(timeStart)
        destiantionTime.text = String(timeDestination)
        
        if (start2, destination2, walk, numberStart2, timeStart2, timeDestination2, start3, destination3, walk2, numberStart3, timeStart3, timeDestination3) != nil {
            startLabel2.text = start2
            startLabel2.isHidden = false
            destinationLabel2.text = destination2
            destinationLabel2.isHidden = false
            numberMeziLabel.text = String(numberStart2)
            numberMeziLabel.isHidden = false
            startTime2.text = String(numberStart2)
            startTime2.isHidden = false
            destinationTime2.text = String(numberStart2)
            destinationTime2.isHidden = false
            startLabel3.text = start2
            startLabel3.isHidden = false
            destinationLabel3.text = destination2
            destinationLabel3.isHidden = false
            numberDestionationLabel.text = String(numberStart2)
            numberDestionationLabel.isHidden = false
            startTime3.text = String(numberStart2)
            startTime3.isHidden = false
            destinationTime3.text = String(numberStart2)
            destinationTime3.isHidden = false
        } else {
            startLabel2.isHidden = true
            destinationLabel2.isHidden = true
            numberMeziLabel.isHidden = true
            startTime2.isHidden = true
            destinationTime2.isHidden = true
            startLabel3.isHidden = true
            destinationLabel3.isHidden = true
            numberDestionationLabel.isHidden = true
            startTime3.isHidden = true
            destinationTime3.isHidden = true
        }
    }
    
    
}
