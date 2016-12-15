puts <<-END

 _____       _       _ _           _        
|_   _|     | |     | | |         | |       
  | |  _ __ | |_ ___| | | ___  ___| |_ __ _ 
  | | | '_ \| __/ _ \ | |/ _ \/ __| __/ _` |
 _| |_| | | | ||  __/ | |  __/ (__| || (_| |
|_____|_| |_|\__\___|_|_|\___|\___|\__\__,_|
                                            
@ Rails Generator Script
@ Author: Amanullah Tanweer
@ Version: 0.0.1
END

generate(:controller, "welcome index")
route "root to: 'welcome#index'"

if yes?("Would you like to install Devise?")
  gem "devise"
  gem "devise-bootstrap4-views", git: "git@task.intellecta.co:rails-libs/devise-bootstrap4-views.git"
  gem "faker"
  gem "better_errors"
  gem "bootstrap_scaffold", git: "git@task.intellecta.co:clients/bootstrap_scaffold.git"
  run "bundle install"
  generate "devise:install"
  generate "adminlayout"
  model_name = "user"
  generate "devise", model_name
	rake "db:migrate"
	inject_into_file 'app/controllers/application_controller.rb', "before_action :authenticate_user!\n", :before => /^end/

	inject_into_file 'app/helpers/application_helper.rb', "def active_class(link_path)\n current_page?(link_path) ? 'active open' : ''\n end\n", :before => /^end/
	generate "devise:views:bootstrap_templates"
end

if yes?("Would you like to install bootstrap, font-awesome and include media?")
	gem "bootstrap", "~> 4.0.0.alpha5"
	gem "font-awesome-rails"
	inside('app/assets/stylesheets') do
  	run "curl -O https://raw.githubusercontent.com/eduardoboucas/include-media/master/dist/_include-media.scss"
  	run "curl -O http://modularcode.io/modular-admin-html/css/app-red.css"
	end
end

# if yes?("Would you like to install extra gems for dashboards?")
# 	gem "chartkick"
# 	gem 'groupdate'
# end

after_bundle do
	
	inside "app/assets/stylesheets" do
		copy_file "application.css", "application.scss"
		remove_file  "application.css"
		gsub_file "application.scss", /\*= require_(self|tree .)/, ""
		gsub_file "application.scss", /(\s\n)/, "" 
		append_to_file "application.scss" do
				"\n@import \"bootstrap\";\n" +
				"\n@import \"font-awesome\";\n" +
				"\n@import \"include-media\";\n" +
				"\n@import \"app-red\";"
		end
	end

	puts "***********************************************************"
  puts "                   All Done Have Fun!                      "
  puts "***********************************************************"
end