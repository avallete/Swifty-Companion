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
    var data: [User] = []
    var filtered: [User] = []
    
    func tableView(_ tableoView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    let researchTableViewDelegate = ResearchTableViewDelegate()
    let loginCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-")

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userProfileSegue" {
            let index = researchTableView.indexPathForSelectedRow!
            let vc = segue.destination as! ProfileViewController
            vc.userId = researchTableViewDelegate.filtered[index.item].id
            api.delegate = vc
        }
    }
    
    func handleRequestError(from: String, err: Error?) {
        print("From: \(from) err: \(err)");
    }
    
    func handleRequestSuccess(from: String, data: Any) {
        if from == "searchUserLogin" {
            if let users = data as? [User] {
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    self.researchTableViewDelegate.data = users
                    self.researchTableViewDelegate.filtered = users
                    self.researchTableView.reloadData()
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            print("Button Cliked ! : \(searchBar.text!)")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.rangeOfCharacter(from: self.loginCharacterSet.inverted) == nil {
            if searchText.characters.count >= 3  && searchText.characters.count < 9 {
                let data = researchTableViewDelegate.data;
                researchTableViewDelegate.filtered = data.filter({ (user) -> Bool in
                    let tmp: String = user.login.lowercased()
                    return (tmp.hasPrefix(searchText.lowercased()))
                })
                if(researchTableViewDelegate.filtered.count == 0){
                    searchActive = false;
                    self.loadingIndicator.startAnimating()
                    api.getAccessToken()
                    api.searchUserLogin(login: searchText.lowercased())
                }
                else {
                    searchActive = true;
                }
                self.researchTableView.reloadData()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        api.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        researchTableView.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
