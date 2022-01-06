//
//  AViewController.swift
//  Test
//
//  Created by panjinyong on 2021/11/3.
//

import UIKit

class AViewController<T>: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableView.self, forCellReuseIdentifier: "UITableView")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: "UITableView", for: indexPath)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}

