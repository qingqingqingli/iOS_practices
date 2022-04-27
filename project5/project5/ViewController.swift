//
//  ViewController.swift
//  project5
//
//  Created by Qing Li on 23/04/2022.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Word")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        view.backgroundColor = .white
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    private func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc private func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let sumbitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(sumbitAction)
        present(ac, animated: true)
    }
    
    private func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        let errorTitle: String
        let errorMessage: String
        
        func showErrorAlert() {
            let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
        do {
            guard try isNotEmpty(word: lowerAnswer),
                  try isPossible(word: lowerAnswer),
                  try isOriginal(word: lowerAnswer),
                  try isReal(word: lowerAnswer) else { return }
            
            usedWords.insert(answer, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            
        } catch WordCheckError.isEmpty {
            errorTitle = "Empty word"
            errorMessage = "You can't provide an empty word."
            showErrorAlert()
        }
        catch WordCheckError.isNotPossible{
            errorTitle = "Word not recognised"
            errorMessage = "You can't just make them up, you know!"
            showErrorAlert()
        }
        catch WordCheckError.isNotOriginal {
            errorTitle = "Word used already"
            errorMessage = "Be more original!"
            showErrorAlert()
        }
        catch WordCheckError.isNotReal {
            guard let title = title?.lowercased() else { return }
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from \(title)"
            showErrorAlert()
        }
        catch {
            print("\(error): Not specified. ")
        }
    }
    
    private func isNotEmpty(word: String) throws -> Bool {
        if !word.isEmpty { return true }
        
        throw WordCheckError.isEmpty
    }
    
    private func isPossible(word: String) throws -> Bool {
        var tmpWord = title?.lowercased()
        
        for letter in word {
            if let index = tmpWord?.firstIndex(of: letter) {
                tmpWord?.remove(at: index)
            } else {
                throw WordCheckError.isNotPossible
            }
        }
        return true
    }
    
    private func isOriginal(word: String) throws -> Bool {
        guard usedWords.contains(word) == false else {
            throw WordCheckError.isNotOriginal
        }
        return true
    }
    
    private func isReal(word: String) throws -> Bool {
        let checker = UITextChecker()
        
        // Important to convert to utf16 strings when working with UIKit
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        if misspelledRange.location == NSNotFound {
            return true
        } else {
            throw WordCheckError.isNotReal
        }
    }
    
    enum WordCheckError: Error {
        case isEmpty
        case isNotPossible
        case isNotOriginal
        case isNotReal
    }
    
}

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
}


