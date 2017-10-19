module Checkpoints
  passing_score 13

  # We use a unique symbol for the checkpoint, so that we can solve the
  # localization issue elsewhere.
  #
  # en: Create GCE instance in specified zone
  checkpoint :gce_instance_created do
    value 5
    api :gcp
    services "ComputeV1"

    check do
      gce = handles[0]
      resp = gce.list_instances
      if resp&.items&.try(:any?)
        complete 5
      end

      # en: No instance detected. Double check you created it in the correct region.
      helper_text :instance_not_detected
    end
  end

  # en: Create a new persistent disk named 'mydisk' in specified zone
  checkpoint :persistent_disk_created do
    value 5
    api :gcp
    services "ComputeV1"

    check do
      gce = handles[0]
      disk = gce.get_disk 'mydisk'
      if disk
        complete 5
      end

      # en: No persistent disk named 'mydisk' created. Double check you gave
      #     your disk the right name.
      helper_text :disk_not_detected
    end

  end

  # en: Attach 'mydisk' to the VM
  checkpoint :attach_disk do
    value 5
    api :gcp
    services "ComputeV1"

    check do
      gce = handles[0]
      disk = gce.get_disk 'mydisk'
      if disk&.users&.any?
        complete 5
      end

      # en: 'mydisk' is not attached to a GCE instance. Double check you
      #     attached the right disk.
      helper_text :disk_not_attached
    end
  end
end
