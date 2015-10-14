# cordovaxcodeschemefix

Uses a Cordova build hook to set up Xcode schemes enabling iOS workflow without ever opening Xcode

## Problem

TODO: Describe problem

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
