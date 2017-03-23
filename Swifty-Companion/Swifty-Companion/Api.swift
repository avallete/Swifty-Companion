//
//  Api.swift
//  Swifty-Companion
//
//  Created by Andrew VALLETEAU on 3/18/17.
//  Copyright © 2017 Andrew VALLETEAU. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireSwiftyJSON

protocol ApiDelegate: class {
    func handleRequestError(from: String, err: Any)
    func handleRequestSuccess(from: String, data: Any)
}

class Api {
    private let APP_ID = "fad8dff51806c2f84c2b2115db315228d2429d8cc1e4c3cb21ece3dd70160d02"
    private let APP_SECRET = "af4f663fcee515abffe4c99e858b9d06b745cfe6efd72485f0a34e18df46c42b"
    private let APP_REDIRECT_URI = "Swifty://Swifty"
    private let api_url = "https://api.intra.42.fr"
    private var token: AccessToken?
    weak var delegate: ApiDelegate?
    
    func getAccessToken() {
        if token == nil || token?.is_valid == false {
            let parameters: Parameters = [
                "grant_type": "client_credentials",
                "client_id": APP_ID,
                "client_secret": APP_SECRET
            ]
            
            Alamofire.request(api_url + "/oauth/token", method: .post, parameters: parameters, encoding: URLEncoding.default).responseSwiftyJSON {
                dataResponse in
                if (dataResponse.error == nil || dataResponse.response?.statusCode != 200) {
                    if dataResponse.value?["expires_in"] != nil && dataResponse.value?["created_at"] != nil && dataResponse.value?["access_token"] != nil {
                        let expire_date = Date(timeIntervalSince1970: (dataResponse.value!["expires_in"].doubleValue) + (dataResponse.value!["created_at"].doubleValue))
                        let access_token = dataResponse.value!["access_token"].stringValue
                        self.token = AccessToken(access_token: access_token, expire_date: expire_date)
                        self.delegate?.handleRequestSuccess(from: "getAccessToken", data: true)
                    }
                }
                else {
                    self.delegate?.handleRequestError(from: "getAccessToken", err: dataResponse.error!)
                }
            }
        }
    }
    
    func searchUserLogin(login: String) {
        let parameters: Parameters = [
            "range[login]": "\(login),\(login)z",
            "sort": "login"
        ]
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token!.access_token)"
        ]
        
        Alamofire.request(api_url + "/v2/users", method: .get, parameters: parameters, headers: headers).responseSwiftyJSON { dataResponse in
            if (dataResponse.error != nil || dataResponse.response?.statusCode != 200) {
                self.delegate?.handleRequestError(from: "searchUserLogin", err: dataResponse.error!)
            }
            else {
                var users: [User] = []
                for (_, elem) in dataResponse.value! {
                    users.append(User(login: elem["login"].stringValue, id: Int(elem["id"].doubleValue)))
                }
                self.delegate?.handleRequestSuccess(from: "searchUserLogin", data: users)
            }
        }
    }
    
    func getUserInfos(user_id: Int) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token?.access_token)"
        ]
        Alamofire.request(api_url + "/v2/users/\(user_id)", method: .get, headers: headers).responseSwiftyJSON { dataResponse in
            if (dataResponse.error != nil || dataResponse.response?.statusCode != 200) {
                self.delegate?.handleRequestError(from: "getUserInfos", err: dataResponse.error!)
            }
            else {
                self.delegate?.handleRequestSuccess(from: "getUserInfos", data: dataResponse.value!)
            }
        }
    }
}
