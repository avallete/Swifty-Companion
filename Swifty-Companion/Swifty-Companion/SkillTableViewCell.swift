//
//  SkillTableViewCell.swift
//  Swifty-Companion
//
//  Created by Andrew VALLETEAU on 3/16/17.
//  Copyright © 2017 Andrew VALLETEAU. All rights reserved.
//

import UIKit

class SkillTableViewCell: UITableViewCell {

    @IBOutlet weak var skillLevel: UILabel!
    @IBOutlet weak var skillName: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var skill: Skill? {
        didSet {
            if skill != nil {
                skillName.text = skill!.name
                skillLevel.text = "\(skill!.score)"
                progressBar.setProgress(skill!.score.truncatingRemainder(dividingBy: 1.0), animated: true)
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
