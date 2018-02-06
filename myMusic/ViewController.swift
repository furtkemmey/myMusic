//
//  ViewController.swift
//  myMusic
//
//  Created by KaiChieh on 06/02/2018.
//  Copyright © 2018 KaiChieh. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!

    // MARK: - IBOutlet
    @IBOutlet weak var playNPause: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playTimeInfo: UILabel!
    @IBOutlet weak var playLeftTimeInfo: UILabel!
    
    // MARK: - IBAction
    @IBAction func playNPauseAction(_ sender: UIButton) {
    }

    @IBAction func stopPlay(_ sender: UIButton) {
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //create a notification
        let notificationCenterDefault = NotificationCenter.default
        // add observer
        notificationCenterDefault.addObserver(self, selector: #selector(audioInterrupted(_:)), name: .AVAudioSessionInterruption, object: nil)
    }

    // add "@objc" by "#selector"
    @objc func audioInterrupted(_ notification: Notification) {


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

