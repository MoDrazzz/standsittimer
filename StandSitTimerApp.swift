import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var timer: Timer?
    var isStanding = true
    var lastChange = Date()
    
    let standDuration: TimeInterval = 30 * 60 // 30 min
    let sitDuration: TimeInterval = 60 * 60  // 60 min
    
    // Menu items
    let timeRemainingItem = NSMenuItem(title: "Time Remaining: --:--", action: nil, keyEquivalent: "")
    let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Menu bar icon
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        updateIcon()
        
        // Menu
        let menu = NSMenu()
        menu.addItem(timeRemainingItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(quitItem)
        statusItem.menu = menu
        
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.checkState()
            self.updateTimeRemaining()
        }
        updateTimeRemaining() // update immediately on launch
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
    
    func updateTimeRemaining() {
        let now = Date()
        let elapsed = now.timeIntervalSince(lastChange)
        let duration = isStanding ? standDuration : sitDuration
        let remaining = max(0, Int(duration - elapsed))
        
        let minutes = remaining / 60
        let seconds = remaining % 60
        let phase = isStanding ? "Standing" : "Sitting"
        
        timeRemainingItem.title = "Time Remaining (\(phase)): \(String(format: "%02d:%02d", minutes, seconds))"
    }
    
    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
