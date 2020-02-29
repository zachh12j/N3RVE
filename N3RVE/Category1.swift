//
//  Category1.swift
//  Aeris
//
//  Created by Camilo Rossi on 2018-10-13.
//  Copyright © 2018 Camilo Rossi. All rights reserved.
//

import UIKit
import AVFoundation

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
    var player: AVAudioPlayer?
    
    var questions: [Question] = [
        Question(
            question: "Pendant combien de jours un individu devrait-il voyager en avion tous les jours avant de subir un accident?",
            answers: ["1000 ans", "50 ans", "123 000 ans", "40 000 ans"],
            correctAnswer: 2),
        Question(
            question: "Quelles sont les chances de mourir lors d'un crash?",
            answers: ["1 pour 1 000", "1 pour 500", "1 pour 500 000", "1 pour 11 000 000"],
            correctAnswer: 3),
        Question(
            question: "« Une étude menée entre 1983 et 2000 démontre que __% des personnes ayant vécu un accident d'avion ont survécu. »",
            answers: ["50,3%", "100%", "44,58%", "95,7%"],
            correctAnswer: 3),
        Question(
            question: "À quelle fréquence enregistre-t-on des crash d'avions? Un incident tous les:",
            answers: ["1 million de vols", "1,2 million de vols", "100 000 vols", "800 000 vols"],
            correctAnswer: 1),
        Question(
            question: "Combien de fois le nombre de passagers décédés a-t-il baissé entre 1996 et 2017?",
            answers: ["1,5x", "2x", "4x", "6,4x"],
            correctAnswer: 2),
        Question(
            question: "Compléter la phrase: Chaque jour, plus de _____ avions de ligne à réaction décollent pour réaliser chacuns en moyenne 3 trajets.",
            answers: ["10 000", "100", "1 000 000", "25 000"],
            correctAnswer: 3),
        Question(
            question: "Combien de fois l'automobile est-elle plus dangereuse que l'avion?",
            answers: ["100x", "72x", "85x", "30x"],
            correctAnswer: 1),
        Question(
            question: "Le moustique est combien de fois plus meurtrier qu'un crash d'avion?",
            answers: ["10 fois", "100 fois", "1000 fois", "500 fois"],
            correctAnswer: 2),
        Question(
            question: "Quel est le pourcentage des accidents d'avions qui surviennent dans les 8 premières minutes ou les 3 dernières?",
            answers: ["50%", "80%", "100%", "25%"],
            correctAnswer: 1),
        Question(
            question: "Quelle est la probabilité équivalente de subir un crash aérien?",
            answers: ["Mourir mangé par un requin", "Gagner le jackpot au lotto", "Mourir par une noix de coco", "Mourir en avalant son stylo… oui oui, son stylo"],
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
    
    @IBAction func fromCategory1ToCategories(_ sender: Any) {
        self.performSegue(withIdentifier: "fromCategory1ToCategories", sender: self)
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
        displayAnswer.text = displayAnswer.text?.uppercased()
    }
    
    // Before we move to the results screen pass the how many we got correct, and the total number of questions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "fromCategory1ToResults") {
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
