//
//  seeFeedbackView.swift
//  OnTheSpot
//
//  Created by Darian Lee on 3/15/24.
//

import UIKit
import Foundation
import UIKit
import ParseSwift
class seeFeedbackView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedbacks.count // Return the count of feedbacks directly
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feebbackCell", for: indexPath) as? FeedbackCell else{
            return UITableViewCell()
        }
        cell.myFeedback = feedbacks[indexPath.row]
        cell.configure(with: feedbacks[indexPath.row])
        return cell
    }
    
    func queryFeedbacks() {
        let query = Feedback.query()
            .include("user")
            .order([.descending("createdAt")])
        
        // Fetch objects (posts) defined in query (async)
        query.find { [weak self] result in
            switch result {
            case .success(let feedbacks):
                self?.feedbacks = feedbacks
                DispatchQueue.main.async {
                    self?.feedbackTable.reloadData() // Reload table view data after getting feedbacks
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBOutlet var feedbackTable: UITableView!
    private var feedbacks = [Feedback]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackTable.separatorStyle = .none
        feedbackTable.delegate = self
        feedbackTable.dataSource = self
        feedbackTable.allowsSelection = false
        queryFeedbacks() // No need for an empty closure here
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        queryFeedbacks() // No need for an empty closure here
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
class FeedbackCell: UITableViewCell {

    @IBOutlet var feedbackLab: UILabel!
    @IBOutlet var wantToUpVote: UIButton!
    
    @IBOutlet var upvoteNum: UILabel!
    @IBOutlet var usernameDateLab: UILabel!
    @IBOutlet var alreadyUpvoted: UIButton!
    var myFeedback: Feedback?
    func configure(with feedback: Feedback){
        guard let user = feedback.user, let dateCreated =  feedback.createdAt else{
            print("no user or date")
            return }
        usernameDateLab.text = "\(user.username!) \(String(describing: dateCreated))"
        print(user.username!)
        guard let feedbackContent = feedback.feedback else{
            print("no feedback content")
            return }
        feedbackLab.text = feedbackContent
        guard let totalLikes = feedback.upvotes else{
            print("no upvotes")
            upvoteNum.text = "0"
            return }
        upvoteNum.text = String(describing: totalLikes)
        if let currentUser = User.current, let upvoters = feedback.upvoters {
            if upvoters.contains(currentUser){
                alreadyUpvoted.isHidden = false
                wantToUpVote.isHidden = true
            }
        }
        else{
            alreadyUpvoted.isHidden = true
            wantToUpVote.isHidden = false
        }
    }
    @IBAction func didTapUpvote(_ sender: UIButton){
        guard var feedback = self.myFeedback else {
                return
            }
            
            // Check if the user has already upvoted
        if let currentUser = User.current, let upvoters = feedback.upvoters, upvoters.contains(currentUser) {

                return
            }
            
 
            if var totalLikes = feedback.upvotes {
                totalLikes += 1
                feedback.upvotes = totalLikes
                upvoteNum.text = String(totalLikes)

                feedback.save { result in
                    switch result {
                    case .success:
                        print("Upvote saved successfully.")
                        // Optionally, update UI or notify the user
                    case .failure(let error):
                        print("Error upvoting feedback: \(error)")
                        // Handle the error, maybe show an alert to the user
                    }
                }
            }
        }
    
   
}
struct Feedback: ParseObject {

    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?


    var feedback: String?
    var upvotes: Int?
    var upvoters: [User]? // for keeping track of who upvoted
    var user: User?
    var imageFile: ParseFile?
    var post: Post?
}
