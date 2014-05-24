#
# Set up and launch services for Xvfb and the Selenium standalone server.
#

# ----------------------------------------------------------------------------
# Xfvb service.
# ----------------------------------------------------------------------------

# The service will be notified to start once the template file is placed.
service 'xvfb' do
  supports [:status, :restart]
  action :nothing
end

# Place the template file for the service script.
template 'xvfb' do
  path '/etc/init.d/xvfb'
  source 'xvfb-debian-init-d.erb'
  owner 'root'
  group 'root'
  mode '0755'
  notifies :enable, 'service[xvfb]'
  notifies :start, 'service[xvfb]'
end

# TODO: init scripts for other distributions.

# ----------------------------------------------------------------------------
# Selenium standalone server service.
# ----------------------------------------------------------------------------

# Create the service log directory.
directory node['protractor-selenium-server']['selenium']['log-dir'] do
  owner node['protractor-selenium-server']['selenium']['user']
  recursive true
end

# The service will be notified to start once the template file is placed.
service 'selenium-standalone' do
  supports [:status, :restart]
  action :nothing
end

# Place the template file for the service script.
template 'selenium-standalone' do
  path '/etc/init.d/selenium-standalone'
  source 'selenium-debian-init-d.erb'
  owner 'root'
  group 'root'
  mode '0755'
  notifies :enable, 'service[selenium-standalone]'
  notifies :start, 'service[selenium-standalone]'
end
