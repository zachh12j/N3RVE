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
    
    var playerSound: AVAudioPlayer?
    var AudioPlayer = AVAudioPlayer()
    var MusicPLaying = false
    var getCurrentUserData: CollectionReference!
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    var player: AVPlayer?
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    let selection = UISelectionFeedbackGenerator()
    
    @IBAction func goWatch(_ sender: Any) {
        self.performSegue(withIdentifier: "goWatch", sender: self)
        selection.selectionChanged()
        buttonClickSound()
    }

    @IBAction func goLive(_ sender: Any) {
        self.performSegue(withIdentifier: "goLive", sender: self)
        selection.selectionChanged()
        buttonClickSound()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(Home.finishBackgroundVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Load the video from the app bundle.
        let videoURL: NSURL = Bundle.main.url(forResource: "BackgroundVid", withExtension: "mp4")! as NSURL
        
        player = AVPlayer(url: videoURL as URL)
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1

        playerLayer.frame = view.frame

        view.layer.addSublayer(playerLayer)

        //player?.play()
        getCurrentUserData = Firestore.firestore().collection("users")
        getDocument()
    }

    
        func getDocument() {
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
    
    //let url = Bundle.main.url(forResource: "BackgroundMusic", withExtension: "mp3")!

    func buttonClickSound() {
        let url = Bundle.main.url(forResource: "ButtonClick", withExtension: "wav")!
        
        do {
            playerSound = try AVAudioPlayer(contentsOf: url)
            guard player != nil else { return }
            
            playerSound?.prepareToPlay()
            playerSound?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        do {
               try Auth.auth().signOut()
           }
        catch let signOutError as NSError {
               print ("Error signing out: %@", signOutError)
           }
        performSegue(withIdentifier: "fromHomeToHomePage", sender: self)
    }
    
    
    @objc func finishBackgroundVideo(notification: NSNotification)
    {
            if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    @IBAction func editProfile(_ sender: Any) {
        performSegue(withIdentifier: "fromHomeToUserProfile", sender: self)
    }
}

