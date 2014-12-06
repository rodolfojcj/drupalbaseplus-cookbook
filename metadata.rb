name             'drupalbaseplus'
maintainer       'Rodolfo Castellanos'
maintainer_email 'rodolfojcj at yahoo.com'
license          'Apache v2.0'
description      'Installs a web site based on Drupal CMS using Drush as the workhorse for (almost) everything'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.6'

depends "apache2"
depends "database"
depends "drush"
depends "mysql", "= 5.5.3"

%w{ubuntu}.each do |os|
  supports os
end
