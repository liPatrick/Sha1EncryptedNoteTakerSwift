//
//  ActivateViewController.swift
//  NoteTaker
//
//  Created by Daniel Bessonov on 6/28/17.
//  Copyright © 2017 Shane Doyle. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RegisterViewController : UIViewController {
    
    @IBOutlet weak var key: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    var secret = "SECRET123XE"
    
    override func viewDidLoad() {
        
    }
    
    // hash string with sha256
    func sha256(string: String) -> Data? {
        guard let messageData = string.data(using:String.Encoding.utf8) else { return nil; }
        var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_SHA256(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData
    }
    
    // generate random String with length of N
    func generateRandomKey(length: Int) -> String {
        let letters : NSString = "0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    //4 times
    func hashAlgorithm(val : String) -> Data {
        var initial = sha256(string: val)! as Data
        for i in 0..<4 {
            var backToString = initial.map { String(format: "%02x", $0) }.joined()
            initial = sha256(string: backToString as String)! as Data
        }
        return initial as Data
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        
        var userName = self.nameTextField.text!
        var key = self.key.text!
        
        var input = userName + self.secret
        var output = self.hashAlgorithm(val: input)
        var outputString = output.map { String(format: "%02x", $0) }.joined()
        
        print(outputString)
        
        if(outputString == self.key.text){
            emojiEnabled = true
            let alert = UIAlertController(title: "Success", message: "You can now save emojis!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                self.performSegue(withIdentifier: "goBackToHome", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        let alert = UIAlertController(title: "Failure", message: "Wrong Username or Key", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            self.performSegue(withIdentifier: "goBackToHome", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
        
        
        /*if(self.nameTextField.text != "") {
            let randomPass = generateRandomKey(length: 5)
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainerLicense.viewContext
            let licenseKey = NSEntityDescription.insertNewObject(forEntityName: "License", into: context) as! License
            licenseKey.key = sha256(string: randomPass + "secretKey")! as NSData
            licenseKey.name = self.nameTextField.text!
            // save and go back to home page
            do {
                try context.save()
                let alert = UIAlertController(title: "Success", message: "Your license key is \(randomPass)!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                    self.performSegue(withIdentifier: "goBackToHome", sender: self)
                }))
                self.present(alert, animated: true, completion: nil)
            } catch let saveError as NSError {
                print("Save error: \(saveError.localizedDescription)")
            }
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Please enter your name!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }*/
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        
    }
}

