//
//  TableViewCell.swift
//  MoguDemo
//
//  Created by Zhuofan Ma on 11/24/16.
//  Copyright © 2016 Zhuofan Ma. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.startAnimating()
    }

}
