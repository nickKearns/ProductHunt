//
//  CommentsViewController.swift
//  ProductHuntAssignment
//
//  Created by Nicholas Kearns on 4/22/20.
//  Copyright © 2020 Nicholas Kearns. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {

    @IBOutlet weak var commentsTableView: UITableView!
    
    var comments: [String]! {
        didSet {
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
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


extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell

        let comment = comments[indexPath.row]
        cell.commentTextView.text = comment
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    
    
}
