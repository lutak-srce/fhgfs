# Class: fhgfs
#
# Base FhGFS class
#
class fhgfs (
  $mgmtd_host = 'localhost',
  $meta_directory = '/meta',
  $storage_directory = '/storage',
  $mgmtd_directory = '/mgmtd',
  $client_auto_remove_mins = 0,
  $meta_space_low_limit = '5G',
  $meta_space_emergency_limit = '3G',
  $storage_space_low_limit = '100G',
  $storage_space_emergency_limit = '10G',
  $version = '2011.04.r21-el6',
  $major_version = '2011',
  $interfaces_file = '',
  $net_filter_file = '',
) {
  case $major_version {
    default: {
      require yum::repo::fhgfs
    }
    '2011': {
      require yum::repo::fhgfs
    }
    '2012': {
      require yum::repo::fhgfs2012
    }
    '2014': {
      require yum::repo::fhgfs2014
    }
  }

  package { 'fhgfs-utils':
    ensure => $version,
  }
  file { '/etc/fhgfs/fhgfs-client.conf':
    require => Package['fhgfs-utils'],
    content => template('fhgfs/fhgfs-client.conf.erb'),
  }
}
