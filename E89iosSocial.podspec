Pod::Spec.new do |s|
  s.name         = "E89iosSocial"
  s.version      = "0.0.1"
  s.summary      = "E89iosSocial"
  s.requires_arc = true
  s.source_files = 'E89iosSocial/*.swift'
  s.homepage     = "http://www.estudio89.com.br"
  s.authors      = {"Estúdio 89" => "contato@estudio89.com.br"}
  s.license      = {:type => "MIT", :file => "LICENSE"}
  s.source       = { :git => "[Your RWPickFlavor Git URL Goes Here]", :tag => "#{s.version}"}
  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.dependency 'FBSDKCoreKit'
  s.dependency 'FBSDKLoginKit'
  s.dependency 'Google/SignIn'
  s.dependency 'Fabric'
  s.dependency 'TwitterKit'
end
