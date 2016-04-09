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
# $regular_console_enabled : Regular Console (tty0) still used
# Determine whether or not the Regular Console (tty0) is needed
# By default, it is needed and enable as Secondary Console
# meaning that though it is available for Login, Init script messages
# are being sent to only the serial console (that can be changed with
# the next settings)
#
# $serial_primary_console : Set Serial As primary Console
# Determine whether or not the serial is the primary console
# Note that if we need init script messages to be seen on the serial console 
# It should be made the primary, by default the serial console is the primary
#
# 
#
#
# Examples
# --------
#
# @example
#    class { 'serial_console':
#      serial_port              => 'ttyS1',
#      baud_rate                => '115200',
#      no_rhgb_quiet            => true,
#      root_login_console       => true,
#      regular_console_enabled  => true,
#      serial_primary_console   => true,
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
  $serial_port             = $serial_console::params::serial_port,
  $baud_rate               = $serial_console::params::baud_rate,
  $no_rhgb_quiet           = $serial_console::params::no_rhgb_quiet,
  $root_login_console      = $serial_console::params::root_login_console,
  $regular_console_enabled = $serial_console::params::regular_console_enabled,
  $serial_primary_console  = $serial_console::params::serial_primary_console,
) inherits serial_console::params {

  validate_string($serial_port)
  validate_integer($baud_rate)
  validate_bool($no_rhgb_quiet,$root_login_console)
  validate_bool($regular_console_enabled, $serial_primary_console)

  if $::initsystem {
    class {'serial_console::terminal_config':
      serial_port             => $serial_port,
      baud_rate               => $baud_rate,
    } -> # and then apply static configuration
    class {'serial_console::kernel_config':
      serial_port             => $serial_port,
      baud_rate               => $baud_rate,
      no_rhgb_quiet           => $no_rhgb_quiet,
      regular_console_enabled => $regular_console_enabled,
      serial_primary_console  => $serial_primary_console,
    } -> # and then set root account if required
    class {'serial_console::root_on_console':
      serial_port        => $serial_port,
      root_login_console => $root_login_console,
    }
  } else {
    notify {'For now, serial_console is only available on Linux based System':}
  }

}
