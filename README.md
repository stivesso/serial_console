# serial_console

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with serial_console](#setup)
    * [What serial_console affects](#what-serial_console-affects)
    * [Setup requirements](#setup-requirements)
3. [Usage - Configuration options and additional functionality](#usage)
    * [Parameters (and default values)](#parameters)
    * [Sample Usage](#sample-usage)
4. [Limitations and Known Issues](#limitations-and-known-issues)
    * [Note for some UEFI Systems](#note-for-some-uefi-systems)
5. [Development - Guide for contributing to the module](#development)
6. [TODO](#TODO)
7. [Contributors](#contributors)

## Module Description

The serial_console module automates the configuration of Linux Systems to have both their Console Outputs and the ability to log on to the system via the serial port. 

With such configuration in place, Management and Administration of Linux Systems through most of the Out of Band Management Platforms Console (HP ILO/vsp, ORACLE SUN ALOM/Console, DELL DRAC/Console, Virtual Machine ttySX...) is greatly simplified.

Many options are available for the customization of that configuration in order to fit your environment's needs. 

## Setup

From Puppet Forge,
```sh
puppet module install stivesso-serial_console
```
From Github,
```sh
git clone https://github.com/stivesso/serial_console
```
### What serial_console affects

* GRUB Configuration (Kernel parameters)  
_Edits Grub Configuration to add or remove Console parameters to the Kernel Parameters_
* Init (Sysvinit, Upstart or Systemd) Configuration  
_Configure Init Service (Sysvinit, Upstart or Systemd) to support serial console logins_

### Setup Requirements

Serial_console requires:  

- pluginsync = true (Puppet Configuration)  
- puppetlabs/stdlib (>= 4.9.0)
- herculesteam/augeasproviders_grub (>= 2.3.0)

## Usage

### Parameters

There are 06 main parameters used to control the Serial Console behaviours: 

**`serial_port`** :  _Serial Port_  
String that specifies the Serial Port to use (ttySx). 

- _default:_   
-- _**ttyS1**_ for Physical Servers (except Oracle/Sun Servers where the default is set to _**ttyS0**_).  
-- _**ttyS0**_ for Virtual Servers

**`baud_rate`** : _Baud Rate_  
Integer to set the baud rate (rate at which information is transferred) of the Serial Port.
- _default:_ _**115200**_ except for Oracle/Sun Servers where the default is set to _**9600**_.

**`no_rhgb_quiet`** : _Rhgb and Quiet_  
Boolean to set whether we want to disable rhgb and quiet mode or not.
- _default:_ _**true**_ (disabled)

_rhgb: (RedHat graphical boot) This is a GUI mode booting screen with most of the information hidden._
_quiet: hides the majority of boot messages before rhgb starts. 
These two are disabled by default (linked in the same settings)_

**`root_login_console`** : _Root Login Console_    
Boolean to determine whether the root is allowed to login on the console directly or not.
- _default:_ _**true**_ (Root Login through Serial Console allowed)

**`regular_console_enabled`** : _Regular Console (tty0)_  
Boolean to determine whether the Regular Console (tty0) is needed or not,
- _default:_ _**true**_ (needed and enabled as Secondary Console, this can be switch to Primary console with the _serial_primary_console_ described below) 

_Secondary Console means that the console is available for Login, but Init script messages are not being sent to that console (they are only sent to the primary console)_

**`serial_primary_console`** : _Set Serial As primary Console_   
Boolean to determine whether the serial is the primary console or not (this setting only makes sense when the regular console is enabled)
- _default:_ _**true**_ (Serial Console set as primary console)

_Again, Init script messages are sent only to the primary console, the secondary console has only the Login ability_

### Sample Usage

To accept default class parameters (the ones described above):
```sh
include serial_console
```
To modify some of the default settings,
```sh
    class { 'serial_console':
      serial_port              => 'ttyS1',
      baud_rate                => '115200',
      no_rhgb_quiet            => true,
      root_login_console       => true,
      regular_console_enabled  => true,
      serial_primary_console   => true,
    }
```
The module also supports (and encourages) configuration through hiera. Below is an example of such configuration:
```yaml
---
serial_console::serial_port:               "ttyS1"
serial_console::baud_rate:                 "115200"
serial_console::no_rhgb_quiet:             true
serial_console::root_login_console:        true
serial_console::regular_console_enabled:   true
serial_console::serial_primary_console:    true
```

## Limitations and Known Issues
#### Note for some UEFI Systems

On UEFI Systems, the module used for grub configuration may not be able to locate the Grub configuration file and will send the following error:  
_Could not evaluate: Cannot find grub.cfg location to use with grub-mkconfig_  
A PR has already been submitted to correct that little Issue, but while waiting, the workaround is to add _"/etc/grub2-efi.cfg"_ to the array on line 151 of _augeasproviders_grub/lib/puppet/provider/kernel_parameter/grub2.rb_ ([more details here](https://github.com/hercules-team/augeasproviders_grub/pull/21/files))

## Development
I happily accept bug reports and pull requests via github,  
https://github.com/stivesso/serial_console

- Fork it
- Create a feature branch
- Write a failing test
- Write the code to make that test pass
- Refactor the code
- Submit a pull request

## TODO

- Add GRUB Full Control from Serial Console

## Contributors

- The module is written and being maintained by: [stivesso](https://github.com/stivesso) 
