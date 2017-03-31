//
//  LoadingPageViewController.swift
//  Swifty-Companion
//
//  Created by Andrew VALLETEAU on 3/31/17.
//  Copyright © 2017 Andrew VALLETEAU. All rights reserved.
//

import UIKit

class LoadingPageViewController: UIViewController {

    var timer = Timer()
    let logoImage = UIImage(named: "logo_42.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
