Pod::Spec.new do |s|
  s.name = 'HUD.swift'
  s.version = '1.0'
  s.summary = 'Customizable HUD'
  s.module_name = 'HUD'

  s.homepage = 'https://github.com/horizontalsystems/gui-kit'
  s.license = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author = { 'Horizontal Systems' => 'hsdao@protonmail.ch' }
  s.source = { :git => 'https://github.com/horizontalsystems/gui-kit.git', :tag => "hud-#{s.version}" }
  s.swift_version = '5'
  s.ios.deployment_target = '11.0'

  s.source_files = 'HUD/HUD/**/*.{swift}'
  s.resources = 'HUD/HUD/*.xcassets'

  s.dependency 'UIExtensions.swift'
  s.dependency 'SnapKit', '~> 4.0'
end
