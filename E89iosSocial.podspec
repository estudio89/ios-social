  Pod::Spec.new do |s|
  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.name         = "E89iosSocial"
  s.summary      = "E89iosSocial"
  s.requires_arc = true

  s.version      = "0.0.1"

  s.license      = {:type => "MIT", :file => "LICENSE"}

  s.authors      = {"Estúdio 89" => "contato@estudio89.com.br"}

  s.homepage     = "http://www.estudio89.com.br"

  s.source       = { :git => "https://github.com/estudio89/ios-social.git", :branch => "master"}

  #s.dependency 'FBSDKCoreKit'
  #s.dependency 'FBSDKLoginKit'
  #s.dependency 'Google/SignIn'
  #s.dependency 'Fabric'
  #s.dependency 'TwitterKit'

  s.vendored_frameworks = 'FBSDKLoginKit.framework', 'FBSDKCoreKit.framework', 'Bolts.framework'

  s.source_files = 'E89iosSocial/*.{swift}'
end
