//
//  TodoeyItemCell.swift
//  Todoey
//
//  Created by Omar Assidi on 26/12/2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit

class TodoeyItemCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindCellWithItem(_ item: TodoeyItem) {
        textLabel?.text = item.title ?? ""
        accessoryType = item.isChecked ? .checkmark : .none
    }

}
