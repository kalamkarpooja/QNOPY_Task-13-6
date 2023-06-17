//
//  HomeViewController.swift
//  QNOPY Task
//
//  Created by Mac on 13/06/23.
//

import UIKit
import SDWebImage
class HomeViewController: UIViewController {
    var product = [Product]()
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var productTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        tableViewProtocols()
        registerXib()
        getProductApi()
        welcomeLabel.text = "Welcome"
        welcomeLabel.font = .boldSystemFont(ofSize: 19)
        welcomeLabel.textColor = .systemBlue
    }
    func tableViewProtocols(){
        productTableView.delegate = self
        productTableView.dataSource = self
    }
    func registerXib(){
        let uinib = UINib(nibName: "ProductTableViewCell", bundle: nil)
        productTableView.register(uinib, forCellReuseIdentifier: "ProductTableViewCell")
    }
    func getProductApi(){
        let urlString = "https://dummyjson.com/products"
        let url = URL(string: urlString)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlRequest){data ,response,error in
            print(String(data: data!, encoding: .utf8)!)
            if(error == nil){
                let jsonObject = try! JSONSerialization.jsonObject(with: data!) as! [String : Any]
                let product = jsonObject["products"] as! [[String : Any]]
                
                for eachProduct in product{
                    
                    let id = eachProduct["id"] as! Int
                    let title = eachProduct["title"] as! String
                    let price = eachProduct["price"] as! Int
                    let rating = eachProduct["rating"] as! Double
                    let brand = eachProduct["brand"] as! String
                    let description = eachProduct["description"] as! String
                    let category = eachProduct["category"] as! String
                    let thumbnail = eachProduct["thumbnail"] as! String
                    let discountPercentage = eachProduct["discountPercentage"] as! Double
                    let images = eachProduct["images"] as! [String]
                    let stock = eachProduct["stock"] as! Int
                    
                    let newProductObject = Product(id:id,title: title,description: description, price: price,discountPercentage:discountPercentage, rating: rating,stock:stock, brand: brand,category: category,thumbnail:thumbnail,images:images)
                    
                    self.product.append(newProductObject)
                }
            DispatchQueue.main.async {
                self.productTableView.reloadData()
            }
        }
        
    }
        .resume()
  }
}
extension HomeViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        cell.titleLabel.text = product[indexPath.row].title
        cell.priceLabel.text = "Price : \(product[indexPath.row].price)"
        cell.brandLabel.text = "Brand : \(product[indexPath.row].brand)"
        let urlstring = product[indexPath.row].thumbnail
        let url = URL(string: urlstring)
        cell.productImage.sd_setImage(with: url)
        cell.layer.borderWidth = 4
        cell.layer.cornerRadius = 20
        cell.layer.borderColor = .init(genericCMYKCyan: 1, magenta: 1, yellow: 1, black: 3, alpha: 2)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}
