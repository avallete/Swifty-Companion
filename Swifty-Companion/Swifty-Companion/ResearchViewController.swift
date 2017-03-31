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
            // This segue is trigger if user click on a result into researchTableView
            // So we hydrate our next viewController with the selected userId, allowing the next page to retrieve UserInformations.

            let index = researchTableView.indexPathForSelectedRow!
            let vc = segue.destination as! ProfileViewController
            vc.userId = researchTableViewDelegate.filtered[index.item].id
            api.delegate = vc
        }
    }
    
    func handleRequestError(from: String, err: Error?) {
        if from == "searchUserLogin" {
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
            }
        }
        let alert = UIAlertController(title: "Request Error", message: "From: \(from) Err: \(err)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        // If press enter on search bar, select the first element on list and show profile.

        if searchBar.text != nil && researchTableViewDelegate.filtered.count > 0 {
            let rowToSelect = IndexPath(row: 0, section: 0)
            researchTableView.selectRow(at: rowToSelect, animated: true, scrollPosition: .top)
            performSegue(withIdentifier: "userProfileSegue", sender: self)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Filter searched elements in cache if exist, else, perform a request to get elements.

        // If searchText contain only valid login characters
        if searchText.rangeOfCharacter(from: self.loginCharacterSet.inverted) == nil {
            // If size is > 2 (to avoid too many requests) and < 10 (max len of login + 1)
            if searchText.characters.count >= 2  && searchText.characters.count < 10 {
                let data = researchTableViewDelegate.data;
                
                // Filter data based on already retrieved data
                researchTableViewDelegate.filtered = data.filter({ (user) -> Bool in
                    let tmp: String = user.login.lowercased()
                    return (tmp.hasPrefix(searchText.lowercased()))
                })
                
                // Else retrieve data from API
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
        researchTableView.tableFooterView = UIView(frame: .zero) // Little trick to allow an auto-hiding listView when empty
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
