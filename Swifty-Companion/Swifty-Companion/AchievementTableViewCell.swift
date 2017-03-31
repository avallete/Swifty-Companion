//
//  AchievementTableViewCell.swift
//  Swifty-Companion
//
//  Created by Andrew VALLETEAU on 3/23/17.
//  Copyright © 2017 Andrew VALLETEAU. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireSwiftyJSON


class AchievementTableViewCell: UITableViewCell, UIWebViewDelegate {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var iconWebView: UIWebView! {  // Here we use webView for Achievements images to allow svg format and data caching.
        didSet {
            iconWebView.delegate = self
        }
    }
    @IBOutlet weak var achievementDescription: UITextView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var achievement: Achievement? {
        didSet {
            if achievement != nil {
                name.text = achievement!.name
                achievementDescription.text = achievement!.description
                if achievement?.svgData == nil {
                    let utilityQueue = DispatchQueue.global(qos: .background)
                    Alamofire.request("https://api.intra.42.fr\(achievement!.imageUrl)", method: .get).responseString(queue: utilityQueue){ response in
                        if (response.result.isSuccess && response.response?.statusCode == 200 ){
                            self.achievement?.svgData = response.result.value
                            DispatchQueue.main.async {
                                self.iconWebView.loadHTMLString(response.result.value!, baseURL: nil)
                            }
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.iconWebView.loadHTMLString(self.achievement!.svgData!, baseURL: nil)
                    }
                }
            }
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
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
