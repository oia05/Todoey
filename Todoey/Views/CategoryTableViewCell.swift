//
//  CategoryTableViewCell.swift
//  Todoey
//
//  Created by Omar Assidi on 28/12/2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class CategoryTableViewCell: SwipeTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindCellWithItem(_ category: Category) {
        backgroundColor = UIColor(hexString: category.color ?? "#FFFFFF")
        self.textLabel?.text = category.name
        accessoryType = .disclosureIndicator
    }

}
