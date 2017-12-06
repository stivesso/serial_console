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
  String                   $serial_port,
  Variant[Integer, String] $baud_rate,
  Boolean                  $no_rhgb_quiet,
  Boolean                  $root_login_console,
  Boolean                  $regular_console_enabled,
  Boolean                  $serial_primary_console,
) {

  if $::initsystem {
    contain serial_console::terminal_config
    contain serial_console::kernel_config
    contain serial_console::root_on_console

    Class['serial_console::terminal_config']
    -> Class['serial_console::kernel_config']
    -> Class['serial_console::root_on_console']

  } else {
    notify {'For now, serial_console is only available on Supported Linux based System':}
  }

}
