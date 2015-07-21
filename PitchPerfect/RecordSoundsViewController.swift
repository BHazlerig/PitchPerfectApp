//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Ben Hazlerig on 7/18/15.
//  Copyright (c) 2015 Benjamin Allen. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
  
  var audioRecorder: AVAudioRecorder!
  var recordedAudio: RecordedAudio!
  

  @IBOutlet weak var startRecordLabel: UILabel!
  @IBOutlet weak var stopButton: UIButton!
  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var activityIndicator: CustomActivityIndicator!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()    
  }
  


  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(animated: Bool) {
    stopButton.hidden = true
    startRecordLabel.hidden = false
    recordButton.enabled = true
  }

  @IBAction func recordAudio(sender: UIButton) {
    startRecordLabel.hidden = true
    stopButton.hidden = false
    recordButton.enabled = false
    activityIndicator.stopAnimating()
    activityIndicator.color = UIColor.whiteColor()
    activityIndicator.startAnimating()
    
    //Inside func recordAudio(sender: UIButton)
    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
    
    let recordingName = "my_audio.wav"
    let pathArray = [dirPath, recordingName]
    let filePath = NSURL.fileURLWithPathComponents(pathArray)
    println(filePath)
    
    var session = AVAudioSession.sharedInstance()
    session.setCategory(AVAudioSessionCategoryRecord, error: nil)
    
    audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
    audioRecorder.delegate = self
    audioRecorder.meteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.record()
    
  }
  
  func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
    var session = AVAudioSession.sharedInstance()
    session.setCategory(AVAudioSessionCategoryPlayback, error: nil)    
    if(flag) {
    recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
    self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
    } else {
      println("Recording was not successful")
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if ( segue.identifier == "stopRecording" ) {
      let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
      let data = sender as! RecordedAudio
      playSoundsVC.receivedAudio = data      
    }
    
  }
  
  @IBAction func stopRecordingAudio(sender: UIButton) {
    audioRecorder.stop()
    activityIndicator.hidden = true
    var audioSession = AVAudioSession.sharedInstance()
    audioSession.setActive(false, error: nil)
  }
}

