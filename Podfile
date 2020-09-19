platform :ios, '13.0'
inhibit_all_warnings!

def app_pods 
end

def test_pods
end

def tool_pods
    pod 'SwiftLint'
    pod 'SwiftFormat/CLI'
end


target 'SimplePaginatedList' do
  use_frameworks!

  app_pods

  target 'SimplePaginatedListTests' do
    inherit! :search_paths
    test_pods
  end
end

tool_pods
