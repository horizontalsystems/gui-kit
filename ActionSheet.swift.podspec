Pod::Spec.new do |s|
  s.name = 'ActionSheet.swift'
  s.version = '1.0'
  s.summary = 'Customisable replacement for UIAlertController'
  s.module_name = 'ActionSheet'

  s.homepage = 'https://github.com/horizontalsystems/gui-kit'
  s.license = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author = { 'Horizontal Systems' => 'hsdao@protonmail.ch' }
  s.source = { :git => 'https://github.com/horizontalsystems/gui-kit.git', :tag => "action-sheet-#{s.version}" }
  s.swift_version = '5'
  s.ios.deployment_target = '11.0'

  s.source_files = 'ActionSheet/ActionSheet/**/*.{swift}'

  s.dependency 'UIExtensions.swift'
  s.dependency 'SnapKit', '~> 5.0'
end
