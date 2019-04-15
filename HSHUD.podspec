Pod::Spec.new do |s|
  s.name = 'HSHUD'
  s.version = '1.0'
  s.summary = 'Customizable HUD'
  s.module_name = 'HUD'

  s.homepage = 'https://github.com/horizontalsystems/ui-kit'
  s.license = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author = { 'Horizontal Systems' => 'hsdao@protonmail.ch' }
  s.source = { :git => 'https://github.com/horizontalsystems/ui-kit.git', :tag => "hud-#{s.version}" }
  s.swift_version = '5'
  s.ios.deployment_target = '11.0'

  s.source_files = 'HSHUD/HSHUD/**/*.{swift}'
  s.resources = 'HSHUD/HSHUD/*.xcassets'

  s.dependency 'HSUIExtensions'
  s.dependency 'SnapKit', '~> 4.0'
end
