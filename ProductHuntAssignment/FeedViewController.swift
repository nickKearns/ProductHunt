//
//  FeedViewController.swift
//  ProductHuntAssignment
//
//  Created by Nicholas Kearns on 4/22/20.
//  Copyright © 2020 Nicholas Kearns. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    
    
    @IBOutlet weak var feedTableView: UITableView!
    
    // Array of Post objects to simulate real data coming in
    // Make sure each property that we're assigning to a UI element has a value for each mock Post.
    //    var mockData: [Post] = {
    //        var meTube = Post(id: 0, name: "MeTube", tagline: "Stream videos for free!", votesCount: 25, commentsCount: 4)
    //        var boogle = Post(id: 1, name: "Boogle", tagline: "Search anything!", votesCount: 1000, commentsCount: 50)
    //        var meTunes = Post(id: 2, name: "meTunes", tagline: "Listen to any song!", votesCount: 25000, commentsCount: 590)
    //
    //        return [meTube, boogle, meTunes]
    //    }()
    //
    
    var posts: [Post] = [] {
        didSet {
            feedTableView.reloadData()
        }
    }
    
    
    let networkManager = NetworkManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.delegate = self
        feedTableView.dataSource = self
        updateFeed()
        // Do any additional setup after loading the view.
    }
    
    
    func updateFeed() {
        networkManager.getPosts() { result in
            self.posts = result
        }
    }
    
}





extension FeedViewController: UITableViewDataSource {
    /// Determines how many cells will be shown on the table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    /// Creates and configures each cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue and return an available cell, instead of creating a new cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        
        let post = posts[indexPath.row]
        
        cell.post = post
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // provide a fixed size
        return 250
    }
}

// MARK: UITableViewDelegate
extension FeedViewController: UITableViewDelegate {
    // Code to handle cell events goes here...
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        // Get the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        // Get the commentsView from the storyboard
        guard let commentsView = storyboard.instantiateViewController(withIdentifier: "commentsView") as? CommentsViewController else {
            return
        }
        // add mock comments
        commentsView.comments = ["Blah blah blah!", "Good app.", "Wow."]
        navigationController?.pushViewController(commentsView, animated: true)
    }
}

