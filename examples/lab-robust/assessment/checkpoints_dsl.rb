passing_score 13

# We use a unique symbol for the checkpoint, so that we can solve the
# localization issue elsewhere.
#
# en: Create GCE instance in specified zone
checkpoint :gce_instance_created do
  value 5
  api :gcp
  services "ComputeV1"

  check do |gce|
    resp = gce.list_instances
    if resp&.items&.try(:any?)
      score 5, :success
    end

    # en: No instance detected. Double check you created it in the correct region.
    score 0, :instance_not_detected
    # ... or ...
    message :instance_not_detected
  end
end

# en: Create a new persistent disk named 'mydisk' in specified zone
checkpoint :persistent_disk_created do
  value 5
  api :gcp
  services "ComputeV1"

  check do |gce|
    disk = gce.get_disk 'mydisk'
    if disk
      score 5, :success
    end

    # en: No persistent disk named 'mydisk' created. Double check you gave
    #     your disk the right name.
    message :disk_not_detected
  end
end

# en: Attach 'mydisk' to the VM
checkpoint :attach_disk do
  value 5
  api :gcp
  services "ComputeV1"

  check do |gce|
    disk = gce.get_disk 'mydisk'
    if disk&.users&.any?
      score 5, :success
    end

    # en: 'mydisk' is not attached to a GCE instance. Double check you
    #     attached the right disk.
    message :disk_not_attached
  end
end
