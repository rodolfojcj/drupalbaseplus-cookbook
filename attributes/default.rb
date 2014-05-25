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

default['drupalbaseplus']['install_drush'] = true
default['drupalbaseplus']['core_version'] = '7.x'
default['drupalbaseplus']['site_short_nick'] = 'drupalbaseplus'
default['drupalbaseplus']['site_dir'] = '/var/www/' + node['drupalbaseplus']['site_short_nick']
default['drupalbaseplus']['site_vhost_name'] = node['drupalbaseplus']['site_short_nick']
default['drupalbaseplus']['site_url'] = 'www.put_your_domain_here.com'
default['drupalbaseplus']['site_formal_name'] = 'ACME Company Ltd.'
default['drupalbaseplus']['site_default_locale'] = 'es'
default['drupalbaseplus']['site_default_country'] = 'VE'
default['drupalbaseplus']['site_admin_account'] = 'AcmeAdmin'
default['drupalbaseplus']['site_admin_password'] = '3t3sN4tG52ss1bl2'
default['drupalbaseplus']['site_admin_mail'] = 'acmeadmin@acmedomain.com'
default['drupalbaseplus']['www_system_user'] = 'www-data'
default['drupalbaseplus']['www_system_group'] = node['drupalbaseplus']['www_system_user']
#
default['drupalbaseplus']['setup_site_database'] = true
default['drupalbaseplus']['database_host'] = 'localhost'
default['drupalbaseplus']['database_port'] = 3306
default['drupalbaseplus']['database_name'] = 'drupalbaseplusdb'
default['drupalbaseplus']['database_site_user'] = 'dbsiteuser'
default['drupalbaseplus']['database_site_password'] = 'V2ryD3ff3c5lt'
#
default['drupalbaseplus']['theme_default'] = 'bartik'
default['drupalbaseplus']['cache_to_clear'] = 'all'
#
default['drupalbaseplus']['jsons_for_drush_make'] = [
<<-EOH
{
  "projects": {
    "views": {},
    "ctools": {},
    "galleria": {},
    "libraries": {},
    "flexslider": {},
    "flexslider_views_slideshow": {},
    "link": {},
    "entity": {},
    "features": {},
    "strongarm": {},
    "draggableviews": {},
    "views_slideshow": {},
    "field_redirection": {},
    "drupaleasy_slideshow": {
      "type": "module",
      "download": {
        "type": "git",
        "url": "http://git.drupal.org/sandbox/ultimike/1822938.git"
      }
    },
    "xmlsitemap": {},
    "site_map": {},
    "jquery_update": {},
    "advanced_help": {}
  },
  "libraries": {
    "galleria": {
      "type": "library",
      "download": {
        "type": "file", "url": "http://galleria.io/static/galleria-1.3.5.zip",
         "directory_name": "galleria"
      }
    },
    "jquery_cycle": {"type": "library"},
    "flexslider": {
      "type": "library", 
      "download": {
        "type": "file", "directory_name": "flexslider",
        "url": "http://github.com/woothemes/FlexSlider/archive/master.tar.gz"
      }
    }
  },
  "translations": "es"
}
EOH
]
default['drupalbaseplus']['modules_themes_to_enable'] = ['contact', 'views', 'views_ui', node['drupalbaseplus']['theme_default']]
# useful for other cookbooks wanting to disable some modules of this base cookbook
default['drupalbaseplus']['modules_themes_to_disable'] = [] 
#
# TODO: use devel attribute to include several useful devel modules
# TODO: use devel attribute to disable js,css compression/optimization
default['drupalbaseplus']['is_devel_site'] = false
#
# TODO: use production attribute to optimize as much as possible
default['drupalbaseplus']['is_production_site'] = true
default['drupalbaseplus']['can_reinstall'] = false
