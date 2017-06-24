#
# = Class: fhgfs::client
#
# This module manages FhGFS client
#
class fhgfs::client (
  $version   = $fhgfs::version,
  $mounts    = 'puppet:///private/fhgfs/fhgfs-mounts.conf',
  $netfilter = '',
) inherits fhgfs {

  include ::tools::kernel::devel

  package { 'fhgfs-helperd':
    ensure   => $version,
  }

  package { 'fhgfs-client':
    ensure   => $version,
    require  => Package['kernel-devel'],
  }

  package { 'fhgfs-helperd': }
  package { 'fhgfs-client': }

  service { 'fhgfs-helperd':
    ensure   => running,
    enable   => true,
    provider => redhat,
    require  => Package['fhgfs-helperd'],
  }

  file { '/etc/fhgfs/fhgfs-mounts.conf':
    require => Package['fhgfs-client'],
    source  => $mounts,
  }

  file { '/etc/fhgfs/fhgfs-client-autobuild.conf':
    require => Package['fhgfs-client'],
    content => template('fhgfs/fhgfs-client-autobuild.conf.erb'),
  }

  service { 'fhgfs-client':
    ensure   => running,
    enable   => true,
    provider => redhat,
    require  => [
      Package['fhgfs-client'],
      Service['fhgfs-helperd'],
      File['/etc/fhgfs/fhgfs-mounts.conf'],
      File['/etc/fhgfs/fhgfs-client.conf'],
      File['/etc/fhgfs/fhgfs-client-autobuild.conf'],
    ],

  }

}
