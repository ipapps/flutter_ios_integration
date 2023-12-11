//
//  ViewController.swift
//  flutterintegration
//
//  Created by David Fournier on 22/11/2023.
//

import UIKit
import Flutter

class ViewController: UIViewController {
    
    @IBAction func didClickFlutterButton(_ sender: UIButton) {
        let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
        let flutterViewController =
            FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        flutterViewController.modalPresentationStyle = .overCurrentContext
        flutterViewController.isViewOpaque = false
        present(flutterViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


