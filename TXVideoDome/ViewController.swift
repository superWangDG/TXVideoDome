//
//  ViewController.swift
//  TXVideoDome
//
//  Created by 98data on 2019/9/28.
//  Copyright © 2019 98data. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        
    }

    @IBAction func startAction(_ sender: Any) {
//        self.present(RecordingViewController(), animated: true, completion: nil)
        let vc = VideoRootViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}

