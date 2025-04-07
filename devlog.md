# Dev Log

This file is for rambling thoughts and notes during development.

# 07/04/25

After trying with Flutter, I've decided to try again with SwiftUI.

In practice, I just want to make an app that allows me to track my habits 
and the only platform I'll really use is iOS.

I'm going to use cursor to write as much of the code as possible.

Just wiping out the repo and starting again.

# 24/02/25

Starting on the next section of the tutorial: https://developer.apple.com/tutorials/swiftui/building-lists-and-navigation

Ok. I'm quite liking swift, I'm not gonna lie.

This tutorial was great and I really took time to soak it in.

The fact that device previews are available for things like iPhone and iPad is really cool. 
It's super nice to just get the iPad view pretty much for free. I'm really liking this. There
is very little boilerplate code. It's just a case of defining what I want to exist. 

Nice.

This one next: https://developer.apple.com/tutorials/swiftui/handling-user-input

# 23/02/25

Continuing with: https://developer.apple.com/tutorials/swiftui/creating-and-combining-views

Having some teething problems trying to work out best way to develop. Xcode has no integrated terminal which I am very much used to.
I'd like to see if I can continue to use VSCode.

Anyways, I'm just gonna carry on as is for now and get through the tutorial.

In `Xcode`, quite cool. On the Canvas choose selector mode (mouse cursor) then `Ctrl`+`Cmd`+Click an element and view the inspector. 
You can then change attributes in a UI that will also edit the code.

# 22/02/25

Didn't really start anything so going to start again and follow the apple developer tutorial here:
https://developer.apple.com/tutorials/swiftui/

## Creating a Project

In Xcode I created a new `iOS 18` project in the local directory in `Landmarks/`. The `iOS 18.3.1` Simulator is now downloading.

I'm going to pause for now and then carry this on later.

## Software Updates

My enthusiasm was halted when I had to perform a software update on my phone and mac. Not to worry I thought.
Unforunately, my phone did not have enough free storage to perform the software update so I spent ages deleting loads of WhatsApp
videos to make space. Eventually, we got there in the end.

I can now connect my iPhone to my MacBook, open Xcode and build the project directly to an app on my iPhone.
I had to go into the iPhone settings and whitelist myself as a developer but yeah, we're there. It's quite
nifty in all honesty. I like that I can develop with the simulator, see the results in realtime, and then periodically build the
app onto my iPhone and have the results shown in near-realtime. Decent.

Right, onwards with the tutorial then.

# 20/02/25

Ran:

```bash
swift package init --type executable
```