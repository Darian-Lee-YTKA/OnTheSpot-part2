//
//  PostsView.swift
//  OnTheSpot
//
//  Created by Darian Lee on 3/9/24.
//

import UIKit
import ParseSwift

class PostsView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(posts.count)
        print(posts)
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        cell.configure(with: posts[indexPath.row])
        return cell
    }

    
    

    @IBOutlet var postButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var postTable: UITableView!
    private var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        postTable.separatorStyle = .none
        postTable.delegate = self
        postTable.dataSource = self
        postTable.allowsSelection = false
        
        
            refreshControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)

            // Add refresh control to table view
            if #available(iOS 10.0, *) {
                postTable.refreshControl = refreshControl
            } else {
                postTable.addSubview(refreshControl)
            }

            // Other setup code...
        }
    @objc private func refreshPosts() {
        
        queryPosts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        queryPosts()
    }
    private var posts = [Post]() {
        didSet {
            // Reload table view data any time the posts variable gets updated.
            postTable.reloadData()
        }
    }
    private func queryPosts() {
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: (-1), to: Date())!
        
        let query = Post.query()
            .include("user")
            .order([.descending("createdAt")])
            .where("createdAt" >= yesterdayDate) // <- Only include results created yesterday onwards
            .limit(10)
        
        // Fetch objects (posts) defined in query (async)
        query.find { [weak self] result in
            switch result {
            case .success(let posts):

                self?.posts = posts
                self?.refreshControl.endRefreshing() // End refreshing when query is complete
                        case .failure(let error):
                            print(error)
                            self?.refreshControl.endRefreshing()
                
            
            }
        }
    }
        
    @IBAction func didPressLogout(_ sender: UIButton){
            showConfirmLogoutAlert()
        }

        private func showConfirmLogoutAlert() {
            let alertController = UIAlertController(title: "Log out of your account?", message: nil, preferredStyle: .alert)
            let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
                NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(logOutAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
    }
    



