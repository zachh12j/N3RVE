//
//  Category1.swift
//  Aeris
//
//  Created by Camilo Rossi on 2018-10-13.
//  Copyright © 2018 Camilo Rossi. All rights reserved.
//

import UIKit

@IBDesignable
extension UILabel {
    @IBInspectable
    public var kerning:CGFloat {
        set{
            if let currentAttibutedText = self.attributedText {
                let attribString = NSMutableAttributedString(attributedString: currentAttibutedText)
                attribString.addAttributes([NSAttributedString.Key.kern:newValue], range:NSMakeRange(0, currentAttibutedText.length))
                self.attributedText = attribString
            }
        } get {
            var kerning:CGFloat = 0
            if let attributedText = self.attributedText {
                attributedText.enumerateAttribute(NSAttributedString.Key.kern,
                                                  in: NSMakeRange(0, attributedText.length),
                                                  options: .init(rawValue: 0)) { (value, range, stop) in
                                                    kerning = value as? CGFloat ?? 0
                }
            }
            return kerning
        }
    }
}

class Category1: UIViewController {
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
    
    var questions: [Question] = [
        Question(
            question: "What is 1+1?",
            answers: ["1", "2", "3", "4"],
            correctAnswer: 1),
        Question(
            question: "Have you subscrbed to Seemu Apps",
            answers: ["Yes", "No", "I will", "No Thanks"],
            correctAnswer: 0),
        Question(
            question: "What is the Capital of Australia?",
            answers: ["Sydney", "Melbourne", "Adelaide", "Canberra"],
            correctAnswer: 3),
        Question(
            question: "What is the Capital of Australia?",
            answers: ["Sydney", "Melbourne", "Adelaide", "Canberra"],
            correctAnswer: 3),
        Question(
            question: "What is the Capital of Australia?",
            answers: ["Sydney", "Melbourne", "Adelaide", "Canberra"],
            correctAnswer: 3),
        Question(
            question: "What is the Capital of Australia?",
            answers: ["Sydney", "Melbourne", "Adelaide", "Canberra"],
            correctAnswer: 3),
        Question(
            question: "What is the Capital of Australia?",
            answers: ["Sydney", "Melbourne", "Adelaide", "Canberra"],
            correctAnswer: 3),
        Question(
            question: "What is the Capital of Australia?",
            answers: ["Sydney", "Melbourne", "Adelaide", "Canberra"],
            correctAnswer: 3),
        Question(
            question: "What is the Capital of Australia?",
            answers: ["Sydney", "Melbourne", "Adelaide", "Canberra"],
            correctAnswer: 3),
        Question(
            question: "What is the Capital of Australia?",
            answers: ["Sydney", "Melbourne", "Adelaide", "Canberra"],
            correctAnswer: 3)
    ]
    
    var currentQuestion: Question?
    var currentQuestionPos = 0
    
    var noCorrect = 0
    
    /////////////////////////////////////////////////////////
    
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
    
    @IBAction func fromCategory1ToCategories(_ sender: Any) {
        self.performSegue(withIdentifier: "fromCategory1ToCategories", sender: self)
    }
    
    
    func loadNextQuestion() {
        // Show next question
        if(currentQuestionPos + 1 < questions.count) {
            currentQuestionPos += 1
            currentQuestion = questions[currentQuestionPos]
            setQuestion()
            // If there are no more questions show the results
        } else {
            performSegue(withIdentifier: "fromCategory1ToResults", sender: nil)
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
    }
    
    // Before we move to the results screen pass the how many we got correct, and the total number of questions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "fromCategory1ToResults") {
            let vc = segue.destination as! ResultsViewController
            vc.noCorrect = noCorrect
            vc.total = questions.count
        }
    }

}
