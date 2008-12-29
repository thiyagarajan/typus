module Typus

  module Configuration

    module Reloader

      def reload_config_et_roles
        if Rails.env.development?
          logger.info "[typus] Configuration files have been reloaded."
          Typus::Configuration.roles!
          Typus::Configuration.config!
        end
      end

    end

    ##
    # Default application options that can be overwritten from
    # an initializer.
    #
    # Example:
    #
    #   Typus::Configuration.options[:app_name] = "Your App Name"
    #   Typus::Configuration.options[:per_page] = 15
    #   Typus::Configuration.options[:toggle] = true
    #   Typus::Configuration.options[:root] = 'admin'
    #   Typus::Configuration.options[:recover_password] = false
    #   Typus::Configuration.options[:email] = 'admin@example.com'
    #   Typus::Configuration.options[:ssl] = false
    #   Typus::Configuration.options[:icon_on_boolean] = true
    #
    @@options = { :app_name => 'Typus', 
                  :per_page => 15, 
                  :form_rows => 10, 
                  :sidebar_selector => 10, 
                  :minute_step => 5, 
                  :toggle => true, 
                  :edit_after_create => true, 
                  :root => 'admin', 
                  :recover_password => true, 
                  :email => 'admin@example.com', 
                  :ssl => false, 
                  :prefix => 'admin', 
                  :icon_on_boolean => true, 
                  :nil => 'nil' }

    mattr_accessor :options

    ##
    # Read Typus Configuration file
    #
    #   Typus::Configuration.config! overwrites @@config
    #
    def self.config!

      folders = if Rails.env.test?
                  ["vendor/plugins/typus/test/config/typus.yml"]
                else
                  Dir["config/typus/*"] - Dir["config/typus/*"].grep(/roles.yml/)
                end

      @@config = {}
      folders.each do |folder|
        @@config = @@config.merge(YAML.load_file("#{Rails.root}/#{folder}"))
      end

      return @@config

    end

    mattr_accessor :config

    ##
    # Read Typus Roles
    #
    #   Typus::Configuration.roles! overwrites @@roles
    #
    def self.roles!

      folders = if Rails.env.test?
                  ["vendor/plugins/typus/test/config/typus_roles.yml"]
                else
                  Dir["config/typus/*_roles.yml"]
                end

      @@roles = { options[:root] => {} }

      folders.each do |folder|
        YAML.load_file("#{Rails.root}/#{folder}").each do |key, value|
          begin
            @@roles[key] = @@roles[key].merge(value)
          rescue
            @@roles[key] = value
          end
        end
      end

      return @@roles

    end

    mattr_accessor :roles

  end

end