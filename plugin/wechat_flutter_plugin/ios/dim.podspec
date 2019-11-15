#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'dim'
  s.version          = '0.2.7'
  s.summary          = 'TIMSDK for flutter'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://gitee.com/gameOverFlow/dim'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'brzhang' => '1595819400@qq.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'YYModel'
  s.dependency 'TXIMSDK_iOS'
  s.ios.deployment_target = '8.0'
end

