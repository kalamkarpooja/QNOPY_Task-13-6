//
//  ViewController.swift
//  QNOPY Task
//
//  Created by Mac on 13/06/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func loginSuccesfully(){
        let alert = UIAlertController(title: title, message: "Login Successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
            print("tapped ok")
        }))
        present(alert, animated: true)
    }
    @IBAction func loginBtn(_ sender: UIButton) {
        sendLoginResponse()
        loginResponse(success: true)
        
    }
    func loginResponse(success : Bool){
        if success {
            //Navigate to homeViewController
            DispatchQueue.main.async { [self] in
//                let storyBoard = UIStoryboard(name: "HomeViewController", bundle: nil)
                
                if let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController{
                  
                    self.navigationController!.pushViewController(homeVC, animated: true)
                    loginSuccesfully()
                }
            }
        }else{
            print("failed")
        }
    }
    //api
    let apiURLString = "https://restapi.adequateshop.com/api/authaccount/login"
    //define the request parameters as a dictionary
    let parameters = [
        "email" : "Developer5@gmail.com",
        "password" : "123456"
    ]
    //create and send the request
    func sendLoginResponse(){
        guard let url = URL(string: apiURLString) else {
            print("invalid url")
            return
        }
        //create the request object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //set the request body
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: parameters,options: [])
            request.httpBody = jsonData
        }catch{
            print("error serializing json:\(error)")
            return
        }
        //set the request headers if neccesary
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //create the data task to send the request
        let task = URLSession.shared.dataTask(with: request){(data,response,error) in
            //handle the response
            if let error = error {
                print("error:\(error)")
                return
            }
            guard let data = data else {
                print("no data received")
                return
            }
        //parse the response data as json
            do{
                if let json = try! JSONSerialization.jsonObject(with: data,options: []) as? [String : Any]{
                    print(json)
                    
                    if let code = json["code"] as? Int,let message = json["message"] as? String{
                        if code == 0{
                            if let userData = json["data"] as? [String: Any],let name = userData["Name"] as? String{
                                print("Name:\(name)")
                                DispatchQueue.main.async {
                                    
                                }
                            }
                        }else{
                            print("error:\(message)")
                        }
                    }
                }
            }catch{
                print("error deseriallizing json:\(error)")
            }
        }
            .resume()
    }
}
