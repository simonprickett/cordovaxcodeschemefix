# Cordova Xcode Scheme Fix

Uses a Cordova build hook to set up Xcode schemes enabling iOS workflow without ever opening Xcode.

## Problem

If you use the Cordova CLI to create a new Cordova project, then you add the iOS platform to that project you can develop for iOS and use the Cordova CLI to launch the iOS Simulator and view your app during development.

However, if you try and build your app using the xcodebuild command line tools (without ever going into Xcode itself) you will find that the xcodebuild tools hang.

This is because by default, Cordova CLI created Xcode projects don't contain schemes... XCode configures these on first launch of a project.  However, these are then saved in files that live inside platforms/ios in your Cordova project, and you don't want to check platforms into source control as everything in there should be auto generated.

This repo shows a simple solution for this that allows Cordova projects to play more nicely in a Continuous Integration workflow.

## Solution

Use the Ruby Gem ["xcodeproj"](https://rubygems.org/gems/xcodeproj) and a [Cordova Hook](https://cordova.apache.org/docs/en/5.1.1/guide/appdev/hooks/index.html) to fix the Xcode project to have schemes, making it then work with xcodebuild.  We only need to run the hook script once, after the iOS platform is added.

## Prerequisites

* Xcode
* Ruby

You will need to install the xcodeproj Gem:

```
sudo gem install xcodeproj
```

## Walkthrough

TODO: Walkthrough

## Hook Configuration

TODO: Describe hook script setup
