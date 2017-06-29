//
//  TimeOfLifeTableViewCell.swift
//  TimeOfLife
//
//  Created by 王志輝 on 2017/6/19.
//  Copyright © 2017年 Woody. All rights reserved.
//

import UIKit

class TimeOfLifeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
