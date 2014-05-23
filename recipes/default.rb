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

chef_gem 'json'
chef_gem 'deep_merge'

::Chef::Resource::Template.send(:include, Drupal::Helper)

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

include_recipe "drupalbaseplus::install_drush" if node['drupalbaseplus']['install_drush'] == true

##
# put drush to work throuh drush make stuff!
##
template Chef::Config[:file_cache_path] + "/drupalbaseplus.make" do
  source 'site.make.erb'
  owner 'root'
  group 'root'
  mode '0644'
  plt_array = generate_plt(merge_json_to_hash(node['drupalbaseplus']['jsons_for_drush_make'][0], nil))
  variables({
    :core => node['drupalbaseplus']['core_version'],
    :plt => plt_array
  })
end

drush_make node['drupalbaseplus']['site_dir'] do
  makefile Chef::Config[:file_cache_path] + "/drupalbaseplus.make"
end

drush_cmd "site-install" do
  arguments "standard install_configure_form.site_default_country=" + node['drupalbaseplus']['site_default_country']
  options [
    "--account-mail=" + node['drupalbaseplus']['site_admin_mail'],
    "--account-name=" + node['drupalbaseplus']['site_admin_account'],
    "--account-pass=" + node['drupalbaseplus']['site_admin_password'],
    "--site-name='" + node['drupalbaseplus']['site_formal_name'] + "'",
    "--site-mail=" + node['drupalbaseplus']['site_admin_mail'],
    "--locale=" + node['drupalbaseplus']['site_default_locale'],
    "--db-url=mysqli://" + node['drupalbaseplus']['database_site_user'] + ":" + 
      node['drupalbaseplus']['database_site_password'] + "@" + node['drupalbaseplus']['database_host'] +
       "/" + node['drupalbaseplus']['database_name']
    ]
  drupal_root node['drupalbaseplus']['site_dir']
  drupal_uri node['drupalbaseplus']['site_url']
  only_if {
    !File.exists?(node['drupalbaseplus']['site_dir'] + "/sites/default/settings.php") ||
    node['drupalbaseplus']['can_reinstall'] == true
  }
end

drush_cmd "pm-enable" do
  arguments node['drupalbaseplus']['modules_themes_to_enable'].join(' ')
  options ["--resolve-dependencies"]
  drupal_root node['drupalbaseplus']['site_dir']
  drupal_uri node['drupalbaseplus']['site_url']
  only_if { node['drupalbaseplus']['modules_themes_to_enable'].join(' ').empty? == false }
end

drush_cmd "pm-disable" do
  arguments node['drupalbaseplus']['modules_themes_to_disable'].join(' ')
  drupal_root node['drupalbaseplus']['site_dir']
  drupal_uri node['drupalbaseplus']['site_url']
  only_if { node['drupalbaseplus']['modules_themes_to_disable'].join(' ').empty? == false }
end

drush_variable "theme_default" do
  value node['drupalbaseplus']['theme_default']
  drupal_root node['drupalbaseplus']['site_dir']
  drupal_uri node['drupalbaseplus']['site_url']
end

drush_cmd "cache-clear" do
  arguments node['drupalbaseplus']['cache_to_clear']
  drupal_root node['drupalbaseplus']['site_dir']
  drupal_uri node['drupalbaseplus']['site_url']
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
  template "site.vhost.conf.erb"
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
