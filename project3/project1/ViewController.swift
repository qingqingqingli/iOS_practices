//
//  ViewController.swift
//  project1
//
//  Created by Qing Li on 10/04/2022.
//

import UIKit

class ViewController: UITableViewController {

    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        pictures = pictures.sorted(by: <)
        
        /// Provide a prototype cell with the indentifier, otherwise dequeueReusableCell will fail
        tableView.register(PictureTableViewCell.self, forCellReuseIdentifier: "Picture")
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension ViewController {
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = "Picture \(indexPath.row + 1) of \(pictures.count)"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        vc.selectedImage = pictures[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

