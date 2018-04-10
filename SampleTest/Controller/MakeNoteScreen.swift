//
//  MakeNoteScreen.swift
//  SampleTest
//
//  Created by Apple on 09/04/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class MakeNoteScreen: UIViewController ,UITextViewDelegate{

    // MARK: == IBOutlets  ==

    @IBOutlet weak var txtvwAddNote: UITextView!
    @IBOutlet weak var lblRemainingChars: UILabel!
    
    // MARK: == IBOutlets  ==
    var MaxChar = 300
    var currentNote : EntityNote?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = kMakeNote
        self.loadInitallyScreen()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: == TextView Delegate Methods ==
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        return changedText.count <= MaxChar // it will limit to enter only 300 characters in notes text view
    }
    func textViewDidChange(_ textView: UITextView){
        let len = textView.text.count
        self.lblRemainingChars.text = "\(len)/\(MaxChar)"
    }
    
    // MARK: == Devloper Define Methods ==
    
    func loadInitallyScreen() {
        self.txtvwAddNote.layer.borderWidth = 0.5
        self.txtvwAddNote.layer.borderColor = UIColor.lightGray.cgColor
        self.lblRemainingChars.text = "0/\(MaxChar)"
        if self.currentNote != nil {
            self.txtvwAddNote.text = self.currentNote!.strNotes
            self.lblRemainingChars.text = "\(self.txtvwAddNote.text.count)/\(MaxChar)"
        }
    }
    func saveNoteToServer() {
        if let strNote = self.txtvwAddNote.text , !strNote.isEmpty {
            //Testing without backend

            let singleton = SingleToneClass.shared
            let iNewId = singleton.arrNotes.count + 1
            let newEntity = EntityNote.init(iId: iNewId, strNotes: strNote)
            if currentNote != nil {
                let index = singleton.arrNotes.index(of: self.currentNote!)
                singleton.arrNotes.remove(at: index!)
                singleton.arrNotes.insert(newEntity, at: index!)
            } else {
                singleton.arrNotes.append(newEntity)
            }
            
            NotesWebServices().requestToSaveNote(1, sNote:strNote , successfulHandler: { (response) in
                //Handle Success block
            }) { (strError) in
             //Handle failure block
            }
        } else {
            //Show Empty Note message error
            let alertController = UIAlertController(title: kNotesScreen, message: Error_EmptyNotes, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
    
    }
    
    // MARK: == IBAction Methods ==
    @IBAction func btnSaveTapped(_ sender: Any) {
        //Save notes.
        self.saveNoteToServer()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

@IBDesignable class CustomUIButton: UIButton {
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
}
