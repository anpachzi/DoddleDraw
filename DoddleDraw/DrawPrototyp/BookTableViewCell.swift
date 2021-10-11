//
//  BookTableViewCell.swift
//  DrawPrototyp
//
//  Created by Andreas Zikovic on 2018-06-18.
//  Copyright © 2018 Andreas Zikovic. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    @IBOutlet weak var bookTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
