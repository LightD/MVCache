
Pod::Spec.new do |s|
  s.name             = "MVCacheCore"
  s.version          = "0.1.0"
  s.summary          = "An experiment."
  s.description      = "Mini caching/networking library."
  s.homepage         = "https://github.com/LightD/MVCache"
  s.license          = 'MIT'
  s.author           = { "Nour" => "nourforgive@gmail.com" }
  s.source           = { :git => "https://github.com/LightD/MVCache.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'MVCacheCore/**/*'
  s.resource_bundles = {
    'MVCacheCore' => []
  }
  s.public_header_files = 'MVCacheCore/*.h'

  s.dependency 'Alamofire'
  s.dependency 'ReactiveCocoa'
end
