//
//  SecondViewController.swift
//  Swifty-Companion
//
//  Created by Andrew VALLETEAU on 3/15/17.
//  Copyright © 2017 Andrew VALLETEAU. All rights reserved.
//

import UIKit
import AlamofireSwiftyJSON


class ResearchTableViewDelegate: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var data: [User] = [
        User(login: "avallete", id: 12324),
        User(login: "avasseur", id: 12324),
        User(login: "milliolsn", id: 12324),
    ]
    var filtered: [User] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResearchTableViewCell", for: indexPath)
        cell.textLabel?.text = filtered[indexPath.item].login
        return cell;
    }
}

class ResearchViewController: UIViewController, UISearchBarDelegate, ApiDelegate {
    var searchActive : Bool = false
    var filtered:[User] = []
    let researchTableViewDelegate = ResearchTableViewDelegate()

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var researchBar: UISearchBar! {
        didSet {
            researchBar.delegate = self;
        }
    }

    @IBOutlet weak var researchTableView: UITableView! {
        didSet {
            researchTableView.delegate = researchTableViewDelegate;
            researchTableView.dataSource = researchTableViewDelegate;
        }
    }
    
    func handleRequestError(from: String, err: Any) {
        print("From: \(from) err: \(err as? Error)");
    }
    
    func handleRequestSuccess(from: String, data: Any) {
        if from == "searchUserLogin" {
            if let users = data as? [User] {
                researchTableViewDelegate.data = users
                researchTableViewDelegate.filtered = users
                researchTableView.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count >= 3  && searchText.characters.count < 9 {
            let data = researchTableViewDelegate.data;
            researchTableViewDelegate.filtered = data.filter({ (user) -> Bool in
                let tmp: String = user.login.lowercased()
                return (tmp.hasPrefix(searchText.lowercased()))
            })
            if(researchTableViewDelegate.filtered.count == 0){
                searchActive = false;
                api.getAccessToken()
                api.searchUserLogin(login: searchText.lowercased())
            } else {
                searchActive = true;
            }
            self.researchTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.hidesWhenStopped = true;
        loadingIndicator.stopAnimating();
        api.delegate = self;
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
