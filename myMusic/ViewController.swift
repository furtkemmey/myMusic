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
        audioPlayer.play()
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

        let filePath = Bundle.main.path(forResource: "music", ofType: "mp3")
        print("filePath= \(String(describing: filePath))")
        let fileData = NSData(contentsOfFile: filePath!) //convert to DataType

        //Audio Session
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .allowAirPlay) //get instance
        } catch {
            print("setCategory error= \(error.localizedDescription)")
        }

        // AVAudio Player
        do {
            audioPlayer =  try AVAudioPlayer(data: fileData! as Data)
        } catch {
            print("AVAudioPlayer error= \(error.localizedDescription)")
        }
        audioPlayer.prepareToPlay()
    }

    // add "@objc" by "#selector"
    @objc func audioInterrupted(_ notification: Notification) {
        print("message \(String(describing: notification.userInfo))")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

