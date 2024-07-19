//
//  AddContactViewController.swift
//  ContactProject
//
//  Created by 남지연 on 7/17/24.
//

import UIKit

class AddContactViewController: UIViewController {
    
    let api = APIManager.shared
    let coreData = CoreDataStack.shared
    
    var contact: Contact?
    static let profileSize:CGFloat = 200
    
    public lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = AddContactViewController.profileSize * 0.5
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let nameTextField: UITextField = {
        let textField = UITextField()
        //placeHolder
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        
        textField.attributedPlaceholder = NSAttributedString(string: "이름을 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, .paragraphStyle: centeredParagraphStyle])
        
        //textField
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textField.layer.borderWidth = 1
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.clearsOnBeginEditing = false
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    public let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        //placeHolder
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        textField.attributedPlaceholder = NSAttributedString(string: "번호를 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, .paragraphStyle: centeredParagraphStyle])
        
        //textField
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textField.layer.borderWidth = 1
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.clearsOnBeginEditing = false
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let randomButton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성하기", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(randomImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigation UI
        self.title = contact == nil ? "새로운 연락처" : contact?.name
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveContextButtonTapped))
        
        //delegate
        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
        
        //UI
        makeUI()
        
        //noti
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //data
        setUpData()
    }
        
    private func setUpData() {
        guard let contact = contact else { return }
        profileImageView.image = UIImage(data: contact.imageUrl!)
        nameTextField.text = contact.name
        phoneNumberTextField.text = contact.number
    }
    
    private func makeUI() {
        
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        [
            profileImageView,
            nameTextField,
            phoneNumberTextField,
            randomButton
        ].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: AddContactViewController.profileSize),
            profileImageView.heightAnchor.constraint(equalToConstant: AddContactViewController.profileSize),
            
            randomButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 25),
            randomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: randomButton.bottomAnchor, constant: 80),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalToConstant: 270),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            phoneNumberTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 30),
            phoneNumberTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneNumberTextField.widthAnchor.constraint(equalToConstant: 270),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc public func saveContextButtonTapped() {
        
        guard let name = nameTextField.text, !name.isEmpty,
              let number = phoneNumberTextField.text, !number.isEmpty,
              let image = profileImageView.image?.pngData(),
              let context = coreData.context else { return }
        
        if let contact = contact {
            contact.name = name
            contact.number = number
            contact.imageUrl = image
        } else {
            let contact = Contact(context: context)
            contact.name = name
            contact.number = number
            contact.imageUrl = image
            do {
                try coreData.saveContactData(contact: contact)
            } catch {
                print("error not save \(error)")
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func randomImageButtonTapped() {
        Task {
            do {
                let image = try await api.loadRandomPokemonImage()
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            } catch {
                print("Error loading random Pokemon image: \(error)")
                // Handle error, e.g., show alert to the user
            }
        }
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -150
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }
}

extension AddContactViewController: UITextFieldDelegate {
    
    //다음 동작 허락
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameTextField.text != "", phoneNumberTextField.text != "" {  //사임
            phoneNumberTextField.resignFirstResponder()
            return true
        } else if nameTextField.text != "" {    //다음 텍스트필드 넘어가도록
            phoneNumberTextField.becomeFirstResponder()
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneNumberTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
    }
    
}




/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


