//
//  LiveViewController.swift
//  N3RVE
//
//  Created by Camilo Rossi on 2020-03-04.
//  Copyright © 2020 Camilo Rossi. All rights reserved.
//

import UIKit
import Firebase
import AssetsLibrary
import CoreLocation
import Photos

class LiveViewController: UIViewController, BambuserViewDelegate{
    var bambuserView : BambuserView
    var broadcastButton : UIButton
    var currentViewersLabel: UILabel
    var swapButton: UIButton
    var liveTitle = String()
    
    required init?(coder aDecoder: NSCoder) {
        bambuserView = BambuserView(preparePreset: kSessionPresetAuto)
    broadcastButton = UIButton(type: UIButton.ButtonType.system)
        currentViewersLabel = UILabel()
        swapButton = UIButton(type: UIButton.ButtonType.system)
    super.init(coder: aDecoder)
        bambuserView.delegate = self
        bambuserView.applicationId = "9RX2zwlVLQX9OtdgQ6aQnQ"
        currentViewersLabel.textAlignment = NSTextAlignment.left
        currentViewersLabel.text = ""
        currentViewersLabel.font = UIFont.systemFont(ofSize: 16)
        currentViewersLabel.backgroundColor = UIColor.clear
        currentViewersLabel.textColor = UIColor.blue
        
        swapButton.addTarget(bambuserView, action: #selector(BambuserView.swapCamera), for: UIControl.Event.touchUpInside)
        swapButton.setTitle("Swap", for: UIControl.State())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let docRef = Firestore.firestore().collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid ?? "")

        // Get data
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            } else if querySnapshot!.documents.count != 1 {
                print("More than one documents or none")
            } else {
                let document = querySnapshot!.documents.first
                let dataDescription = document?.data()
                guard let username = dataDescription?["username"] else { return }
                print(username)
                self.liveTitle = "\(username as! String)'s Live"
                print(self.liveTitle)
                self.bambuserView.broadcastTitle = "\(self.liveTitle)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bambuserView.orientation = (UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation)!
        self.view.addSubview(bambuserView.view)
        bambuserView.startCapture()
        broadcastButton.addTarget(self, action: #selector(LiveViewController.broadcast), for: UIControl.Event.touchUpInside)
        broadcastButton.setTitle("Broadcast", for: UIControl.State.normal)
        self.view.addSubview(broadcastButton)
        self.view.addSubview(bambuserView.chatView)
        self.view.addSubview(currentViewersLabel)
        if (bambuserView.hasFrontCamera) {
            self.view.addSubview(swapButton)
        }
        
        // Create URL
        let url = URL(string: "https://api.bambuser.com/broadcasts?order&titleContains=Live")
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        //Send HTTP Header Request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer RDFogjCLPa5u3CkdQAsb4P", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.bambuser.v1+json", forHTTPHeaderField: "Accept")
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            do {
            if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                           
            // Print out entire dictionary
            print(convertedJsonIntoDict)
            }
            } catch let error as NSError {
                       print(error.localizedDescription)
             }
        }
        task.resume()
    }
    
    
    func currentViewerCountUpdated(_ viewers: Int32) {
        currentViewersLabel.text = "Viewers: \(viewers)"
    }

    func totalViewerCountUpdated(_ viewers: Int32) {
        print("Total viewers: \(viewers)")
    }

    override func viewWillLayoutSubviews() {
        let statusBarOffset:CGFloat
        if #available(iOS 11.0, *) {
            statusBarOffset = self.view.safeAreaInsets.top
        } else {
            statusBarOffset = self.topLayoutGuide.length
        }
        currentViewersLabel.frame = CGRect(x: self.view.bounds.size.width - 100 , y: self.view.bounds.size.height - 30, width: 100, height: 30)
        bambuserView.previewFrame = CGRect(x: 0.0, y: 0.0 + statusBarOffset, width: self.view.bounds.size.width, height: self.view.bounds.size.height - statusBarOffset)
        broadcastButton.frame = CGRect(x: 0.0, y: 0.0 + statusBarOffset, width: 100.0, height: 50.0);
        bambuserView.chatView.frame = CGRect(x: 0.0, y: self.view.bounds.size.height-self.view.bounds.size.height/3.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height/3.0)
        if (bambuserView.hasFrontCamera) {
            swapButton.frame = CGRect(x: 0.0, y: 50.0 + statusBarOffset, width: 100.0, height: 50.0);
        }
    }
    
    func chatMessageReceived(_ message : String) {
        bambuserView.displayMessage(String(message))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func broadcast() {
        NSLog("Starting broadcast")
        broadcastButton.setTitle("Connecting", for: UIControl.State.normal)
        broadcastButton.removeTarget(nil, action: nil, for: UIControl.Event.touchUpInside)
        broadcastButton.addTarget(bambuserView, action: #selector(bambuserView.stopBroadcasting), for: UIControl.Event.touchUpInside)
        bambuserView.startBroadcasting()
    }

    func broadcastStarted() {
        NSLog("Received broadcastStarted signal")
        broadcastButton.setTitle("Stop", for: UIControl.State.normal)
        broadcastButton.removeTarget(nil, action: nil, for: UIControl.Event.touchUpInside)
        broadcastButton.addTarget(bambuserView, action: #selector(bambuserView.stopBroadcasting), for: UIControl.Event.touchUpInside)
    }

    func broadcastStopped() {
        NSLog("Received broadcastStopped signal")
        broadcastButton.setTitle("Broadcast", for: UIControl.State.normal)
        broadcastButton.removeTarget(nil, action: nil, for: UIControl.Event.touchUpInside)
        broadcastButton.addTarget(self, action: #selector(LiveViewController.broadcast), for: UIControl.Event.touchUpInside)
        self.currentViewersLabel.text = ""
    }
}
