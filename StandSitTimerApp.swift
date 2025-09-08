import Cocoa

// Time in minutes
let STAND_DURATION_MINUTES: TimeInterval = 30
let SIT_DURATION_MINUTES: TimeInterval = 60

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var timer: Timer?
    var isStanding = true
    var lastChange = Date()
    
    let standDuration: TimeInterval = STAND_DURATION_MINUTES * 60 // Convert minutes to seconds
    let sitDuration: TimeInterval = SIT_DURATION_MINUTES * 60   // Convert minutes to seconds
    
    // Menu items
    let timeRemainingItem = NSMenuItem(title: "Time Remaining: --", action: nil, keyEquivalent: "")
    let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        updateIcon()
        
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
        updateTimeRemaining()
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
            button.image = NSImage(systemSymbolName: isStanding ? "figure.stand" : "chair",
                                    accessibilityDescription: isStanding ? "Stand" : "Sit")
        }
    }
    
    func updateTimeRemaining() {
        let now = Date()
        let elapsed = now.timeIntervalSince(lastChange)
        let duration = isStanding ? standDuration : sitDuration
        let remainingSeconds = max(0, Int(duration - elapsed))
        
        let remainingText: String
        if remainingSeconds >= 3600 {
            let hours = remainingSeconds / 3600
            remainingText = hours == 1 ? "1 hour" : "\(hours) hours"
        } else {
            let minutes = max(1, remainingSeconds / 60) // round up to at least 1 minute
            remainingText = minutes == 1 ? "1 minute" : "\(minutes) minutes"
        }
        
        let phase = isStanding ? "Standing" : "Sitting"
        timeRemainingItem.title = "Time Remaining (\(phase)): \(remainingText)"
    }
    
    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
