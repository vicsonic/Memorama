//
//  StoresViewController.swift
//  Memorama
//
//  Created by Victor Soto on 10/25/17.
//  Copyright © 2017 Radial Loop Inc. All rights reserved.
//

import UIKit

class StoresViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Database.stores.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let store = Database.stores[indexPath.row]
        cell.textLabel?.text = store
        cell.accessoryType = store == Database.shared.tienda ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Database.shared.tienda = Database.stores[indexPath.row]
        tableView.reloadData()
    }

    // MARK: - Actions
    
    @IBAction func acceptButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
