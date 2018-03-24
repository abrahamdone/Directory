//
//  DirectoryViewController.swift
//  Directory
//
//  Created by Abraham Done on 3/22/18.
//  Copyright © 2018 Abraham Done. All rights reserved.
//

import UIKit

class DirectoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private(set) var directory: Directory?
}

// MARK: View life cycle
extension DirectoryTableViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if directory == nil {
            refresh()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("DirectoryViewController", value: "Directory", comment: "The title of the directory view")

        tableView.register(DirectoryCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        tableView.tableFooterView = UIView()
        
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc
    func refresh() {
        Directory.fetch(forceReload: false, success: { [weak self] directory in
            if directory.individuals.count == 0 {
                self?.showMissingDataAlert()
            } else {
                self?.load(directory: directory)
            }
        }) { [weak self] error in
            self?.showMissingDataAlert()
        }

    }
    
    func load(directory: Directory) {
        self.directory = directory
        tableView.reloadData()
    }
    
    func showMissingDataAlert() {
        let title = NSLocalizedString("DirectoryViewControllerErrorTitle", value: "Error", comment: "There was an error")
        let message = NSLocalizedString("DirectoryViewControllerErrorMessage", value: "There was an error retrieving the directory", comment: "There was an error")
        let action = NSLocalizedString("DirectoryViewControllerErrorAction", value: "OK", comment: "Let the action happen")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate
extension DirectoryTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let directory = directory, let vc = storyboard?.instantiateViewController(withIdentifier: IndividualViewController.identifier) as? IndividualViewController else {
            return
        }
        
        vc.individual = directory.individuals[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: UITableViewDataSource
extension DirectoryTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return directory?.individuals.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let directory = directory, let cell = tableView.dequeueReusableCell(withIdentifier: DirectoryCell.identifier) as? DirectoryCell else {
            return UITableViewCell()
        }
        
        cell.setup(individual: directory.individuals[indexPath.row])
        
        return cell
    }
}
