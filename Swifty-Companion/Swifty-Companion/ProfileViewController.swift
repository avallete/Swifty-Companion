//
//  FirstViewController.swift
//  Swifty-Companion
//
//  Created by Andrew VALLETEAU on 3/15/17.
//  Copyright © 2017 Andrew VALLETEAU. All rights reserved.
//

import UIKit

class ProjectTableViewDelegate: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var data = [
        Project(name: "This is live", score: 101, validated: true, status: "finished"),
        Project(name: "This is l2", score: 10, validated: false, status: "finished"),
        Project(name: "Thisve", score: 82, validated: true, status: "finished"),
        Project(name: "Thie", score: 0, validated: false, status: "in_progress")
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell", for: indexPath) as? ProjectTableViewCell {
            cell.project = data[indexPath.item]
            return cell;
        }
        return UITableViewCell();
    }
}

class SkillTableViewDelegate: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var data = [
        Skill(name: "Entreprise", score: 5.97),
        Skill(name: "ThisIsLife", score: 12.10),
        Skill(name: "Koko & L'asticot", score: 5.45),
        Skill(name: "HOUnlous sla", score: 2.75),
        Skill(name: "NONON lalala", score: 3.42)
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SkillTableViewCell", for: indexPath) as? SkillTableViewCell {
            cell.skill = data[indexPath.item]
            return cell;
        }
        return UITableViewCell();
    }
}


class ProfileViewController: UIViewController {
    let projectTableViewDelegate = ProjectTableViewDelegate()
    let skillTableViewDelegate = SkillTableViewDelegate()
    
    @IBOutlet weak var skillTableView: UITableView! {
        didSet {
            skillTableView.delegate = self.skillTableViewDelegate;
            skillTableView.dataSource = self.skillTableViewDelegate;
        }
    }
    
    @IBOutlet weak var projectTableView: UITableView! {
        didSet {
            projectTableView.delegate = self.projectTableViewDelegate;
            projectTableView.dataSource = self.projectTableViewDelegate;
        }
    }

    @IBOutlet weak var profileImageView: UIImageView!
    
    private func  roundImageView(imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        imageView.clipsToBounds = true;
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

