//
//  StatusItemPopoverViewController.swift
//  DragPreview
//
//  Created by johankoi on 2021/10/9.
//

import Cocoa


public extension NSPasteboard.PasteboardType {
    static var kUrl: NSPasteboard.PasteboardType {
        return self.init(kUTTypeURL as String)
    }
    static var kFilenames: NSPasteboard.PasteboardType {
        return self.init("NSFilenamesPboardType")
    }
    static var kFileUrl: NSPasteboard.PasteboardType {
        return self.init(kUTTypeFileURL as String)
    }
}


class PopoverContentView: NSView {
    
    var draginFileUrl: String!
    
    
    private var supportFiles = ["ipa","app","xcarchive","mobileprovision"]
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        registerForDraggedTypes([.fileURL])
        handleFile(url: "")
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if let files = sender.draggingPasteboard.propertyList(forType: .kFilenames) as? Array<String> {
            let draginUrl = files[0]
            print("draggingEntered: \(draginUrl)")
            if supportFiles.contains(draginUrl.pathExtension) {
                self.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.7).cgColor;
                return .copy
            } else {
                return NSDragOperation()
            }
        }
        return NSDragOperation()
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo)  {
        print("draggingEnded")
        self.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.15).cgColor;
        
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if let files = sender.draggingPasteboard.propertyList(forType: .kFilenames) as? Array<String> {
            let draginUrl = files[0]
            handleFile(url: draginUrl)
        
            print("performDragOperation: \(draginUrl)")
        }
        return true
    }
    
    private func handleFile(url: String) {
        
        let detailWindow = NSWindow(contentRect: CGRect(x: 0, y: 0, width: 350, height: 500), styleMask: [.closable, .miniaturizable, .titled, .fullSizeContentView], backing: .buffered, defer: false);
        detailWindow.level = .popUpMenu
        detailWindow.titlebarAppearsTransparent = true
        detailWindow.isReleasedWhenClosed = false
        detailWindow.contentViewController = IPADetailViewController(filePath: url)
        detailWindow.makeKeyAndOrderFront(nil);
        detailWindow.center()
    }
    
    
    
}

class StatusItemPopoverViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
  
}
