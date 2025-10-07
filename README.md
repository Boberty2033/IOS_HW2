# IOS_HW2

Question 1: What issues prevent us from using storyboards in real projects?

Storyboards are not ideal for large or team-based projects because:

They create merge conflicts in Git — they’re XML files, hard to merge.

They make modularization and dependency injection more difficult.

They slow down build times for large projects.

You can’t easily reuse UI components across multiple modules.
Building the UI programmatically gives you full control, better reusability, and easier maintenance.



Question 2: What does the code on lines 25 and 29 do?
title.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(title)


translatesAutoresizingMaskIntoConstraints = false disables automatic layout translation, allowing manual Auto Layout constraints.

view.addSubview(title) adds the UILabel to the main view hierarchy so it becomes visible.



Question 3: What is a safe area layout guide?

The safe area layout guide represents the visible area of the screen that’s not covered by the notch, status bar, or home indicator.
Anchoring views to it ensures UI elements are not hidden or obstructed on different devices.



Question 4: What is [weak self] on line 23 and why is it important?

[weak self] prevents strong reference cycles (retain cycles) between the view controller and the closure.
Without it, the closure would keep the controller in memory even after it’s dismissed, causing a memory leak.
With [weak self], the closure references self weakly, allowing it to be properly deallocated.



Question 5: What does clipsToBounds mean?

clipsToBounds defines whether subviews are restricted to the parent’s visible area.
If set to true, any part of a subview that lies outside the parent view’s frame will not be displayed.
Commonly used for rounded corners, scrollable areas, or masking.



Question 6: What is the valueChanged type? What is Void and what is Double?
var valueChanged: ((Double) -> Void)?


This means:

The closure takes a Double parameter — the new slider value.

Returns Void, which means it doesn’t return any value.

So it’s a callback that notifies when the slider’s value changes, passing the new value.
