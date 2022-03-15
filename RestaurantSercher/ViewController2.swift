//
//  ViewController2.swift
//  RestaurantSercher
//
//  Created by 渡邊秋斗 on 2022/03/15.
//

import UIKit
//構造体
struct Api: Decodable {
    let results: Results
    enum CodingKeys: String, CodingKey{
        case results = "results"
    }
}

struct Results: Decodable {
    let resultsReturned: StringTo<Int>
    let shop: [Shop]
    enum CodingKeys: String, CodingKey{
        case resultsReturned = "results_returned"
        case shop = "shop"
    }
}
    //String -> Int のため
struct StringTo<T: LosslessStringConvertible> {
    let value: T
}
extension StringTo : Decodable {
    init(from decoder: Decoder) throws {
        let conteiner = try decoder.singleValueContainer()
        let string = try conteiner.decode(String.self)
        guard let value = T(string) else {
            let debugDescription = "'\(string)' could not convert to \(T.self)."
            let context = DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: debugDescription
            )
            throw DecodingError.dataCorrupted(context)
        }
        self.value = value
    }
}


struct Shop: Codable {
    let name: String
    let access: String
    let logoImage: String
    enum CodingKeys: String, CodingKey{
        case name = "name"
        case access = "access"
        case logoImage = "logo_image"
    }
}


class ViewController2: UIViewController {
    
    private let cellId = "cellId"
    private var apis = [Api]()
    
    let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.frame.size = view.frame.size
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ApiTableViewCell.self, forCellReuseIdentifier: cellId)
        navigationItem.title = "飲食店一覧"
        
        getApi()
    }
    //Api リクエスト
    private func getApi() {
        
        guard let url = URL(string: "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=c31fe861ba13d33c&lat=34.67&lng=135.52&range=5&order=4&format=json") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: url){ (data, response, err) in
            if let err = err{
                print("情報の取得に失敗しました。(1)：", err)
                return
            }
            if let data = data {
                do {
                    let api = try JSONDecoder().decode(Api.self, from: data)
                    self.apis = [api]
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print("json:", api)
//                    件数表示（String -> Int）
//                    print(api.results.resultsReturned.value)
                    print("ここからapiです：",api)
                    print(self.apis.count)
                } catch(let err) {
                    print("情報の取得に失敗しました。(2)：", err)
                    return
                }
            }
        }
        task.resume()
    }
}

extension ViewController2: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return api.results.resultsReturned.value
        return apis.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ApiTableViewCell
        cell.api = apis[indexPath.row]
        
        return cell
    }
}

class ApiTableViewCell: UITableViewCell {
    var api: Api? {
        didSet {
            let count = api?.results.resultsReturned.value
                for i in 0 ..< count!{
                    bodyTextLabel.text = api?.results.shop[i].name
                    let url = URL(string: api?.results.shop[i].logoImage ?? "")
                    do {
                        let data = try Data(contentsOf: url!)
                        let image = UIImage(data: data)
                        logoImageView.image = image
                    }catch let err {
                        print("Error : \(err.localizedDescription)")
                    }
                }
        }
    }
    
    let logoImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        return iv
    }()
    
    let bodyTextLabel: UILabel = {
        let label = UILabel()
        label.text = "something in here"
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(logoImageView)
        addSubview(bodyTextLabel)
        [
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 50),
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            
            bodyTextLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 20),
            bodyTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ].forEach{ $0.isActive = true }
        
        logoImageView.layer.cornerRadius = 50 / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
