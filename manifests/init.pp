# Class: serial_console
# ===========================
#
# Full description of class serial_console here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'serial_console':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class serial_console (
  $serial_port         = $serial_console::params::serial_port,
  $baud_rate           = $serial_console::params::baud_rate,
  $no_rhgb_quiet       = $serial_console::params::no_rhgb_quiet,
  $root_login_console  = $serial_console::params::root_login_console,
) inherits serial_console::params {

  if ($::initsystem == 'systemd') or ($::initsystem == 'upstart'){
    class {'serial_console::dynamic_config':
    } -> # and then apply static configuration
    class {'serial_console::static_config':
      serial_port   => $serial_port,
      baud_rate     => $baud_rate,
      no_rhgb_quiet => $no_rhgb_quiet,
    }
  } else {
    notify {'For now, serial_console is only available on Linux based System with Systemd and Upstart':}
  }

}
