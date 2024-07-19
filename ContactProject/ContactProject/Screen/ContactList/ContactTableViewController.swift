//
//  ContactTableViewController.swift
//  ContactProject
//
//  Created by 남지연 on 7/17/24.
//

import UIKit
import CoreData

class ContactTableViewController: UITableViewController, UITableViewDragDelegate, UITableViewDropDelegate {
    
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
        self.tableView.dragDelegate = self
        self.tableView.dropDelegate = self
        self.tableView.dragInteractionEnabled = true
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
    
    
    //Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        //return false - 수정 및 삭제가 불가능함
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let contactToDelete = contactInfos[indexPath.row]
            contactInfos.remove(at: indexPath.row)
            coreData.deleteContact(contact: contactToDelete)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedContact = contactInfos.remove(at: fromIndexPath.row)
        contactInfos.insert(movedContact, at:  to.row)
    }
    //Override to support conditional rearranging of the table view.
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        //Return false if you do not want the item to be re-orderable.
        return true
    }
    //드래그 시작될 때 호출되는 함수
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let contact = contactInfos[indexPath.row]
        if let name = contact.name {
            let itemProvider = NSItemProvider(object: contact.name! as NSString)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = contact
            return [dragItem]
        }
        return [UIDragItem]()
    }
    
    //드롭이 수행될 떄 호출
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard coordinator.proposal.operation == .move,
              let item = coordinator.items.first,
              let sourceIndexPath = item.sourceIndexPath else { return }
        
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(row: contactInfos.count - 1, section: 0)
        
        tableView.performBatchUpdates({
            let movedContact = contactInfos.remove(at: sourceIndexPath.row)
            contactInfos.insert(movedContact, at: destinationIndexPath.row)
            tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
        }, completion: nil)
        
        coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
    }
    
    //드롭 세션 처리할 수 있는지 확인 유무
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    //드롭 세션 업데이트될 때 호출
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

