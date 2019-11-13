//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Robert Busby on 11/7/19.
//  Copyright © 2019 AT&T CSO SOS Development. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    // MARK: Properties
    
    var recordedAudioURL: URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!

    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }

    // MARK: Outlets
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!

    // MARK: Actions

    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch (ButtonType( rawValue: sender.tag)!) {
            case .slow:
                   playSound(rate: 0.5)
            case .fast:
                   playSound(rate: 1.5)
            case .chipmunk:
                   playSound(pitch: 1000)
            case .vader:
                   playSound(pitch: -1000)
            case .echo:
                   playSound(echo: true)
            case .reverb:
                   playSound(reverb: true)
        }
        
        configureUI( .playing )
    }

    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        stopAudio()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop the playback, if started and not complete yet
        stopAudio()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI( .notPlaying )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        snailButton.imageView?.contentMode = .scaleAspectFit
        chipmunkButton.imageView?.contentMode = .scaleAspectFit
        rabbitButton.imageView?.contentMode = .scaleAspectFit
        vaderButton.imageView?.contentMode = .scaleAspectFit
        echoButton.imageView?.contentMode = .scaleAspectFit
        reverbButton.imageView?.contentMode = .scaleAspectFit
        stopButton.imageView?.contentMode = .scaleAspectFit
        setupAudio()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
