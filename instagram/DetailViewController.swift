//
//  DetailViewController.swift
//  instagram
//
//  Created by Han Chi on 2018/2/27.
//  Copyright © 2018年 Han Chi. All rights reserved.
//

import UIKit
import Parse

class DetailViewController: UIViewController {
    var post: PFObject?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let caption = post!["caption"] as! String
        captionLabel.text = caption
        let timestamp = post!.createdAt
        dateLabel.text = dateFormatter(date: timestamp)
        let picture = post!["media"] as! PFFile
        picture.getDataInBackground { (imageData, error) in
            if error == nil {
                let image = UIImage(data: imageData!)
                self.postImageView.image = image
            } else {
                print(error?.localizedDescription ?? "Error instance was nil")
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func dateFormatter(date: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let formatted = formatter.string(from: date!)
        return formatted
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
