Pod::Spec.new do |s|
  s.name = 'HSActionSheet'
  s.version = '1.0'
  s.summary = 'Customisable replacement for UIAlertController'

  s.homepage = 'https://github.com/horizontalsystems/ui-kit'
  s.license = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author = { 'Horizontal Systems' => 'hsdao@protonmail.ch' }
  s.source = { :git => 'https://github.com/horizontalsystems/ui-kit.git', :tag => "action-sheet-#{s.version}" }
  s.swift_version = '5'
  s.ios.deployment_target = '11.0'

  s.source_files = 'HSActionSheet/HSActionSheet/**/*.{swift}'

  s.dependency 'HSUIExtensions'
  s.dependency 'SnapKit', '~> 4.0'
end
