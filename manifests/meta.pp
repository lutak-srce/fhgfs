# Class: fhgfs::client
#
# This module manages FhGFS client
#
class fhgfs::meta (
  $enable = false,
  $meta_directory       = $fhgfs::meta_directory,
  $mgmtd_host           = $fhgfs::mgmtd_host,
  $version              = $fhgfs::version,
  $interfaces_file      = $fhgfs::interfaces_file,
  $net_filter_file      = $fhgfs::net_filter_file,
  $allow_first_run_init = true,
  $num_workers          = 0,
) inherits fhgfs {
  package { 'fhgfs-meta':
    ensure => $version,
  }
  file { '/etc/fhgfs/fhgfs-meta.conf':
    require => Package['fhgfs-meta'],
    content => template('fhgfs/fhgfs-meta.conf.erb'),
  }
  service { 'fhgfs-meta':
    ensure    => running,
    enable    => $enable,
    provider  => redhat,
    require   => Package['fhgfs-meta'],
    subscribe => File['/etc/fhgfs/fhgfs-meta.conf'];
  }
}
