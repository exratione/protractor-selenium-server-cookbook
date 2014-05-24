#
# Install all of the line items needed to run Protractor.
#
# TODO: variant package lists and other items for other distributions.
#

# ----------------------------------------------------------------------------
# Install Xvfb.
# ----------------------------------------------------------------------------

# Xvfb is a headless X server that will allow Firefox, Chromium, etc, to run.
# Note that there may be various dependencies that still need to be installed
# on a server, such as font support.

pkgs = %w{
  xvfb
  x11-xkb-utils
  xfonts-100dpi
  xfonts-75dpi
  xfonts-scalable
  xserver-xorg-core
}
pkgs.each do |pkg|
  package pkg
end

# ----------------------------------------------------------------------------
# Install Firefox.
# ----------------------------------------------------------------------------

# The dbus-x11 package prevents some errors from occurring when using Firefox.
package 'dbus-x11'

# The package resource has a timeout of 600 seconds that can't be changed
# without platform-specific monkey-patching. The Firefox install is big and will
# often push over this limit.
#
# The workaround here is to use execute.
if node[:platform_family] == 'debian'
  execute 'apt-get -q -y install firefox' do
    timeout node['protractor-selenium-server']['browser-install-timeout']
  end
else
  package 'firefox'
end

# ----------------------------------------------------------------------------
# Install Chromium and Chromedriver.
# ----------------------------------------------------------------------------

# The same workaround as for Firefox, and for the same reasons.
if node[:platform_family] == 'debian'
  execute 'apt-get -q -y install chromium-browser' do
    timeout node['protractor-selenium-server']['browser-install-timeout']
  end
else
  package 'chromium-browser'
end

execute 'npm install -g chromedriver'

# ----------------------------------------------------------------------------
# Install PhantomJS and dependencies.
# ----------------------------------------------------------------------------

execute 'npm install -g phantomjs'

# The Ghostdriver PhantomJS webdriver interface creates its log at
# /phantomjsdriver.log by default.
#
# This doesn't seem to be something that can be changed through the Protractor
# or Selenium APIs, which is annoying.
#
# So create the file and give it lenient permissions so that things don't fail.
execute 'touch /phantomjsdriver.log'
execute 'chmod 666 /phantomjsdriver.log'

# On a headless Ubuntu box there are some items needed by PhantomJS that
# are not present. PhantomJS will silently fail if they aren't there - which is
# a real pain to deal with. This is the crucial item:
package 'libfontconfig1-dev'

# TODO: variant package lists for other distributions.

# ----------------------------------------------------------------------------
# Selenium standalone JAR.
# ----------------------------------------------------------------------------

# This user will own the logs, the install directory, and the service process.
# Browsers will run as this user, since Selenium is piloting them.
user node['protractor-selenium-server']['selenium']['user'] do
  # In Debian/Ubuntu you need both supports and home defined to create the
  # home directory.
  supports :manage_home => true
  home "/home/#{node['protractor-selenium-server']['selenium']['user']}"
  # Not strictly necessary, but helpful when debugging as this user.
  shell '/bin/bash'
end

# The Selenium standalone server JAR will be downloaded to this directory.
directory node['protractor-selenium-server']['selenium']['install-dir'] do
  owner node['protractor-selenium-server']['selenium']['user']
  recursive true
end

# Obtain the Selenium standalone server JAR file.
remote_file "#{node['protractor-selenium-server']['selenium']['install-dir']}/selenium-server-standalone-#{node['protractor-selenium-server']['selenium']['version']}.jar" do
  # URL of the form:
  # http://selenium-release.storage.googleapis.com/2.41/selenium-server-standalone-2.41.0.jar
  source "http://selenium-release.storage.googleapis.com/#{node['protractor-selenium-server']['selenium']['version'].split('.').reverse.drop(1).reverse.join('.')}/selenium-server-standalone-#{node['protractor-selenium-server']['selenium']['version']}.jar"
  action :create_if_missing
  mode 0644
end

# ------------------------------------------------------------------
# Protractor installation.
# ------------------------------------------------------------------

execute 'npm install -g protractor jasmine-node'
