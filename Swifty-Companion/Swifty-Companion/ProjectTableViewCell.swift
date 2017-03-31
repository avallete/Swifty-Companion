//
//  ProjectTableViewCell.swift
//  Swifty-Companion
//
//  Created by Andrew VALLETEAU on 3/16/17.
//  Copyright © 2017 Andrew VALLETEAU. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var projectScore: UILabel!

    var project: Project? {
        didSet {
            if project != nil {
                projectName.text = project!.name
                projectScore.text = project!.scoreString
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
