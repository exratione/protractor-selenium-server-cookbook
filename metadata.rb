name              'protractor-selenium-server'
license           'MIT'
description       'Set up a machine to be ready to use Protractor for AngularJS end to end testing.'
version           '0.0.3'
recipe            'protractor', 'Set up the machine with Protractor and its dependencies.'
recipe            'protractor::services', 'Set up services for Xvfb and Selenium.'

depends 'java'
depends 'nodejs'

# TODO: other distributions.
%w{ ubuntu debian }.each do |os|
  supports os
end

attribute 'protractor-selenium-server/selenium/install-dir',
  :display_name => 'Selenium installation directory',
  :description => 'Path to the Selenium standalone server installation directory.',
  :default => '/usr/local/share/selenium'

attribute 'protractor-selenium-server/selenium/version',
  :display_name => 'Selenium version',
  :description => 'Selenium standalone server version.',
  :default => '2.37.0'

attribute 'protractor-selenium-server/selenium/user',
  :display_name => 'Selenium user',
  :description => 'User for the Selenium service.',
  :default => 'selenium'

attribute 'protractor-selenium-server/selenium/log-dir',
  :display_name => 'Selenium log directory',
  :description => 'Absolute path to the Selenium standalone server log file directory.',
  :default => '/var/log/selenium'

attribute 'protractor-selenium-server/xvfb/display',
  :display_name => 'DISPLAY environment value',
  :description => 'Value of the DISPLAY environment property used for the Xvfb service.',
  :default => '10'
