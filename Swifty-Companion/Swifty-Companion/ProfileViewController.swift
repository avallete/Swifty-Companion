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

    @IBOutlet weak var profileImageView: UIImageView!
    var data = [(name: String, level: Float)]()

    private func  roundImageView(imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        imageView.clipsToBounds = true;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SkillTableViewCell", for: indexPath) as? SkillTableViewCell {
            let dt = data[indexPath.item];
            print(dt.name);
            print(dt.level.truncatingRemainder(dividingBy: 1.0));
            cell.progressBar.setProgress(dt.level.truncatingRemainder(dividingBy: 1.1), animated: true);
            cell.skillLevel.text = String(dt.level);
            cell.skillName.text = dt.name;
            return cell;
        }
        print("I'm la !");
        let cell = tableView.dequeueReusableCell(withIdentifier: "SkillTableViewCell", for: indexPath) as! UITableViewCell;
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.roundImageView(imageView: profileImageView)
        data.append(("Entreprise", 5.83));
        data.append(("Test", 3.81));
        data.append(("Life", 7.12));
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

