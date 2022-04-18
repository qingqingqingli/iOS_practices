//
//  DetailsViewController.swift
//  project1
//
//  Created by Qing Li on 13/04/2022.
//

import UIKit

class DetailsViewController: UIViewController {

    var imageView = UIImageView()
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedImage
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
        
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        /// important to set this when you are setting the layout
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        setupView()
    }
    
    private func setupView() {
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding * 3),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding * 3),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
    }
    
    /// to only allow hiding of navigation bars when the view is appearing
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
