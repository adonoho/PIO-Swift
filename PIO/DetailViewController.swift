//
//  DetailViewController.swift
//  PIO
//
//  Created by Andrew Donoho on 10/27/14.
//  Copyright (c) 2014 Donoho Design Group, LLC. All rights reserved.
//

import UIKit
import CoreData
import AssetsLibrary

class DetailViewController: UIViewController,
    UITextFieldDelegate, UITextViewDelegate,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var itemTitle: UITextField!
    @IBOutlet weak var itemProblem: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var item: Item? {
        didSet {
            // Update the view.
            if self.isViewLoaded() {
                self.configureView()
            }
        }
    }

    var sourceType: UIImagePickerControllerSourceType {
        get {
//            return .Camera
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                
                return .Camera
            }
            else if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) {
                
                return .SavedPhotosAlbum
            }
            else {
                
                return .PhotoLibrary;
            }
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let item = self.item {
            if let label = self.detailDescriptionLabel {
                label.text = NSDate(timeIntervalSince1970: item.timestamp).description
            }
            if let itemTitle = self.itemTitle {
                if let title = item.title {
                    itemTitle.text = title
                }
                else {
                    itemTitle.text = "Test"
                }
            }
            if let itemProblem = self.itemProblem {
                if let problem = item.problem {
                    itemProblem.text = problem
                }
                else {
                    itemProblem.text = "Test 2"
                }
            }
            if let data = item.photo?.imageData?.data {
                
                let image = UIImage(data: data, scale: 0.0)
                
                self.imageView.image = image
            }
        }
    } // configureView()
    
    func showCamera() -> UIImagePickerController {
        
        let ipc = UIImagePickerController()
        
        ipc.delegate = self
        ipc.sourceType = self.sourceType
        
        self.navigationController?.presentViewController(ipc, animated: true, completion: nil)
        
        return ipc
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.configureView()
        
        if let item = self.item {
            
            if item.photo? == nil {
                self.showCamera()
            }
        }
    }

    override func viewWillDisappear(animated: Bool) {

        super.viewWillDisappear(animated)

        if let item = self.item {

            if item.title? != self.itemTitle.text {
                
                item.title = self.itemTitle.text
            }
            if item.problem? != self.itemProblem.text {
                
                item.problem = self.itemProblem.text
            }
            let moc = item.managedObjectContext!
            
            if moc.hasChanges {
                
                moc.save(nil)
            }
        }

    } // viewWillDisappear()
    
//    override func viewWillAppear(animated: Bool) {
//        
//        super.viewWillAppear(animated)
//        
//        self.configureView()
//        
//    } // viewWillAppear()
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.configureView()
        
    } // viewDidAppear()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPhoto" {
            let pvc = segue.destinationViewController as PhotoViewController
            pvc.photo = self.item?.photo
        }
    }
    
    // MARK: - UITextFieldDelegate methods.

    func textFieldShouldReturn(textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        return false
    }

    // MARK: - UITextViewDelegate methods.

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {

        if range.length == 0 && text == "\n" {

            textView.resignFirstResponder()

            return false
        }
        return true
    }

    // MARK: - UIImagePickerControllerDelegate methods.

    func saveData(data: NSData, metaData info: [NSObject : AnyObject]) {

        if let item = self.item {

            let moc = item.managedObjectContext!

            if let photo = item.photo {

                moc.deleteObject(photo)
            }
            let photo = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext: moc) as Photo
            let imageData = NSEntityDescription.insertNewObjectForEntityForName("ImageData", inManagedObjectContext: moc) as ImageData
            let imageMetaData = NSEntityDescription.insertNewObjectForEntityForName("ImageMetaData", inManagedObjectContext: moc) as ImageMetaData

            photo.imageData = imageData
            photo.imageMetaData = imageMetaData
            item.photo = photo

            imageData.data = data

            if NSJSONSerialization.isValidJSONObject(info) {

                imageMetaData.data = NSJSONSerialization
                    .dataWithJSONObject(info,
                        options: NSJSONWritingOptions(),
                        error: nil)
            }
            moc.save(nil)
        }
        
    } // saveData(_:metaData:)
    
    func saveAssetWithMediaInfo(mediaInfo: [NSObject : AnyObject]) {

        if let assetURL = mediaInfo[UIImagePickerControllerReferenceURL] as? NSURL {
            
            let library = ALAssetsLibrary()
            
            library.assetForURL(assetURL, resultBlock: { (asset: ALAsset!) -> Void in
                
                let property = asset.valueForProperty(ALAssetPropertyType) as NSString
                
                if property == ALAssetTypePhoto {
                    
                    for uti in asset.valueForProperty(ALAssetPropertyRepresentations) as [NSString] {
                        
                        if uti == "public.jpeg" {
                            
                            let representation = asset.representationForUTI(uti)
                            let size = Int(representation.size())
                            let bytes = UnsafeMutablePointer<UInt8>.alloc(size)

                            if bytes != nil {
                              
                                representation.getBytes(bytes, fromOffset: 0, length: size, error: nil)
                                let data = NSData(bytesNoCopy:bytes, length: size, freeWhenDone: true)
                                self.saveData(data, metaData: mediaInfo)
                            }
                        }
                    }
                }
            }, failureBlock: { (error) -> Void in
                
                NSLog("%@", error.userInfo!)
            })
        }
    } // saveAssetWithMediaInfo(_:)

    func saveImage(image: UIImage, metaData info: [NSObject : AnyObject]) {
        
        if let data = UIImageJPEGRepresentation(image, 1.0) {

            self.saveData(data, metaData: info)
        }

    } // saveImage(_:metaData:)

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {

            var mInfo = info

            mInfo.removeValueForKey(UIImagePickerControllerOriginalImage)

            self.saveImage(image, metaData: mInfo)
        }
        else { self.saveAssetWithMediaInfo(info)}
        
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)

    } // imagePickerController(_:didFinishPickingMediaWithInfo)

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {

        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)

    } // imagePickerControllerDidCancel(_:)

}
