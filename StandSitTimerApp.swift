import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var timer: Timer?
    var isStanding = true
    var lastChange = Date()
    
    let standDuration: TimeInterval = 30 * 60 // 30 minutes
    let sitDuration: TimeInterval = 60 * 60  // 60 minutes
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        updateIcon()
        startTimer()
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))
        statusItem.menu = menu
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.checkState()
        }
    }
    
    func checkState() {
        let now = Date()
        let elapsed = now.timeIntervalSince(lastChange)
        let duration = isStanding ? standDuration : sitDuration
        
        if elapsed >= duration {
            isStanding.toggle()
            lastChange = now
            updateIcon()
        }
    }
    
    func updateIcon() {
        if let button = statusItem.button {
            if isStanding {
                button.image = NSImage(systemSymbolName: "figure.stand", accessibilityDescription: "Stand")
            } else {
                button.image = NSImage(systemSymbolName: "chair", accessibilityDescription: "Sit")
            }
        }
    }
    
    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
