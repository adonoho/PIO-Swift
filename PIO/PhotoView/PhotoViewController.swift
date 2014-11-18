//
//  PhotoViewController.swift
//  PIO
//
//  Created by Andrew Donoho on 11/17/14.
//  Copyright (c) 2014 Donoho Design Group, LLC. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    var photo: Photo?
    
    @IBOutlet weak var imageView: UIImageView!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let data = self.photo?.imageData?.data {
            
            let image = UIImage(data: data, scale: 0.0)
            
            self.imageView.image = image
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
