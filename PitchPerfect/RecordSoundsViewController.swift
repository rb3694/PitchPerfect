//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Robert Busby on 11/6/19.
//  Copyright © 2019 AT&T CSO SOS Development. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        recordButton.imageView?.contentMode = .scaleAspectFit
        stopRecordingButton.imageView?.contentMode = .scaleAspectFit
        stopRecordingButton.isEnabled = false
    }
    
    func configureUI( isRecording: Bool ) {
        // Convenience function to set UI buttons/;abels in initial view to correct state:
        if ( isRecording ) {
            recordingLabel.text = "Recording in Progress"
        } else {
            recordingLabel.text = "Tap to Record"
        }
        stopRecordingButton.isEnabled = isRecording
        recordButton.isEnabled = !isRecording

    }
    
    @IBAction func recordAudio(_ sender: Any) {
        configureUI( isRecording: true )
        
        // Get a file to store the recorded sound
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        //--------------------------------------------------------------------
        // Uncomment the next few lines to see the file name on the console
        //if let stringFromUrl = filePath?.absoluteString
        //{
        //  print( stringFromUrl )
        //}
        //else
        //{
        //    print( "URL is nil" )
        //}
        //--------------------------------------------------------------------

        // Get access to microphone and start recording
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI( isRecording: false )

        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive( false )
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        // When the recording finishes, segue to the secondary view for playback
        if flag {
            performSegue( withIdentifier: "stopRecording", sender: audioRecorder.url )
        } else {
            let alert = UIAlertController(title: "Recording failed", message: "Recording finished unsuccessfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Recording Failed", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}
