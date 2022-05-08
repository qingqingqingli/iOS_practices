//
//  Created by Qing Li on 08/05/2022.
//

import UIKit

class PetitionsViewController: UIViewController {
    var petitions = [Petition]()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.delegate = self
        view.dataSource = self
        view.register(PetitionTableViewCell.self, forCellReuseIdentifier: PetitionTableViewCell.reuseIdentifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rowHeight = 70
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpDataSource()
        setUpViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if tabBarItem.tag == 0 {
            parent?.navigationItem.title = "Most recent"
        } else {
            parent?.navigationItem.title = "Most liked"
        }
    }
    
    private func setUpDataSource() {
//        let petition1 = Petition(title: "petition 1", body: "test data for petition 1", signatureCount: 100)
//        let petition2 = Petition(title: "petition 2", body: "test data for petition 2", signatureCount: 200)
//        let petition3 = Petition(title: "petition 3", body: "test data for petition 3", signatureCount: 300)
//        petitions.append(petition1)
//        petitions.append(petition2)
//        petitions.append(petition3)
        
        /// load json data -> Issue: our UI will lock up until all data has been downloaded and transformed
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        if let url = URL(string: urlString),
           let data = try? Data(contentsOf: url) {
            parse(json: data)
            return
        }
        showError()
    }
    
    private func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    private func showError() {
        let ac = UIAlertController(
            title: "Loading error",
            message: "There was a problem loading the feed",
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        
    }
    
    private func setUpViewLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension PetitionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PetitionTableViewCell.reuseIdentifier, for: indexPath)
        guard let cell = cell as? PetitionTableViewCell else { return UITableViewCell() }
        
        let petition = petitions[indexPath.row]
        cell.configure(petition: petition)
        
        return cell
    }
}

extension PetitionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}



