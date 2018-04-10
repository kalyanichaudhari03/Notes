//
//  ViewController.swift
//  SampleTest
//
//  Created by Apple on 09/04/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

     // MARK: == IBOUTLETS ==
    @IBOutlet weak var tblvwNotes: UITableView!
    
    
    // MARK: == Variables ==
    lazy var arrNotes = [EntityNote]()
    var selectedNote : EntityNote?
    
    // MARK: == Life Cycle ==
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationHeader()
        self.getNotesFromServer()
        self.tblvwNotes.removeEmptyCells()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        let singleton = SingleToneClass.shared
        self.arrNotes = singleton.arrNotes
        self.tblvwNotes.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: == Devloper Define Methods ==
    func setNavigationHeader() {
        self.title = kNotesScreen
        let btnRight = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.openMakeNotesScreen))
        self.navigationItem.rightBarButtonItem = btnRight
    }

    @objc func openMakeNotesScreen(){
        self.performSegue(withIdentifier: Segue_ToNotesScreen, sender: self)
    }
    
    func getNotesFromServer(){
        NotesWebServices().requestToGetNotesList({ (response) in
            self.arrNotes = response
            let singleton = SingleToneClass.shared
            singleton.arrNotes = self.arrNotes
            self.tblvwNotes.reloadData()
        }) { (strMessage) in
            //Show Error
        }
    }
    
    
     // MARK: == TableView Delegate & DataSource Methods ==
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        if self.arrNotes.count > indexPath.row {
            cell.textLabel?.text = self.arrNotes[indexPath.row].strNotes
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.arrNotes.count > indexPath.row {
         selectedNote = self.arrNotes[indexPath.row] as? EntityNote
         self.performSegue(withIdentifier: Segue_ToNotesScreen, sender: self)
        }
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if  segue.identifier ==  Segue_ToNotesScreen {
            let vc = segue.destination as? MakeNoteScreen
            vc?.currentNote = selectedNote
        }
     }
 
}

extension UITableView {
    
    func removeEmptyCells() {
    self.tableFooterView = UIView.init(frame: CGRect.zero)
    self.tableFooterView?.isHidden = false
    }
}

