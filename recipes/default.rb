#
# Cookbook Name:: drupalbaseplus
# Recipe:: default
#
# Copyright 2014, OpenSinergia
#
# All rights reserved - Do Not Redistribute
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

##
# packages
##
# for drush
package 'php5-cli'
package 'unzip'
package 'git'
# drupal requirements
package 'php5-mysql'
package 'php5-gd'
package 'apache2'

##
# setup database, if needed
##
if node['drupalbaseplus']['setup_site_database'] == true
  include_recipe "mysql::server"
  include_recipe "mysql::ruby"
  include_recipe "database"

  mysql_connection_info = {
    :host     => node['drupalbaseplus']['database_host'],
    :username => 'root',
    :password => node['mysql']['server_root_password']
  }

  mysql_database node['drupalbaseplus']['database_name'] do
    connection mysql_connection_info
    action [:create]
  end

  mysql_database_user node['drupalbaseplus']['database_site_user'] do
    connection mysql_connection_info
    password node['drupalbaseplus']['database_site_password']
    privileges [:all]
    action [:create, :grant]
  end
end

##
# drush installation
##
bash 'getcomposer' do
  code <<-EOH
    if [ -f #{node['drupalbaseplus']['composer_path']} ]
    then
      #{node['drupalbaseplus']['composer_path']} --self-update --clean-backups
    else
      wget -q -O- http://getcomposer.org/installer | php
      mv composer.phar #{node['drupalbaseplus']['composer_path']}
    fi
  EOH
end

bash 'getdrush' do
  code <<-EOH
    if [ -d #{node['drupalbaseplus']['drush_base_dir']} ]
    then
      #{node['drupalbaseplus']['drush_base_dir']}/drush self-update
    else
      wget -q http://github.com/drush-ops/drush/archive/master.tar.gz
      tar xf master.tar.gz
      mv drush-master #{node['drupalbaseplus']['drush_base_dir']}
      chmod 755 #{node['drupalbaseplus']['drush_base_dir']}/drush
      rm master.tar.gz
    fi
    # get drush dependencies via composer, as now it requires
    cd #{node['drupalbaseplus']['drush_base_dir']}
    #{node['drupalbaseplus']['composer_path']} install
  EOH
end

##
# put drush to work throuh drush make stuff!
##
template '/tmp/drupalbaseplus.make' do
  source 'drupalbaseplus.make.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

bash 'apply-drush-make' do
  # TODO: with ruby syntax, if site_dir already exists, notify some resource
  # that tries to converge the site via pm-enable, including downloading
  # related dependencies.
  # Or is that more appropriated after site installation?
  code <<-EOH
    if [ ! -d #{node['drupalbaseplus']['site_dir']} ]
    then
      export PATH=#{node['drupalbaseplus']['drush_base_dir']}:$PATH
      drush make /tmp/drupalbaseplus.make #{node['drupalbaseplus']['site_dir']} --yes
    fi
  EOH
end

bash 'site-install-with-drush-make' do
  code <<-EOH
    if [ ! -f #{node['drupalbaseplus']['site_dir']}/sites/default/settings.php ]
    then
      export PATH=#{node['drupalbaseplus']['drush_base_dir']}:$PATH
      cd #{node['drupalbaseplus']['site_dir']}
      drush site-install standard \
      --db-url=mysqli://#{node['drupalbaseplus']['database_site_user']}:#{['drupalbaseplus']['database_site_password']}@#{node['drupalbaseplus']['database_host']}/#{node['drupalbaseplus']['database_name']} \
      --site-name=#{node['drupalbaseplus']['site_formal_name']} --locale=#{node['drupalbaseplus']['site_default_locale']} \
      --account-name=#{node['drupalbaseplus']['site_admin_account']} \
      --account-pass=#{node['drupalbaseplus']['site_admin_password']} \
      --account-mail=#{node['drupalbaseplus']['site_admin_mail']} \
      install_configure_form.site_default_country=#{node['drupalbaseplus']['site_default_country']} \
      --yes
    fi
  EOH
end

bash 'enable-modules-via-drush' do
  cwd node['drupalbaseplus']['site_dir']
  modules_to_enable = %w(views_slideshow ckeditor simplecorp galleria flexslider simplecorp)
  code <<-EOH
    export PATH=#{node['drupalbaseplus']['drush_base_dir']}:$PATH
    drush pm-enable --resolve-dependencies --yes #{modules_to_enable.join(' ')}
  EOH
end

bash 'misc-commands-via-drush' do
  cwd node['drupalbaseplus']['site_dir']
  code <<-EOH
    export PATH=#{node['drupalbaseplus']['drush_base_dir']}:$PATH
    #{"drush variable-set theme_default " + node['drupalbaseplus']['theme_default'] + " --yes" if node['drupalbaseplus']['theme_default'].size > 0}
    #{"drush cache-clear " + node['drupalbaseplus']['cache-clear'] if node['drupalbaseplus']['cache-clear'].size > 0}
  EOH
end

##
# virtual host
##
include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_rewrite"

web_app node['drupalbaseplus']['site_vhost_name'] do
  server_name node['drupalbaseplus']['site_url']
  docroot node['drupalbaseplus']['site_dir']
  template "drupalbaseplus_vhost.conf.erb"
  log_dir node['apache']['log_dir']
end

##
# set appropriate file system permissions
##
directory node['drupalbaseplus']['site_dir'] + '/sites/default/files' do
  owner node['drupalbaseplus']['www_system_user']
  group node['drupalbaseplus']['www_system_group']
  mode '0755'
end
