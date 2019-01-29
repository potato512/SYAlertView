Pod::Spec.new do |s|

  s.name         = "SYAlertViewController"
  s.version      = "1.1.1"
  s.summary      = "the containerView of SYAlertViewController can add subviews, which cretated by developer"
  s.homepage     = "https://github.com/potato512/SYAlertViewController"
  s.license      = "MIT"
  s.author       = { "herman" => "zhangsy757@163.com" }
  s.source       = { :git => 'https://github.com/potato512/SYAlertViewController.git', :tag => "#{s.version}" }
  s.source_files  = 'SYAlertViewController/*.{h,m}'
  s.requires_arc = true
  s.platform     = :ios, "8.0"

end
