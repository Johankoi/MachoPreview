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
    @IBOutlet weak var displayNameLabel: NSTextField!
    @IBOutlet weak var versonLabel: NSTextField!
    @IBOutlet weak var bundleIdLabel: NSTextField!
    
    
    init(filePath: String) {
        super.init(nibName: nil, bundle: nil)
        self.filePath = filePath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.layer?.backgroundColor = NSColor.white.cgColor
        view.layer?.backgroundColor = NSColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0).cgColor
        
        let budleId = Bundle.main.bundleIdentifier ?? "dragpreview.working.place"
        let baseFolder = try! Folder.temporary.createSubfolder(named: budleId + "/\(UUID().uuidString)")
        let tempFolder = try! baseFolder.createSubfolder(named: "temp")
        let targetFile = "/Users/johankoi/Downloads/sanguo1.ipa"
        
        let arguments = ["-u", "-j", "-d", tempFolder.path, targetFile, "Payload/*.app/embedded.mobileprovision", "Payload/*.app/Info.plist"]
        
        let codesignTask = runAsync("/usr/bin/unzip", arguments).onCompletion { command in
            
            let infoPlist = PropertyListProcessor(with: tempFolder.path + "Info.plist")
            
            // iconImage
            if let iconName = infoPlist.content.iconName {
                let readIconargs = ["-p", targetFile, "Payload/*.app/" + iconName]
                let readIconImageTask = runAsync("/usr/bin/unzip", readIconargs).onCompletion { command in
                    DispatchQueue.main.async {
                        let data = command.stdout.readData()
                        self.iconImageView.image = NSImage(data: data)
                    }
                }
                do {
                    try readIconImageTask.finish()
                } catch {
                    print("readIconImageTask err \(readIconImageTask.stderror)")
                }
            }
            
            self.displayNameLabel.stringValue = infoPlist.content.bundleDisplayName
            self.versonLabel.stringValue = "版本: " + infoPlist.content.bundleVersionShort
            self.bundleIdLabel.stringValue = "Bundle ID: " + infoPlist.content.bundleIdentifier
        }
        do {
            try codesignTask.finish()
        } catch {
            //  NSWorkspace.shared.open(URL(fileURLWithPath: "x-apple.systempreferences:com.apple.preference.security?Privacy_Assistive"))
            print("unzip err \(codesignTask.stderror)")
        }
    }
    
}
