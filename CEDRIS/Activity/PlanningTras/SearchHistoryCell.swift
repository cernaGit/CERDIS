//
//  SearchHistoryCell.swift
//  Rutio
//
//  Created by Kateřina Černá on 06.02.2021.
//

import UIKit
import CoreData

class SearchHistoryCell: UITableViewCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let starButton = UIButton(type: .system)
        starButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        starButton.setImage(UIImage(named: "star"), for: .normal)
        starButton.tintColor = .yellow
        starButton.addTarget(self, action: #selector(handMarcAsFavourite), for: .touchUpInside)
        accessoryView = starButton
    }
    
    @objc private func handMarcAsFavourite(){
        print("Marking to favourite")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
