//
//  GameScreenViewController.swift
//  MDB Member Match
//
//  Created by Geovanni Morales on 2/6/20.
//  Copyright © 2020 Geovanni Morales. All rights reserved.
//

import UIKit


class GameScreenView: UIViewController {
    
    var correctMember: String!
    var correctMemberButton: Int! //This variable holds which button has the correct number
    var buttons: [UIButton]!  //Array holds the buttons to make certain code less redundant below
    var prevMembers: [String]! //These two arrays are for statistics recording
    var prevResults: [String]!
    var userScore: Int!
    var LongestStreak: Int!
    var CurrentStreak: Int!
    
    var seconds = 5
    var timer = Timer()
    var oneSecondTimer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    var resumeTapped = false //To indicate whether the pause button has been tapped
    var inDelay = false
    
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var PauseButton: UIButton!
    
    @IBOutlet weak var MemberImage: UIImageView!
    @IBOutlet weak var ButtonOne: UIButton!
    @IBOutlet weak var ButtonTwo: UIButton!
    @IBOutlet weak var ButtonThree: UIButton!
    @IBOutlet weak var ButtonFour: UIButton!
    
    
    @IBAction func buttonOnePressed(_ sender: Any) {
        buttonPressed(buttonNumber: 0)
    }
    @IBAction func buttonTwoPressed(_ sender: Any) {
        buttonPressed(buttonNumber: 1)
    }
    @IBAction func buttonThreePressed(_ sender: Any) {
        buttonPressed(buttonNumber: 2)
    }
    @IBAction func buttonFourPressed(_ sender: Any) {
        buttonPressed(buttonNumber: 3)
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        if self.resumeTapped == false {
             PauseButton.setTitle("Resume", for: .normal)
             timer.invalidate()
             self.resumeTapped = true
        } else {
             PauseButton.setTitle("Pause", for: .normal)
             userScore = 0
             ScoreLabel.text = String(userScore)
             newQuestion()
             self.resumeTapped = false
        }
    }
    
    @IBAction func statisticsPressed(_ sender: Any) {
        if (CurrentStreak! > LongestStreak) {
            LongestStreak = CurrentStreak
        }
        if (inDelay == false) {
            self.performSegue(withIdentifier: "GStoSC", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ButtonOne.layer.cornerRadius = 5
        ButtonTwo.layer.cornerRadius = 5
        ButtonThree.layer.cornerRadius = 5
        ButtonFour.layer.cornerRadius = 5
        
        userScore = 0
        ScoreLabel.text = String(userScore)
        prevMembers = ["placeholder", "placeholder", "placeholder"]
        prevResults = ["placeholder", "placeholder", "placeholder"]
        LongestStreak = 0
        CurrentStreak = 0
        buttons = [ButtonOne,ButtonTwo,ButtonThree,ButtonFour]
        newQuestion()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //Purpose is to ensure that timer stops when the screen is left
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        stopTimer()
        
    }
    
    //Starts the process of a new question appearing in the game
    func newQuestion() {
        // This is setup code that resets the buttons from their previous state
        ButtonOne.backgroundColor = UIColor.white
        ButtonTwo.backgroundColor = UIColor.white
        ButtonThree.backgroundColor = UIColor.white
        ButtonFour.backgroundColor = UIColor.white
        
        //Choosing the correct member
        let members = selectMembers()
        correctMemberButton = Int.random(in: 0 ... 3)
        correctMember = members[correctMemberButton]
        let correctMemberImage = Constants.getImageFor(name: correctMember)
        
        //Assigning the buttons and images to the proper people
        ButtonOne.setTitle(members[0], for: .normal)
        ButtonTwo.setTitle(members[1], for: .normal)
        ButtonThree.setTitle(members[2], for: .normal)
        ButtonFour.setTitle(members[3], for: .normal)
        MemberImage.image = correctMemberImage
        
        //Starts the timer for the question
        seconds = 5
        TimerLabel.text = String(seconds)
        runTimer()
        
    }
    
    //Choose 4 members and pops from list as appropriate to ensure no repeats
    func selectMembers() -> [String]{
        //We pool names from the Constants class randomly
        var namePool = Constants.names
        var  membersShown: [String] = []  //To be filled with member names
        for _ in 1...4 {
            let namePoolLength = namePool.count
            let randomInterger = Int.random(in: 0 ..< namePoolLength)
            membersShown.append(namePool[randomInterger])
            namePool.remove(at: randomInterger)
        }
        return membersShown
    }

    func updateStatistics(outcome: String) {
        prevMembers.append(correctMember)
        prevResults.append(outcome)
        
        if (prevMembers.count > 3) {
            prevMembers.removeFirst()
        }
    
        if (prevResults.count > 3) {
            prevResults.removeFirst()
        }
    }
    
    // When a button is pressed, the rightAnswer() or worngAnswer() function is ran
    // followed by the questionAnswered() which will then start a new question
    func buttonPressed(buttonNumber: Int) {
        
        if (resumeTapped == false) {
            var outcome : String!
            if (buttonNumber == correctMemberButton) {
                outcome = rightAnswer(buttonNumber: buttonNumber)
            } else {
                outcome = wrongAnswer(buttonNumber: buttonNumber)
            }
            questionAnswered(outcome: outcome)
        }
    }
    
    func rightAnswer(buttonNumber: Int) -> String {
        buttons[buttonNumber].backgroundColor = UIColor.green
        userScore += 1
        CurrentStreak += 1
        let outcome = "Correct"
        return outcome
    }
    
    func wrongAnswer(buttonNumber: Int = -1) -> String {
        
        if (buttonNumber != -1) {
            buttons[buttonNumber].backgroundColor = UIColor.red
            buttons[correctMemberButton].backgroundColor = UIColor.green
        } else {
            //Technically, one button is being changed twice but it makes the code much cleaner
            //and shouldn't even pose a visual problem
            buttons[0].backgroundColor = UIColor.red
            buttons[1].backgroundColor = UIColor.red
            buttons[2].backgroundColor = UIColor.red
            buttons[3].backgroundColor = UIColor.red
            buttons[correctMemberButton].backgroundColor = UIColor.green
        }
        CurrentStreak = 0
        let outcome = "Incorrect"
        return outcome
    }
    
    func questionAnswered(outcome: String) {
        ScoreLabel.text = String(userScore)
        updateStatistics(outcome: outcome)
        
        stopTimer()
        self.view.isUserInteractionEnabled = false
        inDelay = true
        //This delayed function serves as the delay from when a question is asnswered
        //to before it resets
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.inDelay = false
           self.view.isUserInteractionEnabled = true
           self.newQuestion()
        }
    }
    
    @objc func updateTimer() {
        //This will decrement(count down)the seconds.
        seconds -= 1
        TimerLabel.text = String(seconds) //This will update the label.
        
        if (seconds < 0) {
            TimerLabel.text = String(0)
            let outcome = wrongAnswer(buttonNumber: -1)
            questionAnswered(outcome: outcome)
        }
    }
    
    //both functions below are simple but makes code much easier to read
    func runTimer() {
         timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(GameScreenView.updateTimer)), userInfo: nil, repeats: true)
    }
    
    //function is simple but makes code much easier to read
    func stopTimer() {
         timer.invalidate()
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "GStoSC"){
            let StatisticsScreen = segue.destination as! StatisticsScreen
            StatisticsScreen.LongestStreak = LongestStreak
            StatisticsScreen.prevMembers = prevMembers
            StatisticsScreen.prevResults = prevResults
            
        }

        
    }
    

}
