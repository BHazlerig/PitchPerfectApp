//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Ben Hazlerig on 7/18/15.
//  Copyright (c) 2015 Benjamin Allen. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
  
  var audioPlayer: AVAudioPlayer!
  var receivedAudio: RecordedAudio!
  
  var audioEngine: AVAudioEngine!
  var audioFile: AVAudioFile!
  
  var overrideError : NSError?
  
  @IBOutlet weak var stopButton: UIButton!
  
  
  @IBAction func playSlow(sender: UIButton) {
    stopButton.enabled = true
    audioPlayer.stop()
    audioPlayer.rate = 0.5
    audioPlayer.play()
  }
  
  @IBAction func playFast(sender: UIButton) {
    stopButton.enabled = true
    audioPlayer.stop()
    audioPlayer.rate = 1.5
    audioPlayer.play()
  }
  
  
  @IBAction func stopPlay(sender: UIButton) {
    audioPlayer.stop()
    stopButton.enabled = false
  }
  
  @IBAction func playChipmunk(sender: AnyObject) {
    playAudioWithVariablePitch(1000)
  }
  
  @IBAction func playDarth(sender: AnyObject) {
    playAudioWithVariablePitch(-1000)
  }

    override func viewDidLoad() {
      super.viewDidLoad()
//      if var path =  NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
//         var pathURL = NSURL(fileURLWithPath: path)
//      } else {
//        println("The filepath is missing")
//      }
      
      audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
      audioPlayer.enableRate = true
      
      audioEngine = AVAudioEngine()
      audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
  func playAudioWithVariablePitch(pitch: Float){
    audioPlayer.stop()
    audioEngine.stop()
    audioEngine.reset()
    
    var audioPlayerNode = AVAudioPlayerNode()
    audioEngine.attachNode(audioPlayerNode)
    
    var changePitchEffect = AVAudioUnitTimePitch()
    changePitchEffect.pitch = pitch
    audioEngine.attachNode(changePitchEffect)
    
    audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
    audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
    
    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    audioEngine.startAndReturnError(nil)
    
    audioPlayerNode.play()
    stopButton.enabled = true
    
  }
  

}
