platform :ios, '8.0'

source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

def shared_pods
    pod 'ReactiveCocoa'
end

target 'MVCache' do
    shared_pods
    pod 'MVCacheCore', :path => './'
end

target 'MVCacheCore' do
    shared_pods

    # API
    pod 'Alamofire'
end

def test_pods
    pod 'Quick'
    pod 'Nimble'
end
