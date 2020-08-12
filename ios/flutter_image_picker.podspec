
Pod::Spec.new do |s|
  s.name             = 'flutter_image_picker'
  s.version          = '1.4.4'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/TuanMinhVan/flutter_image_picker.git'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'minhtuan' => '673636090@qq.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
