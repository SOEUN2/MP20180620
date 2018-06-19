//
//  MessageCreateViewController.swift
//  Project2
//
//  Created by SWUCOMPUTER on 2018. 6. 19..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class MessageCreateViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet var textSender: UITextField!
    @IBOutlet var textRecipient: UITextField!
    @IBOutlet var labelStatus1: UILabel!
    @IBOutlet var textContent: UITextField!
    
    @IBAction func buttonSave(){
        if textSender.text == "" {
            labelStatus1.text = "보내는 사람을 입력하세요"; return;
        }
        if textContent.text == "" {
            labelStatus1.text = "메세지의 내용을 입력하세요"; return;
        }
        if textRecipient.text == "" {
            labelStatus1.text = "받는 사람을 입력하세요"; return;
        }
        let urlString: String = "http://condi.swu.ac.kr/student/W06iphone/insertMessage.php"
        guard let requestURL = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "sender=" + textSender.text! + "&recipient=" + textRecipient.text! + "&content=" + textContent.text!
        request.httpBody = restString.data(using: .utf8)
        self.executeRequest(request: request)
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textSender {
            textField.resignFirstResponder()
            self.textRecipient.becomeFirstResponder()
        }
        else if textField == self.textRecipient {
            textField.resignFirstResponder()
            self.textContent.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func executeRequest (request: URLRequest) -> Void {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                print("Error: calling POST")
                return
            }
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return
            }
            if let utf8Data = String(data: receivedData, encoding: .utf8) {
                DispatchQueue.main.async {     // for Main Thread Checker
                    self.labelStatus1.text = utf8Data
                }
                print(utf8Data)  // php에서 출력한 echo data가 debug 창에 표시됨
            }
        }
        task.resume()
    }

}
