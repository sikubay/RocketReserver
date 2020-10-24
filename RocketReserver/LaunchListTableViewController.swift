//
//  ViewController.swift
//  RocketReserver
//
//  Created by Bayu Kurniawan on 10/24/20.
//

import UIKit
import Apollo

private let reuseIdentifier = "LaunchCell"

class LaunchListTableViewController: UITableViewController {
    
    // MARK: - Properties
    private let apollo = ApolloClient(url: URL(string: "https://apollo-fullstack-tutorial.herokuapp.com/")!)
    private var launches = [LaunchListQuery.Data.Launch.Launch]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Launches"
        // Do any additional setup after loading the view.
        self.apollo.fetch(query: LaunchListQuery()) {[weak self] result in
            switch result {
            case .success(let graphqlResult):
                if let launches = graphqlResult.data?.launches.launches.compactMap ({$0}) {
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        self.launches.append(contentsOf: launches)
                        self.tableView.reloadData()
                    }
                   
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
}

extension LaunchListTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.launches.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        cell.textLabel?.text = launches[indexPath.row].site
        cell.detailTextLabel?.text = launches[indexPath.row].id
        
        return cell
    }
    
}

