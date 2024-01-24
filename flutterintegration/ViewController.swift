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
        
        //Sending data to Flutter Module
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue("1234-5678-IOS", forKey: "user_id")
        var convertedString: String? = nil
        do {
            convertedString = String(data: try JSONSerialization.data(withJSONObject: jsonObject), encoding: String.Encoding.utf8)
        } catch let myJSONError {
            print(myJSONError)
        }
        let flutterMethodChannel = FlutterMethodChannel(name: "fr.apps42.fi", binaryMessenger: flutterViewController.binaryMessenger)
        flutterMethodChannel.invokeMethod("setUserId", arguments: convertedString)
        
        present(flutterViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
}


