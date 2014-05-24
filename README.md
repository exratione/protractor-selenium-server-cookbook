# Protractor and Selenium Standalone Cookbook

This cookbook presently installs the following items for a Debian-based Linux
server, so as to allow headless end to end in-browser testing of AngularJS web
applications via [Protractor][0]:

  * Protractor
  * Selenium Standalone Server
  * Xvfb
  * Chromium
  * Firefox
  * PhantomJS

## OS Support

Currently this cookbook only supports Debian-based Linux distros such as Ubuntu.
It is best suited to provisioning a Vagrant VM, either for experimentation or as
a part of a build or test process.

## This is a Lengthy Provisioning Process

Installing Java, Firefox, and Chromium take a long time, especially if the
server is not on a fast connection.

## Cookbook Dependencies

This depends on the following cookbooks:

  * java
  * n-and-nodejs

Note the use of [n-and-nodejs][1] rather than the more commonly used [nodejs][2]
cookbook. If using [Librarian-chef][3] to manage dependences, then include these
custom cookbooks in the project Cheffile as follows:

```
cookbook 'n-and-nodejs',
  :git => 'https://github.com/exratione/n-and-nodejs-cookbook',
  :ref => 'v0.0.2'

cookbook 'protractor-selenium-server',
  :git => 'https://github.com/exratione/protractor-selenium-server-cookbook',
  :ref => 'v0.0.5'
```

## Selenium and Xvfb Services

The `protractor-selenium-server::services` recipe sets up services for both Xvfb
and the Selenium standalone server.

Xvfb is a minimal X Server implementation to allow headless testing of browsers,
and the services ensure that it and Selenium coordinate sufficiently to run end
to end tests in Chromium and Firefox on a headless server.

## Attributes

An example of setting the cookbook attributes, along with those of its
dependencies.

```
default_attributes(
  'java' => {
    'install_flavor' => 'oracle',
    'jdk_version' => '7',
    'oracle' => {
      'accept_oracle_download_terms' => true
    }
  },
  'n-and-nodejs' => {
    'n' => {
      'version' => '1.2.1'
    },
    'nodejs' => {
      'version' => 'stable'
    }
  },
  'protractor-selenium-server' => {
    # Timeout in seconds to install Firefox and Chromium via packages. This can
    # indeed take a long time on a bare server.
    'browser-install-timeout' => 1200,
    # Where is Selenium installed, and the version to put in place.
    'selenium' => {
      'install-dir' => '/usr/local/share/selenium',
      'log-dir' => '/var/log/selenium',
      'version' => '2.41.0',
    },
    # Necessary configuration for Xvfb.
    'xvfb' => {
      'display' => '10',
      'resolution' => '1024x768x24'
    }
  }
)
```

## Firefox Notes

Firefox will issue the following complaint if launched standalone on a display
managed by Xvfb:

```
 Xlib: extension "RANDR" missing on display ":10"
```

The recommended solution is to launch Xvfb with this option:

```
-extension RANDR
```

As of Q4 2013 this does not at prevent the above error message, however.
Fortunately the message is not fatal and Firefox will still work just fine.

## PhantomJS Notes

If attempting to use use PhantomJS for testing, note that when using PhantomJS
through Selenium and the Webdriver bindings, as of Q4 2013 there appears to be
no ability to change the log file location to be anything other than
`/phantomjsdriver.log`.

It is an easy change on the command line if invoking PhantomJS directly, but
there is no option that will pass through Protractor or Selenium standalone
configuration. As a workaround this file is created during provisioning and made
globally writable.

## Selenium Standalone Server Notes

There is a known issue with the Selenium standalone server (with Java, really)
in which it [fails to bind to its port on restart][4] after receiving a SIGTERM.
To avoid this you must pass this argument to Java on the command line:

```
-Djava.security.egd=file:/dev/./urandom
```

This is done in the init.d script for Selenium here. If you are starting a
Selenium standalone instance manually in your Protractor script, then you would
have to add the following argument to the options:

```
seleniumArgs: ['-Djava.security.egd=file:/dev/./urandom'],
```

[0]: https://github.com/angular/protractor
[1]: https://github.com/exratione/n-and-nodejs-cookbook
[2]: https://github.com/mdxp/nodejs-cookbook
[3]: https://github.com/applicationsonline/librarian-chef
[4]: http://stackoverflow.com/questions/14058111/selenium-server-doesnt-bind-to-socket-after-being-killed-with-sigterm
