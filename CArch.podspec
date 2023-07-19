Pod::Spec.new do |spec|
    spec.name         = "CArch"
    spec.version      = "1.0.0"
    spec.summary      = "Фреймворк для использования CArch в iOS приложении"
    spec.description  = <<-DESC
    Архитектура (CArch), это набор протоколов и расширения, созданные для организации взаимодействия компонентов архитектуры между собой
    DESC
    spec.license      = { :type => "MIT", :file => "LICENSE" }
    spec.author       = { "Ayham Hylam" => "Ayham Hylam" }
    spec.homepage     = "https://github.com/ayham-achami/CArch"
    spec.ios.deployment_target = "13.0"
    spec.source = {
        :git => "git@github.com:ayham-achami/CArch.git",
        :tag => spec.version.to_s
    }
    spec.frameworks = ["Foundation", "UIKit"]
    spec.requires_arc = true
    spec.source_files  = "Sources/**/*.swift"
end
