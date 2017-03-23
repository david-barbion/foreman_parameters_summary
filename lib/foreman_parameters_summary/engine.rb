module ForemanParametersSummary
  class Engine < ::Rails::Engine
    engine_name 'foreman_parameters_summary'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    # Add any db migrations
    initializer 'foreman_parameters_summary.load_app_instance_data' do |app|
      ForemanParametersSummary::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_parameters_summary.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_parameters_summary do
        requires_foreman '>= 1.4'

        # Add permissions
        security_block :foreman_parameters_summary do
          permission :view_foreman_parameters_summary, :'foreman_parameters_summary/parameters' => [:summary]
        end

        # Add a new role called 'Discovery' if it doesn't exist
        role 'ForemanParametersSummary', [:view_foreman_parameters_summary]

        # add menu entry
        menu :top_menu, :template,
             url_hash: { :controller => :'foreman_parameters_summary/parameters', :action => :index },
             caption: 'Parameters',
             parent: :monitor_menu,
             after: :fact_values

        # add dashboard widget
#        widget 'foreman_parameters_summary_widget', name: N_('Foreman plugin template widget'), sizex: 4, sizey: 1
      end
    end

    # Precompile any JS or CSS files under app/assets/
    # If requiring files from each other, list them explicitly here to avoid precompiling the same
    # content twice.
    assets_to_precompile =
      Dir.chdir(root) do
        Dir['app/assets/javascripts/**/*', 'app/assets/stylesheets/**/*'].map do |f|
          f.split(File::SEPARATOR, 4).last
        end
      end
    initializer 'foreman_parameters_summary.assets.precompile' do |app|
      app.config.assets.precompile += assets_to_precompile
    end
    initializer 'foreman_parameters_summary.configure_assets', group: :assets do
      SETTINGS[:foreman_parameters_summary] = { assets: { precompile: assets_to_precompile } }
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        Host::Managed.send(:include, ForemanParametersSummary::HostExtensions)
        HostsHelper.send(:include, ForemanParametersSummary::HostsHelperExtensions)
      rescue => e
        Rails.logger.warn "ForemanParametersSummary: skipping engine hook (#{e})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanParametersSummary::Engine.load_seed
      end
    end

    initializer 'foreman_parameters_summary.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman_parameters_summary'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
