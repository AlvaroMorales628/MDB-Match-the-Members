//
//  StatisticsScreen.swift
//  MDB Member Match
//
//  Created by Geovanni Morales on 2/6/20.
//  Copyright © 2020 Geovanni Morales. All rights reserved.
//

import UIKit

class StatisticsScreen: UIViewController {
    
    var LongestStreak: Int!
    var prevMembers: [String]!
    var prevResults: [String]!
    var images: [UIImageView]!
    var imageLabels: [UILabel]!
    
    @IBOutlet weak var Image3: UIImageView!
    @IBOutlet weak var Image2: UIImageView!
    @IBOutlet weak var Image1: UIImageView!
    
    @IBOutlet weak var Image3Label: UILabel!
    @IBOutlet weak var Image2Label: UILabel!
    @IBOutlet weak var Image1Label: UILabel!
    
    @IBOutlet weak var LongestStreakLabel: UILabel!
    
    override func viewDidLoad() {
        images = [Image1,Image2, Image3]
        imageLabels = [Image1Label,Image2Label, Image3Label]
        super.viewDidLoad()
        //print(LongestStreak)
        LongestStreakLabel.text = "Longest Streak: " + String(LongestStreak)
        
        
        statisticsElementUpdater(ndx: 2)
        statisticsElementUpdater(ndx: 1)
        statisticsElementUpdater(ndx: 0)
        // Do any additional setup after loading the view.
    }
    
    func statisticsElementUpdater(ndx: Int) {
        
        if (prevMembers[ndx] == "placeholder") {
            images[ndx].image = nil
            imageLabels[ndx].text = ""
        }
        else {
            images[ndx].image = Constants.getImageFor(name: prevMembers[ndx])
            imageLabels[ndx].text = prevResults[ndx] + " " + prevMembers[ndx]
        }
        
        imageLabels[ndx].textColor = (prevResults[ndx] == "Correct") ? UIColor.green:UIColor.red
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
