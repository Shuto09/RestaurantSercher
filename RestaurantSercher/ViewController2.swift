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
    
    var lat:Double?
    var lng:Double?
    
    private let cellId = "cellId"
    private var apis = [Api]()
    static var count: Int = 0
    
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
    //URL作成
    private func getApi() {
        let apiKey: String = "c31fe861ba13d33c"
        let beseUrl:String = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?"
        let api:String = "key=" + apiKey
        let urlLat:String = "&lat=" + String(lat ?? 34.67)
        let urlLng:String = "&lng=" + String(lng ?? 135.52)
        let range:String = "&range=3"
        let format:String = "&format=json"
        let mixUrl:String = beseUrl + api + urlLat + urlLng + range + format
        guard let url = URL(string: mixUrl) else { return }
        
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
//                    print("ここからapiです：",api)
//                    print(self.apis.count)
                    print(api.results.resultsReturned)
                    ViewController2.count = api.results.resultsReturned.value
                    print(ViewController2.count)
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
//            let count = api?.results.resultsReturned.value
            for i in 0 ..< ViewController2.count{
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
    //ロゴ
    let logoImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        return iv
    }()
    //お店の名前
    let bodyTextLabel: UILabel = {
        let label = UILabel()
        label.text = "something in here"
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //レイアウト
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
