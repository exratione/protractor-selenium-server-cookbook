#
# Install all of the line items needed to run Protractor.
#

# ----------------------------------------------------------------------------
# Install Xvfb.
# ----------------------------------------------------------------------------

# Xvfb is a headless X server that will allow Firefox, Chromium, etc, to run.
# Note that there may be various dependencies that still need to be installed
# on a server, such as font support.

# TODO: variant package lists for other distributions.

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

# The dbus-x11 package prevents some errors from Firefox.
package 'dbus-x11'
package 'firefox'

# ----------------------------------------------------------------------------
# Install Chromium and Chromedriver.
# ----------------------------------------------------------------------------

package 'chromium-browser'
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
# a real pain to deal with.
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
  source "http://selenium.googlecode.com/files/selenium-server-standalone-#{node['protractor-selenium-server']['selenium']['version']}.jar"
  action :create_if_missing
  mode 0644
end

# ------------------------------------------------------------------
# Protector installation.
# ------------------------------------------------------------------

execute 'npm install -g protractor jasmine-node'
