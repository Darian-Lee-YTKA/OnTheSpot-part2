//
//  postCell.swift
//  OnTheSpot
//
//  Created by Darian Lee on 3/9/24.
//

import Foundation
import UIKit
import ParseSwift
import Alamofire
import AlamofireImage


class PostCell: UITableViewCell {

    
    @IBOutlet var viewWhite: UIView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var captionLabel: UILabel!
    @IBOutlet var addFeedback: UIButton!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    private var imageDataRequest: DataRequest?


    func configure(with post: Post) {
        viewWhite.layer.cornerRadius = 12
        if let user = post.user {
            usernameLabel.text = user.username!
            print(user.username!)
        }
        
        guard let caption = post.caption else {
            print("no caption")
            return
        }
        captionLabel.text = "Notes: " + caption
        print(caption)
        
        guard let question = post.question else {
            print("no question")
            return
        }
        questionLabel.text = "Prompt: " + question
        print(question)
        
        guard let date = post.createdAt else {
            print("no date")
            return
        }

       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateString = dateFormatter.string(from: date)
        print(dateString)
        dateLabel.text = dateString
        

        if let imageFile = post.imageFile,
           let imageUrl = imageFile.url {
            
            // Use AlamofireImage helper to fetch remote image from URL
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    self?.postImageView.image = image
                    print("we got the image!")
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }

        
        

    }
    

    override func prepareForReuse() {
        super.prepareForReuse()
            postImageView.image = nil

            // Cancel image request.
            imageDataRequest?.cancel()

        }
}
struct Post: ParseObject {

    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?


    var caption: String?
    var question: String?
    var user: User?
    var imageFile: ParseFile?
}
    
