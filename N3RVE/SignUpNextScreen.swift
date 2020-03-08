//
//  LoginScreen.swift
//  Aeris
//
//  Created by Camilo Rossi on 2018-10-13.
//  Copyright © 2018 Camilo Rossi. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth
import Firebase
import Microblink

class SingUpNextScreen: UIViewController{
    
    var blinkIdRecognizer : MBBlinkIdRecognizer?
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        MBMicroblinkSDK.sharedInstance().setLicenseResource("MB_com.justynramirez.N3RVE_BlinkID_iOS_2020-04-06", withExtension: "mblic", inSubdirectory: "", for: Bundle.main)
        signUpButton.isHidden = true
    }
    
    //END VIEWDIDLOAD

    @IBAction func scanID(_ sender: Any)
    {
        //Show the signUpButton
        self.signUpButton.isHidden = false
        
        /** Create BlinkID recognizer */
        self.blinkIdRecognizer = MBBlinkIdRecognizer()
        self.blinkIdRecognizer?.returnFullDocumentImage = true;
        
        /** Create settings */
        let settings : MBBlinkIdOverlaySettings = MBBlinkIdOverlaySettings()
        
        /** Crate recognizer collection */
        let recognizerList = [self.blinkIdRecognizer!]
        let recognizerCollection : MBRecognizerCollection = MBRecognizerCollection(recognizers: recognizerList)
        
        /** Create your overlay view controller */
        let blinkIdOverlayViewController : MBBlinkIdOverlayViewController = MBBlinkIdOverlayViewController(settings: settings, recognizerCollection: recognizerCollection, delegate: self)
        
        /** Create recognizer view controller with wanted overlay view controller */
        let recognizerRunneViewController : UIViewController = MBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: blinkIdOverlayViewController)
        
        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        self.present(recognizerRunneViewController, animated: true, completion: nil)
    }
    
    @IBAction func backToHome(_ sender: Any)
    {
        performSegue(withIdentifier: "returnBackSignUp", sender: self)
    }
    @IBAction func signUpIsCompleted(_ sender: Any) {
        performSegue(withIdentifier: "signUp", sender: self)
    }
    
}

extension SingUpNextScreen: MBBlinkIdOverlayViewControllerDelegate
{
    
    func blinkIdOverlayViewControllerDidFinishScanning(_ blinkIdOverlayViewController: MBBlinkIdOverlayViewController, state: MBRecognizerResultState) {
        /** This is done on background thread */
        blinkIdOverlayViewController.recognizerRunnerViewController?.pauseScanning()
        
        var message: String = ""
        var title: String = ""
        
        if (self.blinkIdRecognizer?.result.resultState == MBRecognizerResultState.uncertain) {
            title = "BlinkID"
            
            let fullDocumentImage: UIImage! = self.blinkIdRecognizer?.result.fullDocumentImage?.image
            print("Got BlinkID image with width: \(fullDocumentImage.size.width), height: \(fullDocumentImage.size.height)")
            
            // Save the string representation of the code
            message = self.blinkIdRecognizer!.result.description
            
            /** Needs to be called on main thread beacuse everything prior is on background thread */
            DispatchQueue.main.async {
                
                print(title)
                print(message)
                // present the alert view with scanned results
                
                let alertController: UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                
                let okAction: UIAlertAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default,
                                                                 handler: { (action) -> Void in
                                                                    self.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(okAction)
                blinkIdOverlayViewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func blinkIdOverlayViewControllerDidTapClose(_ blinkIdOverlayViewController: MBBlinkIdOverlayViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
