# Class: fhgfs::client
#
# This module manages FhGFS client
#
class fhgfs::storage (
  $enable               = false,
  $storage_directory    = $fhgfs::storage_directory,
  $mgmtd_host           = $fhgfs::mgmtd_host,
  $version              = $fhgfs::version,
  $interfaces_file      = $fhgfs::interfaces_file,
  $net_filter_file      = $fhgfs::net_filter_file,
  $allow_first_run_init = true,
  $num_workers          = 16,
) inherits fhgfs {
  package { 'fhgfs-storage':
    ensure => $version,
  }
  file { '/etc/fhgfs/fhgfs-storage.conf':
    require => Package['fhgfs-storage'],
    content => template('fhgfs/fhgfs-storage.conf.erb'),
  }
  service { 'fhgfs-storage':
    ensure    => running,
    enable    => $enable,
    provider  => redhat,
    require   => Package['fhgfs-storage'],
    subscribe => File['/etc/fhgfs/fhgfs-storage.conf'];
  }
}
