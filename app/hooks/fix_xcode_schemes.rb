#!/usr/bin/env ruby
require 'xcodeproj'
xcproj = Xcodeproj::Project.open("platforms/ios/schemedemo.xcodeproj")
xcproj.recreate_user_schemes
xcproj.save
