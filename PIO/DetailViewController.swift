//
//  DetailViewController.swift
//  PIO
//
//  Created by Andrew Donoho on 10/27/14.
//  Copyright (c) 2014 Donoho Design Group, LLC. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,
    UITextFieldDelegate, UITextViewDelegate,
    UIImagePickerControllerDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var itemTitle: UITextField!
    @IBOutlet weak var itemProblem: UITextView!
    
    var detailItem: Item? {
        didSet {
            // Update the view.
            if self.isViewLoaded() {
                self.configureView()
            }
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = NSDate(timeIntervalSince1970: detail.timestamp).description
            }
            if let itemTitle = self.itemTitle {
                if let title = detail.title {
                    itemTitle.text = title
                }
                else {
                    itemTitle.text = "Test"
                }
            }
        }
    } // configureView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

