//
//  CustomCellTableViewCell.swift
//  UploadMultiImageFileToServer
//
//  Created by Hiem Seyha on 12/9/16.
//  Copyright © 2016 seyha. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {

    @IBOutlet weak var fileImageview: UIImageView!
    
    @IBOutlet weak var pathImageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
