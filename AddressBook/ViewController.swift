//
//  ViewController.swift
//  AddressBook
//
//  Created by Elmira on 03.08.21.
//

import UIKit
import Contacts

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var contactStore = CNContactStore()
    var contacts = [ContactStruct]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AddressBook"
        navigationController?.navigationBar.tintColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        contactStore.requestAccess(for: CNEntityType.contacts) { (success, error) in
            if success {
                print("Authorization successfull")
            }
        }
        getContacts()
    }
    func getContacts() {
        let key = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: key)
        do{
        try! contactStore.enumerateContacts(with: request) { (contact, pointer) in
            let name = contact.givenName
            let familyName = contact.familyName
            let number = contact.phoneNumbers.first?.value.stringValue
            
            let contactToAppend = ContactStruct(name: name, familyName: familyName, number: number ?? "")
            self.contacts.append(contactToAppend)
        }
            tableView.reloadData()
        }catch{
            print(error)
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text =  contacts[indexPath.row].name  + " " + "/" + " " + contacts[indexPath.row].number
        //contacts[indexPath.row].familyName + " " + " "  +
        if indexPath.row%2==0{
            cell.backgroundColor = .gray
        }else{
            cell.backgroundColor = .white
        }
        cell.textLabel!.font = UIFont(name: "Courier-bold", size:18 )

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(contacts[indexPath.row].number)
        let numberString = contacts[indexPath.row].number.replacingOccurrences(of: " ", with: "")
        print(numberString)
        guard let url = URL(string: "telprompt://\(numberString)") else {return}
        UIApplication.shared.open(url)
    }
}
