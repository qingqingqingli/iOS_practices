//
//  Created by Qing Li on 08/05/2022.
//

import UIKit

class RootViewController: UITabBarController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let mostRecent = PetitionsViewController()
        mostRecent.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
        
        let mostLiked = PetitionsViewController()
        mostLiked.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        self.viewControllers = [mostRecent, mostLiked]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        view.backgroundColor = .white
    }

}

extension RootViewController: UITabBarControllerDelegate { }
