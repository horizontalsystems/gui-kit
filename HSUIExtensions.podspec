Pod::Spec.new do |s|
  s.name = 'HSUIExtensions'
  s.version = '1.0'
  s.summary = 'Extensions and helpers'
  s.module_name = 'UIExtensions'

  s.homepage = 'https://github.com/horizontalsystems/ui-kit'
  s.license = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author = { 'Horizontal Systems' => 'hsdao@protonmail.ch' }
  s.source = { :git => 'https://github.com/horizontalsystems/ui-kit.git', :tag => "ui-extensions-#{s.version}" }
  s.swift_version = '5'
  s.ios.deployment_target = '11.0'

  s.source_files = 'HSUIExtensions/HSUIExtensions/**/*.{swift}'
end
