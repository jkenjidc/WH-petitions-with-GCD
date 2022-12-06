//
//  ViewController.swift
//  project7
//
//  Created by Justine kenji Dela Cruz on 28/11/2022.
//

import UIKit

class ViewController: UITableViewController{
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var searchIsActive =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString: String
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showCredits))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(promptForSearch))
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }else{
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string:  urlString){
            if let data = try? Data(contentsOf: url){
                parse(json: data)
                return
            }
        }
        showError()
    }
    
    @objc func promptForSearch() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] action in
            let answer = ac.textFields![0]
            self.submit(answer: answer.text!)
        }

        ac.addAction(submitAction)

        present(ac, animated: true)
    }
    
    func submit(answer: String){
        self.filteredPetitions = petitions.filter { $0.title.lowercased().contains(answer.lowercased()) }

        self.searchIsActive = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(clearSearch))
        tableView.reloadData()

    }
    
    @objc func clearSearch(){
        self.searchIsActive = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(promptForSearch))
        tableView.reloadData()
    }
    
    
    func showError() {
        let ac =  UIAlertController(title: "Loading Error", message: "there was a problem loading feed, please check you connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
    }
    
    @objc func showCredits() {
        let ac =  UIAlertController(title: "Credits", message: "The data was taken from whitehouse petitions website", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        do {
            let jsonPetitions = try decoder.decode(Petitions.self, from: json)
            petitions = jsonPetitions.results
            tableView.reloadData()
        } catch {
            print(error) //handle it better in a real app
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchIsActive{
            return petitions.count
        }else{
            return filteredPetitions.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition: Petition
        if !searchIsActive{
            petition = petitions[indexPath.row]
        }else{
            petition = filteredPetitions[indexPath.row]
        }
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

