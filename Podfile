# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'McDonalds' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for McDonalds
	pod 'RealmSwift', '~> 2.0'
    pod 'Firebase/Core'
    pod 'Firebase/Auth'
    pod 'GoogleSignIn'
    pod 'Alamofire', '~> 4.0'
    pod 'FacebookCore'
    pod 'FacebookLogin'
    pod 'FacebookShare'
    pod 'SWRevealViewController', '~> 2.3'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
