//
//  AppDelegate.swift
//  DragPreview
//
//  Created by johankoi on 2021/10/9.
//

import Cocoa
import Popover


class MyPopoverConfiguration: DefaultConfiguration {
    override var backgroundColor: NSColor {
        return NSColor.black.withAlphaComponent(0.15)
    }
    override var borderColor: NSColor? {
        return NSColor.clear
    }
    
    override var borderWidth: CGFloat {
        return 0
    }
    override var arrowHeight: CGFloat {
        return 0
    }
    override var arrowWidth: CGFloat {
        return 0
    }
    override var popoverToStatusItemMargin: CGFloat {
        return 5
    }
}


@main
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    var popover: Popover!
    var popoverIsShow: Bool = false
    
    @objc func quitApp(_ sender: AnyObject) {
        NSApplication.shared.terminate(self)
    }

    @objc func togglePopover(_ sender: AnyObject) {
        if popoverIsShow == false {
            popover.show()
        } else {
            popover.dismiss()
        }
        popoverIsShow = !popoverIsShow
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name("statusIcon"))
            button.action = #selector(togglePopover)
            
            let viewController = StatusItemPopoverViewController()
            
            let menuItems: [Popover.MenuItemType] = [
                .item(Popover.MenuItem(title: "Settings", action: {
                    
                })),
                .separator,
                .item(Popover.MenuItem(title: "Quit", key: "q", action: {
                    
                }))
            ]
            
            popover = Popover(with: MyPopoverConfiguration(), menuItems: menuItems)
            popover.keepPopoverVisible = true
            popover.prepare(with: button, contentViewController: viewController)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

