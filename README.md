drupalbaseplus Cookbook
=======================
This cookbook creates a working web site installation, based on Drupal CMS and using Drush behind the scenes to provide a functional site that includes the core of Drupal along with some projects/modules of common use.

The main goal of this cookbook is to be a time server for web site developers based on Drupal, by providing a more than functional site via an automated way.

A second desirable goal of this cookbook is to serve as a base to create customized Drupal installations, via attribute's overriding as well as providing additional details.

Requirements
------------
Anything than Drupal and Drush require to work is required by this cookbook. Basically this means a Linux based environment as well as the following.

## Packages to install
The following packages are installed by this cookbook:

- `php-gd` - required by Drupal
- `php-cli` - needed by Drush
- `composer` - needed by Drush
- `unzip` - needed by Drush when downloading some zipped libraries or projects
- `git` - needed by Drush when downloading some libraries or projects managed with Git
- `mysql` - Drupal needs a database or a way to connect to a database
- `php5-mysql` - Drupal needs a way to connect to a database
- `apache2` - the web server. Some work is needed to adapt

## Platforms
This cookbook works on the following platforms:

- Ubuntu 12.04

Testing
-------
Only manual testing. Automated testing is a pending assignment.

Attributes
----------
Several defaults are assumed for the following attributes:

* `default['drupalbaseplus']['drush_base_dir']` - base directory to install drush
* `default['drupalbaseplus']['core_version']` - Drupal core version to use, defaults to '7.x'
* `default['drupalbaseplus']['site_dir']` - base directory to site installation
* `default['drupalbaseplus']['site_vhost_name']` - name used to generate the web server virtual host file for the site
* `default['drupalbaseplus']['site_url']` - url of the site, used as the server name of the web server virtual host
* `default['drupalbaseplus']['site_formal_name']` - site name or label to show by default on the title of web pages
* `default['drupalbaseplus']['site_default_locale']` - locale ISO code to use on site installation via drush
* `default['drupalbaseplus']['site_default_country']` - country ISO code to use on site installation via drush
* `default['drupalbaseplus']['site_admin_account']` - admin user account to use on site installation via drush
* `default['drupalbaseplus']['site_admin_password']` - admin user password to use on site installation via drush
* `default['drupalbaseplus']['site_admin_mail']` - admin user e-mail address to use on site installation via drush
* `default['drupalbaseplus']['www_system_user']` - system user running the web server
* `default['drupalbaseplus']['www_system_group']` - system group running the web server
* `default['drupalbaseplus']['composer_path']` - path to composer executable
* `default['drupalbaseplus']['setup_site_database']` - do we need to create the database? Default is true
* `default['drupalbaseplus']['database_host']` - database server address
* `default['drupalbaseplus']['database_port']` - database server port
* `default['drupalbaseplus']['database_name']` - database name
* `default['drupalbaseplus']['database_site_user']` - database user name to configure the web site with
* `default['drupalbaseplus']['database_site_password']` - database user password to configure the web site with
* `default['drupalbaseplus']['theme_default']` - Drupal theme to set as the default one
* `default['drupalbaseplus']['cache-clear']` - Drupal type of cache to clear via Drush, default to 'all'

Usage
-----
#### drupalbaseplus::default

Just include `drupalbaseplus` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[drupalbaseplus]"
  ]
}
```

Also, it is valid to include it in your cookbook's recipes as `include_recipe "drupalbaseplus" or `include_recipe "drupalbaseplus::default"`.

Contributing
------------
This is a work in progress. Write me an e-mail with your ideas or contributions

License and Authors
-------------------
Author:: Rodolfo Castellanos: <rodolfojcj@yahoo.com>

```
Copyright:: 2014, OpenSinergia

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
