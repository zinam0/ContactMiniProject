//
//  CoreDataStack.swift
//  ContactProject
//
//  Created by 남지연 on 7/17/24.
//
import UIKit
import CoreData
//⭐️CoreData
enum CoreDataError: Error {
    case contextError(String)
    case saveError(String, underlyingError: Error)
}

/*
 NSManagerObjectModel:.xcdatamodeld객체를 설명하는 파일(ContactProject)
 https://developer.apple.com/documentation/coredata/nsmanagedobjectmodel
 Interface Builder에서 UI 생성 제한
 런타임 시 속성 및 관계 값 검증
 개체 지속성을 위한 관리 개체와 데이터베이스 또는 파일 기반 스키마 간 매핑
 
 entity 열거형으로 사용가능 / 모델 변경(migration)
 */

class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    private init(){ }
    
    //앱 델리게이트
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    //임시 저장
    lazy var context = appDelegate?.persistentContainer.viewContext
    //Core data save object 'entity' name
    let modelName: String = "Contact"
    
}

extension CoreDataStack {
    
    func getContactDatas() -> [Contact] {

        //NSFetchRequest의 제네릭 타입을 Contact로 수정
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            return try context!.fetch(request)
        } catch {
            print("Failed to fetch contacts: \(error)")
            return []
        }
    }

    func saveContext() {
        if ((context?.hasChanges) != nil) {
        do {
            try context!.save()
        } catch {
          fatalError(#function)
        }
      }
    }
    
    func saveContactData(contact: Contact) throws {
        guard let context = context else {
            throw CoreDataError.contextError("Failed to retrieve context")
        }
        context.insert(contact)
        saveContext()
    }

    func updateData(name: String, contact: Contact) {
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
          let contacts = try context!.fetch(fetchRequest)
          for contact in contacts {
              contact.name = contact.name
              contact.number = contact.number
              contact.imageUrl = contact.imageUrl
          }
          saveContext()
        } catch {
          print("\(error)")
        }
    }
}
