Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.name = "MapboxNavigation.swift"
  s.version = "0.0.0"
  s.summary = "Mapbox Navigation library"

  s.description  = <<-DESC
  MapboxNavigation.swift makes it easy to get step by step instructions for guiding a user along a route.
                   DESC

  s.homepage = "https://www.mapbox.com/directions/"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.license = { :type => "ISC", :file => "LICENSE.md" }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.author = { "Mapbox" => "mobile@mapbox.com" }
  s.social_media_url = "https://twitter.com/mapbox"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.ios.deployment_target = "8.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source = { :git => "https://github.com/mapbox/MapboxNavigation.swift.git", :tag => "v#{s.version.to_s}" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source_files = "MapboxNavigation"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.requires_arc = true
  s.module_name = "MapboxNavigation"

  s.dependency = 'Mapbox-iOS-SDK', :podspec => 'https://raw.githubusercontent.com/mapbox/mapbox-gl-native/ios-v3.4.0-beta.3/platform/ios/Mapbox-iOS-SDK-symbols.podspec'
  s.dependency = 'MapboxDirections.swift', :git => 'https://github.com/mapbox/MapboxDirections.swift.git', :commit => '117f155dcf6295e01be9f927399b7deedf983294'

end