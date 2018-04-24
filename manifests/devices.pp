# Configure multiple devices in Hiera.

class puppet_device::devices {

  # Validate node.

  unless has_key($facts, 'aio_agent_version') {
    fail("Classification Error: 'puppet_device::devices' declared on a device instead of an agent.")
  }

  # Avoid the Hiera 5 'hiera_hash is deprecated' warning.

  if ( (versioncmp($::clientversion, '4.9.0') >= 0) and (! defined('$::serverversion') or versioncmp($::serverversion, '4.9.0') >= 0) ) {
    $devices = lookup('puppet_device::devices', Hash, 'hash', {})
  } else {
    $devices = hiera_hash('puppet_device::devices', {})
  }

  $devices.each |$title, $device| {
    puppet_device {$title:
      name         => $device['name'],
      type         => $device['type'],
      url          => $device['url'],
      debug        => $device['debug'],
      run_interval => $device['run_interval'],
      run_via_exec => $device['run_via_exec'],
    }
  }

}
