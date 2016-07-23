platform :ios, '8.0'

source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

def shared_pods
    pod 'ReactiveCocoa'

    # API
    pod 'Alamofire'
    pod 'ObjectMapper'

end

target 'MVCache' do
    shared_pods
end

def test_pods
    pod 'Quick'
    pod 'Nimble'
    pod 'Mockingjay', '~> 1.1.1'
end
