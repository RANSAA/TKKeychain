#
#  Be sure to run `pod spec lint TKKeychain.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#
#  CocoaPods使用指南：https://guides.cocoapods.org/making/making-a-cocoapod.html
#  发布：https://blog.csdn.net/sinat_31807529/article/details/80486589

#  注册账号令牌：pod trunk register 1352892108@qq.com [sayaDev]
#  推送到cocospods上：pod trunk push 
#  从cocospods中删除已经提交过的框架：pod trunk delete TKKeychain 1.0.0
#
#
#

Pod::Spec.new do |spec|
  spec.name         = "TKKeychain"
  spec.version      = "1.0.1"
  spec.summary      = "TKKeychain 钥匙串操作工具"
  spec.description  = <<-DESC
  钥匙串简单的封装，实现增，删，该，查。以及模拟获取设备UDID
                       DESC
  spec.homepage     = "https://github.com/RANSAA/TKKeychain"
  spec.license      = "MIT"
  #spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  spec.author        = { "sayaDev" => "1352892108@qq.com" }
  spec.source       = { :git => "https://github.com/RANSAA/TKKeychain.git", :tag => "v#{spec.version}" }
 
  spec.requires_arc = true
  spec.platform     = :ios, "8.0"
  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"



  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  spec.source_files  = "TKKeychain", "TKKeychain/*.{h,m}"
  # spec.exclude_files = "TKKeychain/Exclude"

  spec.public_header_files = "TKKeychain/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"
  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"

  ## 隐私清单
  spec.resource_bundles = {
      spec.name => ["#{spec.name}/PrivacyInfo.xcprivacy"]
  }



  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  spec.frameworks = "Security", "Foundation", "UIKit"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
