# Class: serial_console
# ===========================
#
# Puppet module which aims to automatically configure Linux Console Redirection 
# Be it: HP ILO VSP, Oracle Sun ILOM, Virtual Machine ttySX... )
#
# Variables and Parameters
# ------------------------
#
# $serial_port :  Serial Port
# Specify the ttySx Port we are willing to use. 
# By default, It is set this to ttyS1 (except for Oracle/Sun Servers where it is set to ttyS0). 
#
# $baud_rate : Baud Rate
# The baud rate is the rate at which information is transferred on the Serial Port.
# By default, it is set to 115200 (except for Oracle/Sun Servers where it is set to 9600). 
#
# $no_rhgb_quiet : Rhgb and Quiet
# rhgb: (redhat graphical boot) This is a GUI mode booting screen with most of the information hidden.
# quiet: hides the majority of boot messages before rhgb starts. 
# These two are disabled by default (linked in the same settings)
#
# $root_login_console : Root Login Console
# Whether the root is allowed to login on the console directly.
# By default, this is allowed

#
# Examples
# --------
#
# @example
#    class { 'serial_console':
#      serial_port        => 'ttyS1',
#      baud_rate          => '115200',
#      no_rhgb_quiet      => true,
#      root_login_console => true,
#    }
#
# Authors
# -------
#
# Steve ESSO <stivesso@gmail.com>
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

  validate_string($serial_port)
  validate_integer($baud_rate)
  validate_bool($no_rhgb_quiet,$root_login_console)

  if $::initsystem {
    class {'serial_console::dynamic_config':
    } -> # and then apply static configuration
    class {'serial_console::static_config':
      serial_port   => $serial_port,
      baud_rate     => $baud_rate,
      no_rhgb_quiet => $no_rhgb_quiet,
    } -> # and then set root account if required
    class {'serial_console::root_on_console':
      serial_port        => $serial_port,
      root_login_console => $root_login_console,
    }
  } else {
    notify {'For now, serial_console is only available on Linux based System':}
  }

}
