//
//  ViewController.swift
//  myMusic
//
//  Created by KaiChieh on 06/02/2018.
//  Copyright © 2018 KaiChieh. All rights reserved.
//

import UIKit
import MediaPlayer
//import AVFoundation
class ViewController: UIViewController, AVAudioPlayerDelegate {

    var audioPlayer: AVAudioPlayer!
    var touch: String?

    // MARK: - IBOutlet
    @IBOutlet weak var playNPause: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playTimeInfo: UILabel!
    @IBOutlet weak var playLeftTimeInfo: UILabel!
    var timer: Timer!
    
    // MARK: - IBAction
    @IBAction func playNPauseAction(_ sender: UIButton) {
        if audioPlayer != nil && !audioPlayer.isPlaying {//not in playing
            audioPlayer.play()
            sender.setImage(UIImage(named: "pause.png"), for: .normal)//show playing picture
            //set slider.value by Timer
            if timer != nil {
                timer.invalidate()
                timer = nil
            }
            if timer == nil {
                timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer) in
                    self.slider.value = Float(self.audioPlayer.currentTime)
                    self.countPlayTime()
//                    print("running timer")
                })
            }
        } else {
            audioPlayer.pause()
            sender.setImage(UIImage(named: "play.png") , for: .normal)
        }
    }

    @IBAction func stopPlay(_ sender: UIButton) {
        if audioPlayer != nil {
            audioPlayer.stop()
            audioPlayer.currentTime = 0
            playNPause.setImage(UIImage(named: "play.png") , for: .normal)
        }
        if timer != nil {
            timer.invalidate() //stop timer
            slider.value = 0
            countPlayTime()
            timer = nil
        }
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
//        print("value has been changed= \(slider.value)")
        if audioPlayer != nil {
            audioPlayer.currentTime = TimeInterval(slider.value)
            countPlayTime()
        }
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //create a notification
        let notificationCenterDefault = NotificationCenter.default
        // add observer
        notificationCenterDefault.addObserver(self, selector: #selector(audioInterrupted(_:)), name: .AVAudioSessionInterruption, object: nil)

        //Set file path
        let filePath = Bundle.main.path(forResource: "music", ofType: "mp3")
//        print("filePath= \(String(describing: filePath))")
        let fileData = NSData(contentsOfFile: filePath!) //convert to DataType

        //Audio Session for background playing
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print("setCategory error= \(error.localizedDescription)")
            return
        }

        // AVAudio Player
        do {
            audioPlayer =  try AVAudioPlayer(data: fileData! as Data)
        } catch {
            print("AVAudioPlayer error= \(error.localizedDescription)")
        }
        audioPlayer.delegate = self
        //prepare to play
        audioPlayer.prepareToPlay()
        //set slider maxi and mini value
        slider.minimumValue = 0
        slider.maximumValue = Float(audioPlayer.duration)
        slider.value = 0
    }//end viewDidLoad()

    // add "@objc" by "#selector" addObserver()
    // only run on real phone
    @objc func audioInterrupted(_ notification: Notification) {
        print("message \(String(describing: notification.userInfo))")
        if let infoInterruption = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt {
            if let type = AVAudioSessionInterruptionType(rawValue: infoInterruption) {//Initializing from a Raw Value
                switch type {
                case .ended:
                    print("resume-play form interruption")
                    audioPlayer.play()
                case .began:
                    print("interruption")
                    audioPlayer.pause()
                }
            }
        }
    }


    // MARK:- Privat func
    var playTimeMM: Int {
        return (Int(slider.value) / 60)
    }
    var playTimess: Int {
        return (Int(slider.value) % 60)
    }
    var playLeftMM: Int {
        return (Int(audioPlayer.duration)-Int(slider.value))/60
    }
    var playLeftss: Int {
        return (Int(audioPlayer.duration)-Int(slider.value))%60
    }
    private func countPlayTime() {
        playTimeInfo.text = String(format: "%02i:%02i", playTimeMM, playTimess)
        playLeftTimeInfo.text = String(format: "%02i:%02i", playLeftMM, playLeftss )

    }

    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("audioPlayerDidFinishPlaying")
        player.currentTime = 0
        slider.value = 0
        if timer != nil {
            timer.invalidate()
        }
        playNPause.setImage(UIImage(named: "play.png") , for: .normal)
        countPlayTime()
    }
}

