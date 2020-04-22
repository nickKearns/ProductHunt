//
//  PostTableViewCell.swift
//  ProductHuntAssignment
//
//  Created by Nicholas Kearns on 4/22/20.
//  Copyright © 2020 Nicholas Kearns. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var taglineLabel: UILabel!
    
    
    var post: Post? {
        didSet {
            // make sure we return if post doesn't exist
            guard let post = post else { return }
            // Assign our UI elements to their post counterparts
            nameLabel.text = post.name
            taglineLabel.text = post.tagline
            commentsLabel.text = "Comments: \(post.commentsCount)"
            votesLabel.text = "Votes: \(post.votesCount)"
            // We'll write this next!
            updatePreviewImage()
        }
    }
    
    func updatePreviewImage() {
       // make sure we return if post doesn't exist
       guard let post = post else { return }
       // assign the placeholder image to the UI element
       imgView.image = UIImage(named: "placeholder")
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
