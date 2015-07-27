#
# Be sure to run `pod lib lint Siegel.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name         = 'Siegel'
  s.version      = '0.1.0'
  s.summary      = 'A simple implementation of LRU cache.'
  s.description  = <<-DESC
                   A simple implementation of LRU cache written in Swift.
                   This library is inspired by [Cache::LRU](https://metacpan.org/pod/Cache::LRU).
                   DESC
  s.homepage     = 'https://github.com/mihyaeru21/Siegel'
  s.license      = 'MIT'
  s.author       = { 'Mihyaeru' => 'mihyaeru21@gmail.com' }
  s.source       = { :git => 'https://github.com/mihyaeru21/Siegel.git', :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
end
