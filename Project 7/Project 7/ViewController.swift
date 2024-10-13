//
//  ViewController.swift
//  Project 7
//
//  Created by Harshit Bhargava  on 13/10/24.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var uriString:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        if navigationController?.tabBarItem.tag == 0 {
            uriString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            uriString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: uriString) {
            let urlSession = URLSession.shared
            let task = urlSession.dataTask(with: url) { [weak self] data, response, error in
                if let data = data {
                    self?.parse(data)
                } else if let error = error {
                    self?.showError(error)
                }
            }
            // Start the task
            task.resume()
        }
        
        let creditBarButton = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(creditBarButtonAction))
        navigationItem.rightBarButtonItem = creditBarButton
        
        let respondedStatus = UIBarButtonItem(title: "Responded", style: .plain, target: self, action: #selector(respondedStatusBarButtonAction))
        toolbarItems = [respondedStatus]
    }
    
    @objc func respondedStatusBarButtonAction () {
        
    }
    
    @objc func creditBarButtonAction () {
        let ac = UIAlertController(
            title: "Credits",
            message: """
        We are taking this data from the following website:

        \(uriString)

        This website provides petitions data that is updated regularly and helps you stay informed about various petitions.
        Feel free to explore the website for more details.
        """,
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "OK", style: .default)
        let copyAction = UIAlertAction(title: "Copy", style: .default) { _ in
            UIPasteboard.general.string = self.uriString
        }
        ac.addAction(okAction)
        ac.addAction(copyAction)
        present(ac, animated: true)

    }
    
    func showError(_ error:Error) {
        let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(_ data: Data) {
        DispatchQueue.main.async  {
            let decoder = JSONDecoder()
            if let jsonPetitions = try? decoder.decode(Petitions.self, from: data) {
                self.petitions = jsonPetitions.results
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let rowData = petitions[indexPath.row]
        cell.textLabel?.text = rowData.title
        cell.detailTextLabel?.text = rowData.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

