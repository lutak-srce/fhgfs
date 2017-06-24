# Define: fhgfs::client
#
# This module manages FhGFS client
#
define fhgfs::mount (
  $cfg,
  $mnt,
  $subdir     = '',
  $cfg_source = '',
  $netfilter  = ''
  ) {

  file { $mnt:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0755',
  }

  if $cfg_source == '' {
    file { "/etc/fhgfs/${cfg}":
      require => Package['fhgfs-client'],
      source  => "puppet:///files/fhgfs/${subdir}/${cfg}",
    }
  } else {
    file { "/etc/fhgfs/${cfg}":
      require => Package['fhgfs-client'],
      content => template($cfg_source),
    }
  }

}
