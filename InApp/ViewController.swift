//
//  ViewController.swift
//  InApp
//
//  Created by Abdulla on 17.11.2022.
//

import UIKit

struct Model {
    let title: String
    let handler: (() -> Void)
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var models = [Model]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Configure Models
        models.append(Model(title: "500 Diamonds", handler: {
            
            IAPManager.shared.purchase(product: .diamond_500) {[weak self] count in DispatchQueue.main.async {
                let currentCount = self?.myDiamondsCount ?? 0
                let newCount = currentCount + count
                UserDefaults.standard.setValue(newCount, forKey: "diamond_count")
                self?.setUpHeader()
            }}
        }))
        
        models.append(Model(title: "1000 Diamonds", handler: {
            
            IAPManager.shared.purchase(product: .diamond_1000) {[weak self] count in DispatchQueue.main.async {
                let currentCount = self?.myDiamondsCount ?? 0
                let newCount = currentCount + count
                UserDefaults.standard.setValue(newCount, forKey: "diamond_count")
                self?.setUpHeader()
            }}
        }))
        
        models.append(Model(title: "2500 Diamonds", handler: {
            
            IAPManager.shared.purchase(product: .diamond_2500) {[weak self] count in DispatchQueue.main.async {
                let currentCount = self?.myDiamondsCount ?? 0
                let newCount = currentCount + count
                UserDefaults.standard.setValue(newCount, forKey: "diamond_count")
                self?.setUpHeader()
            }}
        }))
        
        models.append(Model(title: "5000 Diamonds", handler: {
            
            IAPManager.shared.purchase(product: .diamond_5000) {[weak self] count in DispatchQueue.main.async {
                let currentCount = self?.myDiamondsCount ?? 0
                let newCount = currentCount + count
                UserDefaults.standard.setValue(newCount, forKey: "diamond_count")
                self?.setUpHeader()
            }}
        }))
        
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        setUpHeader()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        cell.imageView?.image = UIImage(systemName: "suit.diamond.fill")
        cell.imageView?.tintColor = .systemBlue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.row]
        model.handler()
    }
    
    var myDiamondsCount: Int {
        return UserDefaults.standard.integer(forKey: "diamond_count")
    }
    
    func setUpHeader() {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        let imageView = UIImageView(image: UIImage(systemName: "suit.diamond.fill"))
        imageView.frame = CGRect(x: (view.frame.size.width - 100)/2, y: 10, width: 100, height: 100)
        imageView.tintColor = .systemBlue
        header.addSubview(imageView)
        let label = UILabel(frame: CGRect(x: 10, y: 120, width: view.frame.size.width-20, height: 100))
        header.addSubview(label)
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .center
        label.text = "\(myDiamondsCount) Diamonds"
        tableView.tableHeaderView = header
    }
    
    
}
