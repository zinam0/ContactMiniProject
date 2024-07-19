//
//  ContactTableViewController.swift
//  ContactProject
//
//  Created by 남지연 on 7/17/24.
//

import UIKit
import CoreData

class ContactTableViewController: UITableViewController {
    
    let coreData = CoreDataStack.shared
    var contactInfos: [Contact] = [] {
        didSet {
            contactTableView.reloadData()
        }
    }
    
    let contactTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.title = "연락처"
        self.contactInfos = coreData.getContactDatas()
        self.tableView.reloadData()
        
        setUpTableView()
        makeUI()
        //Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false
        
        //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    func setUpTableView() {
        self.tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.contactInfos = coreData.getContactDatas()
        self.tableView.reloadData()
    }
    
    func makeUI() {
        
        view.addSubview(contactTableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContact))
        
    }
    
    @objc private func addContact() {
        navigationController?.pushViewController(AddContactViewController(), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contactInfos.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as? ContactTableViewCell
        else {
            print("tabelView cellfor init")
            return UITableViewCell()
        }
        let contactCell = contactInfos[indexPath.row]
        cell.configure(contactCell)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = AddContactViewController()
        controller.contact = contactInfos[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // Override to support conditional editing of the table view.
    //    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        // Return false if you do not want the specified item to be editable.
    //        return true
    //    }
    //
    //
    //
    //    // Override to support editing the table view.
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            // Delete the row from the data source
    //            tableView.deleteRows(at: [indexPath], with: .fade)
    //        }
    //    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

