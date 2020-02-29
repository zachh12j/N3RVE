//
//  Category4.swift
//  Aeris
//
//  Created by Camilo Rossi on 2018-10-13.
//  Copyright © 2018 Camilo Rossi. All rights reserved.
//

import UIKit
import AVFoundation

class Category4: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var lblQuestion: UILabel!
    @IBOutlet var answer0: UIButton!
    @IBOutlet var answer1: UIButton!
    @IBOutlet var answer2: UIButton!
    @IBOutlet var answer3: UIButton!
    @IBOutlet var lblProgress: UILabel!
    @IBOutlet var displayAnswer: UILabel!
    @IBOutlet var displayNextQuestion: UIButton!
    
    struct Question {
        let question: String
        let answers: [String]
        let correctAnswer: Int
    }
    var player: AVAudioPlayer?
    
    var questions: [Question] = [
        Question(
            question: "What is 1+1?",
            answers: ["1", "2", "3", "4"],
            correctAnswer: 1),
        Question(
            question: "What is 3 x 3?",
            answers: ["16", "3", "9", "5"],
            correctAnswer: 2),
        Question(
            question: "What is the Capital of Australia?",
            answers: ["Sydney", "Melbourne", "Adelaide", "Canberra"],
            correctAnswer: 3),
        Question(
            question: "What is the Capital of Canada?",
            answers: ["Vancouver", "Toronto", "Ottawa", "Montreal"],
            correctAnswer: 2),
        Question(
            question: "What is the Capital of United States?",
            answers: ["Houston", "Las Vegas", "Washington, D.C.", "New-York"],
            correctAnswer: 2),
        Question(
            question: "What is the Capital of Farnce?",
            answers: ["Paris", "Cote-d'Azur", "Verdun", "Sainte-Marie"],
            correctAnswer: 0),
        Question(
            question: "What is the Capital of Switzerland?",
            answers: ["Berne", "Genenva", "Fribourg", "Vevey"],
            correctAnswer: 0),
        Question(
            question: "What is the Capital of Belgium?",
            answers: ["Belgium City", "Bruxelles", "Berlin", "Mivata"],
            correctAnswer: 2),
        Question(
            question: "What is the Capital of Germany?",
            answers: ["Stutgart", "Melbourne", "Berlin", "Tomorrowland"],
            correctAnswer: 2),
        Question(
            question: "What is the Capital of Brasil?",
            answers: ["Rio de Janeiro", "Sao Paulo", "Brasil City", "Brasilia"],
            correctAnswer: 3)
    ]
    
    var currentQuestion: Question?
    var currentQuestionPos = 0
    
    var noCorrect = 0
    
    /////////////////////////////////////////////////////////
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.sendSubviewToBack(imageView);
        currentQuestion = questions[0]
        setQuestion()
        displayAnswer.text = ""
        self.displayNextQuestion.isHidden = true
        
        //Parallax background
        let min = CGFloat(-30)
        let max = CGFloat(30)
        
        let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = min
        xMotion.maximumRelativeValue = max
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = min
        yMotion.maximumRelativeValue = max
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [xMotion,yMotion]
        
        imageView.addMotionEffect(motionEffectGroup)
        //
    }
    //FIN VIEWDIDLOAD
    
    let notification = UINotificationFeedbackGenerator()
    
    @IBAction func submitAnswer0(_ sender: Any) {
        checkAnswer(idx: 0)
    }
    @IBAction func submitAnswer1(_ sender: Any) {
        checkAnswer(idx: 1)
    }
    @IBAction func submitAnswer2(_ sender: Any) {
        checkAnswer(idx: 2)
    }
    @IBAction func submitAnswer3(_ sender: Any) {
        checkAnswer(idx: 3)
    }
    
    
    // Check if an answer is correct then load the next question
    func checkAnswer(idx: Int) {
        if(idx == currentQuestion!.correctAnswer) {
            noCorrect += 1
            displayAnswer.text = "Bonne réponse!"
            displayAnswer.textColor = UIColor.green
            displayNextQuestion.isHidden = false
            displayNextQuestion.isEnabled = true
            answer0.isEnabled = false
            answer1.isEnabled = false
            answer2.isEnabled = false
            answer3.isEnabled = false
            notification.notificationOccurred(.success)
            goodAnswerSound()
            print("\(currentQuestion!.correctAnswer)")
            if(currentQuestion!.correctAnswer == 0)
            {
                print("The answer is right. Put this question in green")
            }
            if(currentQuestion!.correctAnswer == 1)
            {
                print("The answer is right. Put this question in green")
            }
            if(currentQuestion!.correctAnswer == 2)
            {
                print("The answer is right. Put this question in green")
            }
            if(currentQuestion!.correctAnswer == 3)
            {
                print("The answer is right. Put this question in green")
            }
        }
        else
        {
            displayAnswer.text = "Mauvaise réponse!"
            displayAnswer.textColor = UIColor.red
            displayNextQuestion.isHidden = false
            displayNextQuestion.isEnabled = true
            answer0.isEnabled = false
            answer1.isEnabled = false
            answer2.isEnabled = false
            answer3.isEnabled = false
            notification.notificationOccurred(.error)
            wrongAnswerSound()
            print("\(currentQuestion!.correctAnswer)")
            if(currentQuestion!.correctAnswer == 0)
            {
                print("The answer is wrong. Put this question in gray")
            }
            if(currentQuestion!.correctAnswer == 1)
            {
                print("The answer is wrong. Put this question in gray")
            }
            if(currentQuestion!.correctAnswer == 2)
            {
                print("The answer is wrong. Put this question in gray")
            }
            if(currentQuestion!.correctAnswer == 3)
            {
                print("The answer is wrong. Put this question in gray")
            }
        }
        
    }
    
    @IBAction func showNextQuestion(_ sender: Any) {
        displayNextQuestion.isEnabled = false
        displayNextQuestion.isHidden = true
        answer0.isEnabled = true
        answer1.isEnabled = true
        answer2.isEnabled = true
        answer3.isEnabled = true
        displayAnswer.text = ""
        loadNextQuestion()
    }
    
    @IBAction func fromCategory4ToCategories(_ sender: Any) {
        self.performSegue(withIdentifier: "fromCategory4ToCategories", sender: self)
        buttonClickSound()
    }
    
    
    func loadNextQuestion() {
        // Show next question
        if(currentQuestionPos + 1 < questions.count) {
            currentQuestionPos += 1
            currentQuestion = questions[currentQuestionPos]
            setQuestion()
            // If there are no more questions show the results
        } else {
            performSegue(withIdentifier: "fromCategory4ToResults", sender: nil)
        }
        
        
    }
    
    // Set labels and buttions for the current question
    func setQuestion() {
        lblQuestion.text = currentQuestion!.question
        lblQuestion.text = lblQuestion.text?.uppercased()
        answer0.setTitle(currentQuestion!.answers[0], for: .normal)
        answer1.setTitle(currentQuestion!.answers[1], for: .normal)
        answer2.setTitle(currentQuestion!.answers[2], for: .normal)
        answer3.setTitle(currentQuestion!.answers[3], for: .normal)
        lblProgress.text = "\(currentQuestionPos + 1) sur \(questions.count)"
        lblProgress.text = lblProgress.text?.uppercased()
        displayAnswer.text = displayAnswer.text?.uppercased()
    }
    
    // Before we move to the results screen pass the how many we got correct, and the total number of questions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "fromCategory4ToResults") {
            let vc = segue.destination as! ResultsViewController
            vc.noCorrect = noCorrect
            vc.total = questions.count
        }
    }
    
    func buttonClickSound() {
        let url = Bundle.main.url(forResource: "button", withExtension: "wav")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
        player?.volume = 1.0
    }
    func wrongAnswerSound() {
        let url = Bundle.main.url(forResource: "deny", withExtension: "wav")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
        player?.volume = 1.0
    }
    func goodAnswerSound() {
        let url = Bundle.main.url(forResource: "affirm", withExtension: "wav")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
        player?.volume = 1.0
    }
    
}
