module PostyClient
  class Settings < ReadWriteSettings
    source    PostyClient.settings_file
    namespace PostyClient.env
  end
end