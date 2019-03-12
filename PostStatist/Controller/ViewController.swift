//
//  ViewController.swift
//  PostStatist
//
//  Created by Nikita Nechyporenko on 11.03.2019.
//  Copyright © 2019 Nikita Nechyporenko. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var slugTextField: UITextField!
    
    var arrUsersWhoLike = [User]()
    var arrCommentators = [User]()
    var arrMentions = [User]()
    var arrReposters = [User]()
    var viewsCount = ""
    var likesCount = ""
    var commentatorsCount = ""
    var mentionsCount = ""
    var repostersCount = ""
    var bookmarkCount = ""
    var idForRequest = ""
    let token = ["Authorization" : "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjJmNGU5ZDA1MzU3MDI3MmFlMGZhZTMzM2Y4ZTY4ZWVlMWNiMzc0NmM0Mjg5NzI0ZTExNzJjM2Q4ODYzNDNkNDkyY2ZjZjI4Njg0NzQ0MGEwIn0.eyJhdWQiOiIyIiwianRpIjoiMmY0ZTlkMDUzNTcwMjcyYWUwZmFlMzMzZjhlNjhlZWUxY2IzNzQ2YzQyODk3MjRlMTE3MmMzZDg4NjM0M2Q0OTJjZmNmMjg2ODQ3NDQwYTAiLCJpYXQiOjE1MzY4MzE4ODcsIm5iZiI6MTUzNjgzMTg4NywiZXhwIjoxNTY4MzY3ODg3LCJzdWIiOiIzOCIsInNjb3BlcyI6W119.dRitRnoqNFS3xUgtLdLiDjDVVe7ZFNrh24Qm2ML9m-V7kZpgQgajArYoS44kMa1dz_MHUhq3pqk8SnAYIsULgfrOvewTUzmH1C92-yL64Uqnv7lqWizldX2fbJ2IbB8khOCtQ-CCNA_fGY_zEBJXLsOqr4Z00tbZE6fa0PX4Mu0SsuUakLeygXbXnKOmFyZmLJZWoXKpbqiSBU239nrcyqJftBon8DL1BAUuFiadap-gpVSXj8h6BX-FsJx5cgPHFiijIalcEgzOq4VCMkwbQE8xbTsmmxkZUOnM7oKab5inzl8EV5iUgcExeSbHT6k_phOkA7XUaR6PhVoKrSQTPcfdijhME1IHfPVDPGO0vhd6hKszRrhjEPEpoothBoB8ss0lmuCFURdxFv17q97rfpDn1OfO_Y3wYuRW2lqFAnw7sLd92CHjfONwQKswLDzwE4hiQhB8iS_UEbuL_UamNOiCLfjNnVWbVc9BvoReEa8jG4coc0Kv9VNJVWh3D_hGf8dLRZBd1a7zB6-nSpKGf0eAzB0_rBXsyBepjudC-5EFDjloJOxy1Mdruoq6mQa_tFcO99JRteUSd0CXHZO-CN4Bp4xND9kstdutjBn2UWT5xhNq_QRBmBsBDAwp647dUCyQofutN9GUlu2LxmhL0ojydazdND_d9rHtY9t-ndw"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestOnIdPost(slug: slugTextField.text!)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "statisticVC") {
            let vc = segue.destination as? StatisticVC
            vc?.arrUsersWhoLike = arrUsersWhoLike
            vc?.arrCommentators = arrCommentators
            vc?.arrMentions = arrMentions
            vc?.arrReposters = arrReposters
            vc?.viewsCount = viewsCount
            vc?.likesCount = likesCount
            vc?.commentatorsCount = commentatorsCount
            vc?.mentionsCount = mentionsCount
            vc?.repostersCount = repostersCount
            vc?.bookmarkCount = bookmarkCount
        }
    }
    
    //get those who made repost
    func requestReposters(id: String) {
        
        let parameters: Parameters = ["id": id]
        let headers = token
        let urlLink = "https://api.inrating.top/v1/users/posts/reposters/all"
        
        Alamofire.request(urlLink, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    let swiftyJson = JSON(response.data!)
                    let data = swiftyJson["data"]
                    for i in 0..<data.count {
                        let nickname = data[i]["nickname"].string!
                        let avatar = data[i]["avatar_image"]
                        let urlImage = avatar["url_small"].string!
                        let reposters = User.init(imageUrl: urlImage, name: nickname)
                        self.arrReposters.append(reposters)
                        self.repostersCount = String(self.arrReposters.count)
                    }
                }
                else {
                    debugPrint("HTTP Request Log in failed: \(String(describing: response.result.error))")
                }
        }
    }
    
    // get those who mention
    func requestMentions(id: String) {
        
        let parameters: Parameters = ["id": id]
        let headers = token
        let urlLink = "https://api.inrating.top/v1/users/posts/mentions/all"
        
        Alamofire.request(urlLink, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    let swiftyJson = JSON(response.data!)
                    let data = swiftyJson["data"]
                    for i in 0..<data.count {
                        let nickname = data[i]["nickname"].string!
                        let avatar = data[i]["avatar_image"]
                        let urlImage = avatar["url_small"].string!
                        let mentions = User.init(imageUrl: urlImage, name: nickname)
                        self.arrMentions.append(mentions)
                        self.mentionsCount = String(self.arrMentions.count)
                    }
                }
                else {
                    debugPrint("HTTP Request Log in failed: \(String(describing: response.result.error))")
                }
        }
    }
    
    //get those who commented post
    func requestCommentators(id: String) {
        
        let parameters: Parameters = ["id": id]
        let headers = token
        let urlLink = "https://api.inrating.top/v1/users/posts/commentators/all"
        
        Alamofire.request(urlLink, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    let swiftyJson = JSON(response.data!)
                    let data = swiftyJson["data"]
                    for i in 0..<data.count {
                        let nickname = data[i]["nickname"].string!
                        let avatar = data[i]["avatar_image"]
                        let urlImage = avatar["url_small"].string!
                        let commentator = User.init(imageUrl: urlImage, name: nickname)
                        self.arrCommentators.append(commentator)
                        self.commentatorsCount = String(self.arrCommentators.count)
                    }
                }
                else {
                    debugPrint("HTTP Request Log in failed: \(String(describing: response.result.error))")
                }
        }
    }
    
    //get those who liked post
    func requestOnWhoLikes(id: String) {
        
        let parameters: Parameters = ["id": id]
        let headers = token
        let urlLink = "https://api.inrating.top/v1/users/posts/likers/all"
        
        Alamofire.request(urlLink, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    let swiftyJson = JSON(response.data!)
                    let data = swiftyJson["data"]
                    for i in 0..<data.count {
                        let nickname = data[i]["nickname"].string!
                        let avatar = data[i]["avatar_image"]
                        let urlImage = avatar["url_small"].string!
                        let userWhoLike = User.init(imageUrl: urlImage, name: nickname)
                        self.arrUsersWhoLike.append(userWhoLike)
                    }
                }
                else {
                    debugPrint("HTTP Request Log in failed: \(String(describing: response.result.error))")
                }
        }
    }
    
    //get the basic data of the post
    func requestOnIdPost(slug: String) {
        
        let headers = token
        let urlLink = "https://api.inrating.top/v1/users/posts/get?slug=" + slug
        
        Alamofire.request(urlLink, method: .post, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    let swiftyJson = JSON(response.data!)
                    let id = swiftyJson["id"].int
                    let like = swiftyJson["likes_count"].int
                    self.likesCount = String(like!)
                    let views = swiftyJson["views_count"].int
                    self.viewsCount = String(views!)
                    self.idForRequest = String(id!)
                    let bookmarks = swiftyJson["bookmarks_count"].int
                    self.bookmarkCount = String(bookmarks!)
                    self.requestReposters(id: self.idForRequest)
                    self.requestMentions(id: self.idForRequest)
                    self.requestCommentators(id: self.idForRequest)
                    self.requestOnWhoLikes(id: self.idForRequest)
                }
                else {
                    debugPrint("HTTP Request Log in failed: \(String(describing: response.result.error))")
                }
        }
    }
    
    @IBAction func statisticsButton(_ sender: Any) {
        
    }
}


