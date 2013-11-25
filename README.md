Protractor and Selenium Standalone Cookbook
===========================================

This cookbook presently installs the following items for an Ubuntu or Debian
server, to allow headless end to end in-browser testing of AngularJS web
applications via [Protractor][0]:

  * Protractor
  * Selenium Standalone Server
  * Xfvb
  * Chromium
  * Firefox
  * PhantomJS

OS Support
----------

Currently this cookbook offers a limited variety of OS support and is best
suited to provisioning a Vagrant VM, used either for experimentation or in a
build process.

Selenium and Xvfb Services
--------------------------

The protractor-selenium-server::services recipe sets up services for both Xfvb
and the Selenium standalone server.

Xvfb is a minimal X Server implementation to allow headless testing of browsers,
and the services ensure that it and Selenium coordinate sufficiently to run end
to end tests in Chromium and Firefox on a headless server.

PhantomJS Notes
---------------

If attempting to use use PhantomJS for testing, note that when using PhantomJS
through Selenium and the Webdriver bindings, as of Q4 2013 there appears to be
no ability to change the log file location to be anything other than
`/phantomjsdriver.log`.

It is an easy change on the command line if invoking PhantomJS directly, but
there is no option that will pass through Protractor or Selenium standalone
configuration. As a workaround this file is created during provisioning and made
globally writable.

There are other blocking issues as of Q4 2013 that prevent easy use of PhantomJS
with Protractor. See, for example:

[https://github.com/angular/protractor/issues/85][1]

Selenium Standalone Server Notes
--------------------------------

There is a known issue with the Selenium standalone server (with Java, really)
in which it [fails to bind to its port on restart][2] after receiving a SIGTERM.
To avoid this you must pass this argument to Java on the command line:

```
-Djava.security.egd=file:/dev/./urandom
```

This is done in the init.d script for Selenium here. If you are starting a
Selenium standalone instance manually in your Protractor script, then you would
have to do something like this:

```
seleniumArgs: ['-Djava.security.egd=file:/dev/./urandom'],
```

[0]: https://github.com/angular/protractor
[1]: https://github.com/angular/protractor/issues/85
[2]: http://stackoverflow.com/questions/14058111/selenium-server-doesnt-bind-to-socket-after-being-killed-with-sigterm
