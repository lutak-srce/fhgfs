def get_redhat_fhgfs_version
  version = Facter::Util::Resolution.exec('/bin/rpm -qa fhgfs-utils')
  if match = /^fhgfs-utils-(\d+\.\d+\..*)$/.match(version)
    match[1]
  else
    nil
  end
end

Facter.add('fhgfs_version') do
  setcode do
    case Facter.value('osfamily')
      when 'RedHat'
        get_redhat_fhgfs_version()
      else
        nil
    end
  end
end

# Backward compatibilty: this facts name was a bug, but code depending
# on it was deployed to production so we can't just phase it out :(
Facter.add('beegfs_version') do
  setcode do
    case Facter.value('osfamily')
      when 'RedHat'
        get_redhat_fhgfs_version()
      else
        nil
    end
  end
end
