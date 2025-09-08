# StandSitTimer

This app helps you keep a healthy work routine by reminding you when to stand and when to sit. It sits in the macOS menu bar, showing an icon for standing or sitting. When you click the icon, it shows how much time is left in the current period. You can follow your schedule without having to watch the clock.

<img width="299" height="95" alt="image" src="https://github.com/user-attachments/assets/1a864d88-145c-4f47-b078-feb958a832e0" />

## Running the application

Simply double-click `StandSitTimer.app`. Swift file is there just for the source-code modifications.

## Settings

Default values:

- Sitting: **60 minutes**
- Standing: **30 minutes**

To modify, enter `StandSitTimerApp.swift` file and adjust for your needs. Time periods are exported as global variables in the first few lines of the script, to make it easier to modify them.

To build for `.app`, run the following command (being in project's root directory):

```bash
npm run build
```
