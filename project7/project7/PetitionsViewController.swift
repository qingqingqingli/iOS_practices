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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if tabBarItem.tag == 0 {
            parent?.navigationItem.title = "Most recent"
        } else {
            parent?.navigationItem.title = "Most liked"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let urlString = determineUrlSource()
        setUpDataSource(from: urlString)
        setUpViewLayout()
        
        parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .bookmarks,
            target: self,
            action: #selector(creditTapped)
        )
    }
    
    private func determineUrlSource() -> String {
        if tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            return "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            return "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
    }
    
    @objc private func creditTapped() {
        let urlString = determineUrlSource()
        let ac = UIAlertController(title: "Source", message: "This list of petition is from \(urlString)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        navigationController?.present(ac, animated: true)
    }
    
    private func setUpDataSource(from urlString: String) {
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



