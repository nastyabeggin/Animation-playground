//
//  TopicsTableViewController.swift
//  AnimationTestApp
//
//  Created by Anastasiya Beginina on 15.04.2024.
//

import UIKit
import SwiftUI

class TopicsTableViewController: UITableViewController {
    let topics = ["Animations": AnimationViewController(),
                  "Emoji animation": EmojiViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    private func setupTableView() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = Array(topics.keys)[indexPath.row]
        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = topics[Array(topics.keys)[indexPath.row]]
        
        guard let detailVC else { return }
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

#Preview {
    TopicsTableViewController()
}
