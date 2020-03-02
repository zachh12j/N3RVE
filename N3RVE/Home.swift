//
//  ViewController.swift
//  Aeris
//
//  Created by Camilo Rossi on 2018-10-13.
//  Copyright © 2018 Camilo Rossi. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth
import FirebaseAnalytics
import Firebase

class Home: UIViewController {
    
    var player: AVAudioPlayer?
    var AudioPlayer = AVAudioPlayer()
    var MusicPLaying = false
    @IBOutlet weak var usernameLabel: UILabel!
    
    var getCurrentUserData: CollectionReference!
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    @IBOutlet weak var instagramButton: UIButton!
    
        let selection = UISelectionFeedbackGenerator()
    
    @IBAction func fromHomeToCategories(_ sender: Any) {
        self.performSegue(withIdentifier: "fromHomeToCategory1", sender: self)
        selection.selectionChanged()
        buttonClickSound()
    }
    @IBAction func fromHomeToSettings(_ sender: Any) {
        self.performSegue(withIdentifier: "fromHomeToSettings", sender: self)
        selection.selectionChanged()
        buttonClickSound()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let theURL = Bundle.main.url(forResource: "GlitchBackground", withExtension: "mp4")

        avPlayer = AVPlayer(url: theURL!)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none

        avPlayerLayer.frame = view.layer.bounds
        view.backgroundColor = UIColor.clear;
        view.layer.insertSublayer(avPlayerLayer, at: 0)

        NotificationCenter.default.addObserver(self,
                                               selector: Selector(("playerItemDidReachEnd:")),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: avPlayer.currentItem)
        
        getCurrentUserData = Firestore.firestore().collection("users")
        getDocument()
    }
    
    private func getDocument() {
         //Get sspecific document from current user
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
                self.usernameLabel.text = "@\(username)"
             }
         }
     }
    
    override func viewWillAppear(_ animated: Bool) {
        
        /*
        getCurrentUserData.getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("Error Fetching Docs: \(err)")
            } else {
                guard let snap = snapshot else { return }
                for document in snap.documents {
                    let data = document.data()
                    let username = data["username"] as? String ?? "ANONYMOUS"
                    
                    self.usernameLabel.text = "@\(username)"
                }
            }
        }
        */
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.play()
        paused = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.pause()
        paused = true
    }
    
    @IBAction func didTapInsta(_ sender: Any) {
        if let url = URL(string: "http://instagram.com/n3rve_app/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    @IBAction func didTapFacebook(_ sender: Any) {
        if let url = URL(string: "https://vm.tiktok.com/bKPSun/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    @IBAction func didTapSnapchat(_ sender: Any) {
        if let url = URL(string: "http://facebook.com/camilo.jrossi") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    
    let url = Bundle.main.url(forResource: "BackgroundMusic", withExtension: "mp3")!
    
    

    func buttonClickSound() {
        let url = Bundle.main.url(forResource: "ButtonClick2", withExtension: "wav")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func Logout(_ sender: Any) {
    
        do {
               try Auth.auth().signOut()
           }
        catch let signOutError as NSError {
               print ("Error signing out: %@", signOutError)
           }
            
        performSegue(withIdentifier: "fromHomeToHomePage", sender: self)
           /*
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let initial = storyboard.instantiateInitialViewController()
           UIApplication.shared.keyWindow?.rootViewController = initial
            */
    }

}

