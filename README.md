# Cordova Xcode Scheme Fix

Uses a Cordova build hook to set up Xcode schemes enabling iOS workflow without ever opening Xcode.

## Problem

If you use the Cordova CLI to create a new Cordova project, then you add the iOS platform to that project you can develop for iOS and use the Cordova CLI to launch the iOS Simulator and view your app during development.

However, if you try and build your app using the xcodebuild command line tools (without ever going into Xcode itself) you will find that the xcodebuild tools hang.  You'll want to use xcodebuild when it's time to archive and sign your app for distribution to services such as HockeyApp.  Often, this process needs to happen in an automated way on a Continuous Integration server (say Jenkins or Circle CI).

This is because by default, Cordova CLI created Xcode projects don't contain schemes... XCode configures these on first launch of a project.  However, these changes are then saved in files that live inside platforms/ios in your Cordova project, and you don't want to check platforms into source control as everything in there should be auto generated.

This repo shows a simple solution for this that allows Cordova projects to play more nicely in a Continuous Integration workflow.

To demonstrate the problem, open up a Terminal and try:

```
cordova create someapp com.mycompany.someapp SomeApp
cd someapp
cordova platform add ios
cordova build ios
cd platforms/ios
xcodebuild -list
```

Everything should work up to the `xcodebuild` command which outputs something like this and then hangs forever:

```
$ xcodebuild -list
Information about project "SomeApp":
    Targets:
        SomeApp

    Build Configurations:
        Debug
        Release

    If no build configuration is specified and -scheme is not passed then "Release" is used.
```

This is because it is looking for schemes in the project, and doesn't find any.

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

To try this out...

* Clone this repo somewhere, let's call that folder <repo>
* Open up a Terminal
* `cd <repo>/app`
* `cordova platform add ios` (note this will also run the hook script to fix the schemes)
* `cd platforms/ios`
* `xcodebuild -list` (should no longer hang, and will list schemes)
* `xcodebuild -sdk iphoneos -scheme schemedemo clean archive` (should now build the project)

## Hook Configuration

The Cordova hook setup used in this project is pretty simple, and consists of the following steps.

### config.xml Changes

In the Cordova config.xml file for the project, we add a `<hook>` element for the iOS platform only, and tell it which event we want to run the hook script for, and where the hook script lives and what its' name is:

```
...
platform name="ios">
  <hook type="after_platform_add" src="hooks/fix_xcode_schemes.rb" />
  ...
...
```

So in this case, we're saying for iOS only let's run `hooks/fix_xcode_schemes.rb` after the iOS platform is added.  This script will run after the user does:

```
cordova platform add ios
```

### Hook Script

The file `hooks/fix_xcode_schemes.rb` needs to have execute permissions so that it can be run (think `chmod 755 hooks/fix_xcode_schemes.rb` - you won't need to do this as GitHub retains the permissions in the repo). Inside, the script looks like:

```
#!/usr/bin/env ruby
require 'xcodeproj'
xcproj = Xcodeproj::Project.open("platforms/ios/schemedemo.xcodeproj")
xcproj.recreate_user_schemes
xcproj.save
```

Which:

* Tells the shell to use ruby to run the script
* Uses the xcodeproj gem we installed earlier
* Opens the Cordova CLI generated .xcodeproj file (you'd need to change the name here to match your project)
* Programmatically makes Xcode recreate the scheme(s) for the project
* Saves the project
