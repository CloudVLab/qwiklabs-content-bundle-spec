def gce_instance_created(gce)
  resp = gce.list_instances
  if resp&.items&.try(:any?)
    score 5, :success
  end

  return 0, :instance_not_detected
end

def persistent_disk_created(gce)
  disk = gce.get_disk 'mydisk'
  if disk
    score 5, :success
  end

  return 0, :disk_not_detected
end

def check_disk_attached(gce)
  disk = gce.get_disk 'mydisk'
  if disk&.users&.any?
    return 5, :success
  end

  return 0, :disk_not_attached
end
