//
//  ViewController.swift
//  Project 5
//
//  Created by Harshit Bhargava  on 11/10/24.
//

import UIKit

class ViewController: UITableViewController {
    var allWords: [String] = []
    var usedWords: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnser))
        
        // Do any additional setup after loading the view.
        if let startWordUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWord = try? String(contentsOf: startWordUrl) {
                allWords = startWord.components(separatedBy: "\n")
                print(allWords)
            } else {
                if allWords.isEmpty {
                    allWords = ["silkworm"]
                }
            }
        }
        startGame()
    }
    
    func startGame () {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func promptForAnser() {
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac,animated: true)
    }
    
    func submit(_ answer:String) {
        let errorTitle:String
        let errorMSG:String
        let loweCaseAnswer = answer.lowercased()
        if isPossible(word: loweCaseAnswer){
            if isOrginal(word: loweCaseAnswer) {
                if isReal(word: loweCaseAnswer) {
                    usedWords.insert(loweCaseAnswer, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                } else {
                    errorTitle = "Word not Recognized"
                    errorMSG = "Please enter a valid word"
                }
            } else {
                errorTitle = "word alredy used"
                errorMSG = "Please enter a new word"
            }
        } else {
            errorTitle = "Word not possible"
            errorMSG = "You can't spell that word from (\(title!))"
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMSG, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
    }
    
    func isPossible(word:String)->Bool {
        guard var tempWord = title?.lowercased() else {return false}
        
        for letter in word {
            if let index = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: index)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOrginal(word:String)->Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word:String)->Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.count)
        let matches = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return matches.location == NSNotFound
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
}

