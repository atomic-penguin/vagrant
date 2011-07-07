module Vagrant
  class Action
    module VM
      class Provision
        def initialize(app, env)
          @app = app
          @env = env
          @env["provision.enabled"] = true if !@env.has_key?("provision.enabled")
        end

        def call(env)
          @app.call(env)

          enabled_provisioners.each do |instance|
            @env.ui.info I18n.t("vagrant.actions.vm.provision.beginning", :provisioner => instance.class)
            instance.prepare
            instance.provision!
          end
        end

        def enabled_provisioners
          @env["config"].vm.provisioners.map do |provisioner|
            provisioner.provisioner.new(@env, provisioner.config)
          end
        end
      end
    end
  end
end
