//
//  FirstViewController.swift
//  Swifty-Companion
//
//  Created by Andrew VALLETEAU on 3/15/17.
//  Copyright © 2017 Andrew VALLETEAU. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var skillTableView: UITableView! {
        didSet {
            skillTableView.delegate = self;
            skillTableView.dataSource = self;
        }
    }
    @IBOutlet weak var projectTableView: UITableView! {
        didSet {
            projectTableView.delegate = self;
            projectTableView.dataSource = self;
        }
    }

    @IBOutlet weak var profileImageView: UIImageView!
    
    let skillData = [
        Skill(name: "Entreprise", score: 5.97),
        Skill(name: "ThisIsLife", score: 12.10),
        Skill(name: "Koko & L'asticot", score: 5.45),
        Skill(name: "HOUnlous sla", score: 2.75),
        Skill(name: "NONON lalala", score: 3.42)
    ]
    
    let projectData = [
        Project(name: "This is live", score: 101, validated: true, status: "finished"),
        Project(name: "This is l2", score: 10, validated: false, status: "finished"),
        Project(name: "Thisve", score: 82, validated: true, status: "finished"),
        Project(name: "Thie", score: 0, validated: false, status: "in_progress")
    ]
    
    private func  roundImageView(imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        imageView.clipsToBounds = true;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skillData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SkillTableViewCell", for: indexPath) as? SkillTableViewCell {
            let skill = skillData[indexPath.item];
            cell.skill = skill
            return cell;
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell", for: indexPath) as? ProjectTableViewCell {
            let project = projectData[indexPath.item];
            cell.project = project
            return cell;
        }
        return UITableViewCell()
    }
    
    override func viewDidLayoutSubviews() {
        self.roundImageView(imageView: profileImageView);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

