# Timeout for browser installation in seconds.
default['protractor-selenium-server']['browser-install-timeout'] = 1200

# Selenium paths.
default['protractor-selenium-server']['selenium']['install-dir'] = '/usr/local/share/selenium'
default['protractor-selenium-server']['selenium']['log-dir'] = '/var/log/selenium'

# The user that will run Selenium.
default['protractor-selenium-server']['selenium']['user'] = 'selenium'

# The version of Selenium standalone server to install.
default['protractor-selenium-server']['selenium']['version'] = '2.41.0'
