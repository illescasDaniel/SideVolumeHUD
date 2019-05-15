Pod::Spec.new do |s|
  s.name                      = "SideVolumeHUD"
  s.version                   = "1.0.0"
  s.summary                   = "SideVolumeHUD"
  s.homepage                  = "https://github.com/illescasDaniel/SideVolumeHUD"
  s.license                   = { :type => "MIT", :file => "LICENSE" }
  s.author                    = { "Daniel Illescas Romero" => "illescas.daniel@protonmail.com" }
  s.source                    = { :git => "https://github.com/illescasDaniel/SideVolumeHUD.git", :tag => s.version.to_s }
  s.ios.deployment_target     = "8.0"
  s.tvos.deployment_target    = "9.0"
  s.watchos.deployment_target = "2.0"
  s.osx.deployment_target     = "10.10"
  s.source_files              = "Sources/Code/**/*"
  s.frameworks                = "Foundation"
end
