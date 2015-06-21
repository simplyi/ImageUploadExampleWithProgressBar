//
//  ViewController.swift
//  MyImageUploadExampleWithProgressView
//
//  Created by Sergey Kargopolov on 2015-06-21.
//  Copyright (c) 2015 Sergey Kargopolov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate  {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var imageUploadProgressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib. 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func uploadButtonTapped(sender: AnyObject) {
      
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        myImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        myImageView.backgroundColor = UIColor.clearColor()
        self.dismissViewControllerAnimated(true, completion: nil)
        
        uploadImage()
        
    }
    
    func uploadImage()
    {
        let imageData = UIImageJPEGRepresentation(myImageView.image, 1)
        
        if(imageData == nil )  { return }
        
        self.uploadButton.enabled = false
        
        
        let uploadScriptUrl = NSURL(string:"http://www.swiftdeveloperblog.com/http-post-example-script/")
        var request = NSMutableURLRequest(URL: uploadScriptUrl!)
        request.HTTPMethod = "POST"
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        var session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        
        var task = session.uploadTaskWithRequest(request, fromData: imageData)
        task.resume()
    
    }
    
    
     func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?)
     {
        let myAlert = UIAlertView(title: "Alert", message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "Ok")
        myAlert.show()
        
        self.uploadButton.enabled = true
        
     }
    
    
     func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64)
    {
        var uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        
        imageUploadProgressView.progress = uploadProgress
        let progressPercent = Int(uploadProgress*100)
        progressLabel.text = "\(progressPercent)%"
        
    }
    
     func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void)
     {
       self.uploadButton.enabled = true
    }
    

}

