//
//  IPADetailViewController.swift
//  DragPreview
//
//  Created by johankoi on 2021/10/13.
//

import Cocoa
import Files
import SwiftShell

class IPADetailViewController: NSViewController {

    public var filePath: String = ""
    @IBOutlet weak var headerView: NSView!
    @IBOutlet weak var iconImageView: NSImageView!
    

    init(filePath: String) {
        super.init(nibName: nil, bundle: nil)
        self.filePath = filePath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pl1 = PropertyListProcessor(with: Bundle.main.path(forResource: "test_Info1", ofType: "plist") ?? "")
        let pl2 = PropertyListProcessor(with: Bundle.main.path(forResource: "test_Info2", ofType: "plist") ?? "")
        let icon1 = pl1.content.bundleIconFiles
        let icon2 = pl2.content.bundleIcons
        
        
        
        headerView.layer?.backgroundColor = NSColor.white.cgColor
        view.layer?.backgroundColor = NSColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0).cgColor
        
        let budleId = Bundle.main.bundleIdentifier ?? "dragpreview.working.place"
        let baseFolder = try! Folder.temporary.createSubfolder(named: budleId + "/\(UUID().uuidString)")
        let tempFolder = try! baseFolder.createSubfolder(named: "temp")

        let arguments = ["-u", "-j", "-d", tempFolder.path, "/Users/johankoi/Downloads/sanguo1.ipa", "Payload/*.app/embedded.mobileprovision", "Payload/*.app/Info.plist"]
        
        let codesignTask = runAsync("/usr/bin/unzip", arguments).onCompletion { command in
            
          
            
            
        }
        do {
            try codesignTask.finish()
        } catch {
//                    NSWorkspace.shared.open(URL(fileURLWithPath: "x-apple.systempreferences:com.apple.preference.security?Privacy_Assistive"))
            print("unzip err \(codesignTask.stderror)")
        }
   
        
    }
    
}
