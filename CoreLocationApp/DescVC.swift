//
//  DescVC.swift
//  CoreLocationApp
//
//  Created by Neil Sood on 9/13/18.
//  Copyright © 2018 Neil Sood. All rights reserved.
//

import UIKit
import WebKit

class DescVC: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var youtubeWebView: WKWebView!
    
    var exercises: [[String:String]] = [
        ["title": "10 Push Ups", "code": "hLbjdCJ5-2w"],
        ["title": "50 Jumping Jacks", "code": "sYxABbY6Qv4"],
        ["title": "30 Crunches", "code": "RtDWzg9ESRA"],
        ["title": "100 High Knees", "code": "AO6s9OzFesM"],
        ["title": "20 Squats", "code": "3uTbBb1hkpc"],
        ["title": "10 Burpees", "code": "RLTxXfh7w4c"],
        ["title": "50 Climbers", "code": "u_jJpx6d40s"],
        ["title": "10 Jumps", "code": "ggqcxKApjns"],
        ["title": "20 Lunge Walks", "code": "4ieLCqyA9Ig"],
        ["title": "10 Standups", "code": "eLnSyVyuNn0"],
        ["title": "20 Straight Leg Levers", "code": "7CvLXNVAgV4"],
        ["title": "Mountain Climbers", "code": "47I93-cx3Qo"],
        ["title": "20 Froggers", "code": "nddYuZP-kSo"],
        ["title": "10 Pikes", "code": "AV3lyLHWf2E"],
        ["title": "10 Sprawls", "code": "BnvnlqahscU"],
        ["title": "10 Pistols", "code": "2qcuviSULO8"],
        ["title": "20 Split Lunges", "code": "QAo5UbUj3vU"],
        ["title": "10 Standup Jumps", "code": "PY5l4wswlig"],
    ]
    
//    var all_exercises = [[String:String]]()
    
    
    var rand_num: Int?
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadVideo()
    }
    
    func loadVideo() {
        rand_num = Int(arc4random_uniform(UInt32(exercises.count)))
        videoLabel.text = exercises[rand_num!]["title"]
        getVideo(exercises[rand_num!]["code"]!)
        exercises.remove(at: rand_num!)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        
        if count < 2 {
            count += 1
            loadVideo()
        }
        else {
            if count == 2 {
                nextButton.backgroundColor = .green
                nextButton.setTitle("Well done my dear", for: .normal)
                count += 1
            }
            else {
    //            count = 0
    //            exercises = all_exercises
                dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    func getVideo(_ videoCode: String) {
        let url = URL(string: "https://www.youtube.com/embed/\(videoCode)")
        youtubeWebView.load(URLRequest(url: (url)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
