#
# Cookbook Name:: drupalbaseplus
# Attributes:: default
#
# Copyright 2014, OpenSinergia
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

default['drupalbaseplus']['drush_base_dir'] = '/usr/local/drush'
default['drupalbaseplus']['core_version'] = '7.x'
default['drupalbaseplus']['site_dir'] = '/var/www/drupalbaseplus'
default['drupalbaseplus']['site_vhost_name'] = 'drupalbaseplus'
default['drupalbaseplus']['site_url'] = 'www.put_your_acme_domain_here.com'
default['drupalbaseplus']['site_formal_name'] = 'ACME Company Ltd.'
default['drupalbaseplus']['site_default_locale'] = 'es'
default['drupalbaseplus']['site_default_country'] = 'VE'
default['drupalbaseplus']['site_admin_account'] = 'AcmeAdmin'
default['drupalbaseplus']['site_admin_password'] = '3t3sN4tG52ss1bl2'
default['drupalbaseplus']['site_admin_mail'] = 'acmeadmin@put_your_acme_domain_here.com'
default['drupalbaseplus']['www_system_user'] = 'www-data'
default['drupalbaseplus']['www_system_group'] = node['drupalbaseplus']['www_system_user']
#
default['drupalbaseplus']['composer_path'] = '/usr/local/bin/composer'
#
default['drupalbaseplus']['setup_site_database'] = true
default['drupalbaseplus']['database_host'] = 'localhost'
default['drupalbaseplus']['database_port'] = 3306
default['drupalbaseplus']['database_name'] = 'drupalbaseplus-db'
default['drupalbaseplus']['database_site_user'] = 'dbsiteuser'
default['drupalbaseplus']['database_site_password'] = 'V2ryD3ff3c5lt'
#
default['drupalbaseplus']['theme_default'] = 'bartik'
default['drupalbaseplus']['cache-clear'] = 'all'
#
# TODO: use devel attribute to include several useful devel modules
# TODO: use devel attribute to disable js,css compression/optimization
default['drupalbaseplus']['is_devel_site'] = false
#
# TODO: use production attribute to optimize as much as possible
default['drupalbaseplus']['is_production_site'] = true
