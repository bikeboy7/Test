//
//  ViewController.swift
//  Test
//
//  Created by panjinyong on 2021/8/11.
//

import UIKit
import LJDebugTool

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        ProxyTimer.init().test()
//        TaggedPointer.init().test()
//        Runtime().test()
//        let runloop = RunLoopTest()
//        runloop.addObserver()
//        runloop.addTextView(in: view)
//        runloop.test()
//        runloop.timerTest()
        
//        labelMore()
        
//        GCD.test()
//        Thread.test()
        Thread.test()
//        OperationTest.test()
        
    }
    
    
    private func shadow() {
        let bgView = UIView()
        bgView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.yellow.cgColor
        bgView.backgroundColor = .clear
        bgView.layer.shadowColor = UIColor.red.cgColor
        bgView.layer.shadowOffset = .init(width: 2, height: 2)
        bgView.layer.shadowOpacity = 1
        bgView.layer.shadowRadius = 2
        view.addSubview(bgView)
//        bgView.alpha = 0.8
        bgView.layer.allowsGroupOpacity = false
        bgView.layer.opacity = 0.1
        bgView.layer.allowsGroupOpacity = true
//        subview.layer.shadowPath
        
        let subview = UIView()
        subview.frame = CGRect(x: 30, y: 30, width: 50, height: 50)
        subview.backgroundColor = .blue
        bgView.addSubview(subview)
    }


}

