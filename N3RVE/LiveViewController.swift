//
//  LiveViewController.swift
//  N3RVE
//
//  Created by Camilo Rossi on 2020-03-04.
//  Copyright © 2020 Camilo Rossi. All rights reserved.
//

import UIKit

class LiveViewController: UIViewController, BambuserViewDelegate {
    var bambuserView : BambuserView
    var broadcastButton : UIButton
    required init?(coder aDecoder: NSCoder) {
        bambuserView = BambuserView(preparePreset: kSessionPresetAuto)
    broadcastButton = UIButton(type: UIButton.ButtonType.system)
    super.init(coder: aDecoder)
        bambuserView.delegate = self
        bambuserView.applicationId = "9RX2zwlVLQX9OtdgQ6aQnQ"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bambuserView.orientation = UIApplication.shared.statusBarOrientation
        self.view.addSubview(bambuserView.view)
        bambuserView.startCapture()

        broadcastButton.addTarget(self, action: #selector(LiveViewController.broadcast), for: UIControl.Event.touchUpInside)
        broadcastButton.setTitle("Broadcast", for: UIControl.State.normal)
        self.view.addSubview(broadcastButton)
    }

    override func viewWillLayoutSubviews() {
        var statusBarOffset : CGFloat = 0.0
        statusBarOffset = CGFloat(self.topLayoutGuide.length)
        bambuserView.previewFrame = CGRect(x: 0.0, y: 0.0 + statusBarOffset, width: self.view.bounds.size.width, height: self.view.bounds.size.height - statusBarOffset)
        broadcastButton.frame = CGRect(x: 0.0, y: 0.0 + statusBarOffset, width: 100.0, height: 50.0);
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
    }
}
