//
//  ViewController.swift
//  project2
//
//  Created by Qing Li on 14/04/2022.
//

import UIKit

class ViewController: UIViewController {
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var answeredQuestions = 0
    
    let button1: UIButton = {
        var button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 0
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }()
    
    let button2: UIButton = {
        var button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 1
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        return button
    }()
    
    let button3: UIButton = {
        var button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 2
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        return button
    }()
    
    @objc func buttonTapped(_ sender: UIButton){
        var title: String
        
        answeredQuestions += 1
        
        if correctAnswer == sender.tag {
            title = "CORRECT"
            score += 1
        } else {
            title = "WRONG"
            score -= 1
        }
        
        score < 5 ? showResultAlert(title: title) : showFinalResultAlert()
        
    }
    
    private func showResultAlert(title: String) {
        let alertController = UIAlertController(
            title: title,
            message: "Your score is \(score)",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: setupCountryImage))
        
        present(alertController, animated: true)
    }
    
    private func showFinalResultAlert() {
        let alertController = UIAlertController(
            title: "Final score",
            message: "You've reached 5 points",
            preferredStyle: .alert)
        
        present(alertController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        setupCountryImage()
        setupViewLayer()
    }
    
    private func setupCountryImage(_ action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        title = "Current score: \(score) | \(countries[correctAnswer].uppercased())"
        

        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }
    
    private func setupViewLayer() {
        
        let padding: CGFloat = 8
        let buttonHeight: CGFloat = 100
        let buttonWidth: CGFloat = 200
        
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        
        NSLayoutConstraint.activate ([
            button1.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            button1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            button1.widthAnchor.constraint(equalToConstant: buttonWidth),
            button1.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        
        NSLayoutConstraint.activate ([
            button2.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: padding),
            button2.widthAnchor.constraint(equalToConstant: buttonWidth),
            button2.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        
        NSLayoutConstraint.activate ([
            button3.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            button3.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: padding),
            button3.widthAnchor.constraint(equalToConstant: buttonWidth),
            button3.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
}

