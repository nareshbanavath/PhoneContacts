//
//  ViewController.swift
//  PhoneContacts
//
//  Created by naresh banavath on 06/04/21.
//

import UIKit
import ContactsUI



class ViewController: UIViewController {
  var phoneContacts : [PhoneContact] = []
  
  
  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    // var phoneContacts = [PhoneContact]() // array of PhoneContact(It is model find it below)
    var filter: ContactsFilter = .none
    
    self.loadContacts(filter: filter) // Calling loadContacts methods
    //print(phoneNumberWithContryCode())
    
  }
  func phoneNumberWithContryCode() -> [String] {
    
    let contacts = PhoneContacts.getContacts() // here calling the getContacts methods
    var arrPhoneNumbers = [String]()
    for contact in contacts {
      for ContctNumVar: CNLabeledValue in contact.phoneNumbers {
        if let fulMobNumVar  = ContctNumVar.value as? CNPhoneNumber {
          //let countryCode = fulMobNumVar.value(forKey: "countryCode") get country code
          if let MccNamVar = fulMobNumVar.value(forKey: "digits") as? String {
            arrPhoneNumbers.append(MccNamVar)
          }
        }
      }
    }
    return arrPhoneNumbers // here array has all contact numbers.
  }
  //
  fileprivate func loadContacts(filter: ContactsFilter) {
    phoneContacts.removeAll()
    var allContacts = [PhoneContact]()
    for contact in PhoneContacts.getContacts(filter: filter) {
      allContacts.append(PhoneContact(contact: contact))
    }
    
    var filterdArray = [PhoneContact]()
    if filter == .mail{
      filterdArray = allContacts.filter({ $0.email.count > 0 }) // getting all email
    } else if filter == .message {
      filterdArray = allContacts.filter({ $0.phoneNumber.count > 0 })
    } else {
      filterdArray = allContacts
    }
    phoneContacts.append(contentsOf: filterdArray)
   // let groupedValues = Dictionary(grouping: allContacts, by: {$0.name.prefix()})
//    for contact in phoneContacts {
//      print("Name -> \(contact.name)")
//      print("Email -> \(contact.email)")
//      print("Phone Number -> \(contact.phoneNumber)")
//    }
    //    let arrayCode  = self.phoneNumberWithContryCode()
    //    for codes in arrayCode {
    //      print(codes)
    //    }
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
    
  }
}
extension ViewController : UITableViewDelegate , UITableViewDataSource
{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return phoneContacts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? PhoneContactTableViewCell else {return UITableViewCell()}
    cell.nameLb?.text = phoneContacts[indexPath.row].name
    cell.contactNumLb.text = phoneContacts[indexPath.row].phoneNumber.reduce("", +)
    
    
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let phoneContact = phoneContacts[indexPath.row]
    var txt1 : UITextField?
    var txt2 : UITextField?
    let alertController = UIAlertController(title: "Edit Contact", message: "", preferredStyle: .alert)
    alertController.addTextField { (txtField1) in
      txtField1.text = phoneContact.name
      txt1 = txtField1
      print("textfield1")
    }
    alertController.addTextField { (txtField2) in
      txtField2.text = phoneContact.phoneNumber.reduce("", +)
      txt2 = txtField2
      print("textfield2")
    }
    alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { [self] (action) in
      saveContact(name: (txt1?.text)!, phoneNumber: txt2?.text ?? "default")
    }))
    present(alertController, animated: true){
   
    }
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  //MARK:- Save Contact
  func saveContact(name : String , phoneNumber : String)
  {
    // print("Save Clicked \(txt1?.text) \(txt2?.text)")
    let store = CNContactStore()
    let predicate = CNContact.predicateForContacts(matchingName: name)
    let toFetch = [CNContactPhoneNumbersKey , CNContactGivenNameKey]
    do{
      let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: toFetch as [CNKeyDescriptor])
      for contact in contacts
      {
        let mutableCpy = contact.mutableCopy() as! CNMutableContact
        print(mutableCpy.phoneNumbers.count)
        print(mutableCpy.givenName)
        mutableCpy.phoneNumbers[0] = CNLabeledValue(label: CNLabelPhoneNumberiPhone, value: CNPhoneNumber(stringValue: phoneNumber))
        let req = CNSaveRequest()
        req.update(mutableCpy)
        try store.execute(req)
      }
      
    }catch let err
    {
      print(err.localizedDescription)
    }
    self.loadContacts(filter: .none)
    
  }
  
  
  
}



