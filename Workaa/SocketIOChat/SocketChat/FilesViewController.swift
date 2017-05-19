//
//  FilesViewController.swift
//  Workaa
//
//  Created by IN1947 on 09/05/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class FilesViewController: UIViewController, ConnectionProtocol, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tblfileslist: UITableView!
    
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()
    var groupdictionary = NSDictionary()
    var filesmsgArray = NSArray()
    var userdictionary = NSDictionary()
    var chattype = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Files"
        
        connectionClass.delegate = self
        
        commonmethodClass.delayWithSeconds(0.1, completion: {
            self.getFilesList()
        })
        
        tblfileslist.register(UINib(nibName: "FilesTableViewCell", bundle: nil), forCellReuseIdentifier: "IdCellFiles")
    }

    func getFilesList()
    {
        if chattype == "DirectChat"
        {
            connectionClass.getDirectFilesList(uid: String(format: "%@", userdictionary.value(forKey: "id") as! CVarArg))
        }
        else if chattype == "CafeChat"
        {
            connectionClass.getCafeFilesList()
        }
        else
        {
            connectionClass.getFilesList(groupid: String(format: "%@", groupdictionary.value(forKey: "id") as! CVarArg))
        }
    }
    
    // MARK: - Connection Delegate
    
    func GetFailureReponseMethod(errorreponse: String)
    {
        print("GetFailureReponseMethod")
    }
    
    func GetReponseMethod(reponse : NSDictionary)
    {
        print("reponse => \(reponse)")
        
        if let getreponse = reponse.value(forKey: "data") as? NSDictionary
        {
            if let fileslist = getreponse.value(forKey: "messageList") as? NSArray
            {
                filesmsgArray = fileslist
                
                print("filesmsgArray =>\(filesmsgArray.count)")
                
                tblfileslist.reloadData()
            }
        }
    }
    
    // MARK: UITableView Delegate and Datasource Methods
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filesmsgArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdCellFiles", for: indexPath) as! FilesTableViewCell
        
        let filedictionary = filesmsgArray[indexPath.row] as! NSDictionary
        let filedict = filedictionary.value(forKey: "file") as! NSDictionary
        let filestring = String(format: "%@",filedict.value(forKey: "title") as! CVarArg)
        
        cell.filetile.text = filestring
        
        var fileextstring = String(format: "%@",filedict.value(forKey: "ext") as! CVarArg)
        fileextstring = fileextstring.lowercased()
        if fileextstring == "jpg" || fileextstring == "jpeg" || fileextstring == "png" || fileextstring == "gif" || fileextstring == "pneg"
        {
            cell.fileiconimage.image = UIImage(named: "image.png")
        }
        else if fileextstring == "doc" || fileextstring == "docx" || fileextstring == "txt" || fileextstring == "log" || fileextstring == "odt" || fileextstring == "rtf"
        {
            cell.fileiconimage.image = UIImage(named: "documents.png")
        }
        else if fileextstring == "xls" || fileextstring == "xlsx" || fileextstring == "xlr" || fileextstring == "csv"
        {
            cell.fileiconimage.image = UIImage(named: "excel.png")
        }
        else if fileextstring == "mp3" || fileextstring == "m4a" || fileextstring == "wav" || fileextstring == "mpa"
        {
            cell.fileiconimage.image = UIImage(named: "music.png")
        }
        else if fileextstring == "avi" || fileextstring == "flv" || fileextstring == "m4v" || fileextstring == "mov" || fileextstring == "mp4" || fileextstring == "wmv" || fileextstring == "3g2" || fileextstring == "3gp" || fileextstring == "rm"
        {
            cell.fileiconimage.image = UIImage(named: "movie.png")
        }
        else if fileextstring == "avi" || fileextstring == "flv" || fileextstring == "m4v" || fileextstring == "mov" || fileextstring == "mp4" || fileextstring == "wmv" || fileextstring == "3g2" || fileextstring == "3gp" || fileextstring == "rm"
        {
            cell.fileiconimage.image = UIImage(named: "movie.png")
        }
        else if fileextstring == "pdf"
        {
            cell.fileiconimage.image = UIImage(named: "pdf.png")
        }
        else if fileextstring == "html" || fileextstring == "htm" || fileextstring == "css" || fileextstring == "scss" || fileextstring == "php" || fileextstring == "asp" || fileextstring == "aspx" || fileextstring == "py" || fileextstring == "js" || fileextstring == "cer"
        {
            cell.fileiconimage.image = UIImage(named: "back-end-coding.png")
        }
        else if fileextstring == "fon" || fileextstring == "otf" || fileextstring == "ttf" || fileextstring == "fnt"
        {
            cell.fileiconimage.image = UIImage(named: "fonts.png")
        }
        else if fileextstring == "c" || fileextstring == "m" || fileextstring == "pl" || fileextstring == "swift" || fileextstring == "vb" || fileextstring == "java" || fileextstring == "class" || fileextstring == "cpp" || fileextstring == "cs"
        {
            cell.fileiconimage.image = UIImage(named: "front-end-coding.png")
        }
        else if fileextstring == "apk" || fileextstring == "app" || fileextstring == "exe" || fileextstring == "jar"
        {
            cell.fileiconimage.image = UIImage(named: "exe.png")
        }
        else if fileextstring == "indd" || fileextstring == "ai" || fileextstring == "eps" || fileextstring == "psd"
        {
            cell.fileiconimage.image = UIImage(named: "indesign.png")
        }
        else if fileextstring == "ppt" || fileextstring == "pptx" || fileextstring == "pps"
        {
            cell.fileiconimage.image = UIImage(named: "ppt.png")
        }
        else if fileextstring == "zip" || fileextstring == "7z" || fileextstring == "rar" || fileextstring == "pkg" || fileextstring == "tar" || fileextstring == "gz" || fileextstring == "zipx"
        {
            cell.fileiconimage.image = UIImage(named: "zip.png")
        }
        else
        {
            cell.fileiconimage.image = UIImage(named: "unknown.png")
        }
        
        if let username = filedictionary.value(forKey: "username") as? String
        {
            cell.fileusername.text = username
        }
        else
        {
            cell.fileusername.text = ""
        }
        
        var UserNametextwidth = commonmethodClass.widthOfString(usingFont: (cell.fileusername?.font!)!, text: cell.fileusername.text! as NSString)
        UserNametextwidth = ceil(UserNametextwidth)
        cell.fileusernamewidth.constant = UserNametextwidth + 5.0
        
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useAll
        let filesize = formatter.string(fromByteCount: Int64(filedict.value(forKey: "size") as! NSInteger))
        
        cell.filesize.text = String(format: "%@ %@ file",filesize, filedict.value(forKey: "ext") as! CVarArg)
        
        if let time = filedictionary.value(forKey: "time") as? String
        {
            cell.filetime.text = String(format: "%@ at %@", commonmethodClass.convertDateInCell(date: time), commonmethodClass.convertDateFormatter(date: time))
        }
        else
        {
            cell.filetime.text = ""
        }
        
        let starred = String(format: "%@", filedictionary.value(forKey: "starred") as! CVarArg)
        if starred == "0"
        {
            cell.starimage.isHidden = true
        }
        else
        {
            cell.starimage.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
