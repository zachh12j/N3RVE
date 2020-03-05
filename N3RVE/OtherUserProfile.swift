//
//  OtherUserProfile.swift
//  N3RVE
//
//  Created by Camilo Rossi on 2020-03-04.
//  Copyright © 2020 Camilo Rossi. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class OtherUserProfile: UIViewController {

    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    var player: AVPlayer?
    var peopleFollowing = 0
    var hasTappedOnFollow = Bool()
    var getsFollowedUid = String()
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(OtherUserProfile.finishBackgroundVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.setLeftPaddingPoints(20)
        searchField.setRightPaddingPoints(20)
        self.hideKeyboardWhenTappedAround()
        hasTappedOnFollow = false
        print("had tapped on follow 0")
        
        //        LOAD VIDEO
        
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
        player?.play()
    }
    
    @IBAction func searchForUser(_ sender: Any) {
        let searchRef = Firestore.firestore().collection("users").whereField("username", isEqualTo: searchField.text ?? nil!)
        
        // Get data
        searchRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            } else if querySnapshot!.documents.count != 1 {
                print("More than one documents or none")
            } else {
                for document in querySnapshot!.documents {

                    let docId = document.documentID
                   let username = document.get("username") as! String
                   let firstAndLastName = document.get("firstandlastname") as! String
                    let pplFollowing = document.get("currentFollowers") as! Int
                    self.followersLabel.text = "\(pplFollowing)"
                    self.nameLabel.text = "\(firstAndLastName)"
                    self.usernameLabel.text = "@\(username)"
                    self.peopleFollowing = pplFollowing
                    self.getsFollowedUid = docId
                }
           }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        performSegue(withIdentifier: "searchUserToUser", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func finishBackgroundVideo(notification: NSNotification)
    {
            if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
    @IBAction func followUser(_ sender: Any) {
        if hasTappedOnFollow == false{
            hasTappedOnFollow = true
        print(self.getsFollowedUid)
        let db = Firestore.firestore()
            self.followersLabel.text = "\(peopleFollowing+1)"

            if let userId = Auth.auth().currentUser?.uid {db.collection("users").document(userId).collection("currentFollowers").addSnapshotListener { (snapshot, error ) in
                
                let docsRef = db.collection("users").document(self.getsFollowedUid)
                // Set the "capital" field of the city 'DC'
                docsRef.updateData([
                    "currentFollowers": self.peopleFollowing+1
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            }
        }
        }
        if hasTappedOnFollow == true{
            print("t'as déjà tappé gros")
        }
    }
}
