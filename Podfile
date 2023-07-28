# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'test' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'SwiftyStoreKit'
pod 'IQKeyboardManagerSwift'

  # Pods for test

  target 'testTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'testUITests' do
    # Pods for testing
  end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end

end

