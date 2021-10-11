//
//  SavedBooksController.swift
//  DrawPrototyp
//
//  Created by Andreas Zikovic on 2018-06-18.
//  Copyright © 2018 Andreas Zikovic. All rights reserved.
//

import UIKit

class SavedBooksController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var createNewBook: UITextField!
    @IBOutlet weak var bookTableView: UITableView!
    
    static var library = [Book]()
    var createBook = Book()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(self.cancelClicked))
        toolBar.setItems([doneButton,space,cancelButton], animated: false)
        createNewBook.inputAccessoryView = toolBar
        
        // Load saved data.
        DataManager.sharedInstance.load()
    }
    
    @IBAction func addNewBookButton(_ sender: UIButton) {
        createNewBook.becomeFirstResponder()
    }
    
    @objc func doneClicked() {
        createBook = Book()
        createBook.bookTitle = createNewBook.text!
        SavedBooksController.library.append(createBook)
        view.endEditing(true)
        createNewBook.text = ""
        self.bookTableView.reloadData()
        
        DataManager.sharedInstance.save()
    }

    @objc func cancelClicked() {
        view.endEditing(true)
        createNewBook.text = ""
    }

    @IBAction func createNewBookPressed(_ sender: UITextField) {}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (SavedBooksController.library.count == 0) {
            return 1
        } else {
            return SavedBooksController.library.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (SavedBooksController.library.count == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "standardCell")
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell") as! BookTableViewCell
            cell.bookTitleLabel.text = SavedBooksController.library[indexPath.row].bookTitle
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (SavedBooksController.library.count == 0) {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (SavedBooksController.library.count == 0) {
            return
        } else {
            performSegue(withIdentifier: "showbook", sender: SavedBooksController.library [indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        SavedBooksController.library.remove(at: indexPath.row)
        self.bookTableView.reloadData()
        DataManager.sharedInstance.save()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showbook") {
            let dest = segue.destination as! CanvasViewController
            dest.book = sender as? Book
        }
    }
}
