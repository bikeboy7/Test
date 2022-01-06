//
//  DoubleScrollViewDemoViewController.swift
//  Test
//
//  Created by panjinyong on 2021/12/8.
//

import UIKit

class DoubleScrollViewDemoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
    }
    
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .red
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView.init(frame: .zero, style: .plain)
        view.backgroundColor = .yellow
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.rowHeight = 100
        return view
    }()



    override func viewDidLoad() {
        super.viewDidLoad()
        let width: CGFloat = 300
        let height: CGFloat = 600
        view.addSubview(scrollView)
        scrollView.frame = .init(x: 20, y: 100, width: width, height: height)
        scrollView.contentSize = .init(width: width, height: (height - 100) * 3)
        for i in 0..<3 {
            let subView = UIView(frame: .init(x: 0, y: CGFloat(i) * height, width: width, height: height))
            subView.backgroundColor = .init(white: 0, alpha: CGFloat(i) * 0.3)
            scrollView.addSubview(subView)
        }
//        scrollView.isPagingEnabled = true
        
        scrollView.addSubview(tableView)
        tableView.frame = .init(x: 10, y: scrollView.contentSize.height - height, width: width - 20, height: height)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
