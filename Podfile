# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'Mestika Dashboard' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Mestika Dashboard
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'SwiftyRSA', '~> 1.6.0'

  target 'Mestika DashboardTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Mestika DashboardUITests' do
    # Pods for testing
  end

   post_install do |installer|
       installer.pods_project.targets.each do |target|
           target.build_configurations.each do |config|
                config.build_settings['ENABLE_BITCODE'] = 'NO'
           end
       end
   end

end
