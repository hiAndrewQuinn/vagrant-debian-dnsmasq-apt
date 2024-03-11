Vagrant.configure("2") do |config|
  # Define the first machine with internet access
  config.vm.define "internet_server" do |internet|
    internet.vm.box = "debian/contrib-buster64"
    # Configure public network to allow internet access
    internet.vm.network "public_network"
    internet.vm.network "private_network", ip: "192.168.56.2"
    # Optional: Forward SSH port for easier access
    internet.vm.network "forwarded_port", guest: 22, host: 2222, id: "ssh"

    # Provisioning script to enable password authentication and set user password
    internet.vm.provision "shell", inline: <<-SHELL
      # Enable password authentication
      sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
      sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

      # Reload SSH to apply configuration changes
      systemctl reload sshd

      # Set the password for the vagrant user
      echo 'vagrant:vagrant' | chpasswd
    SHELL
  end

  # Define the second machine that can only SSH to the first one
  config.vm.define "internal_server" do |internal|
    internal.vm.box = "debian/contrib-buster64"
    # Configure a private network. Adjust the IP as needed.
    internal.vm.network "private_network", ip: "192.168.56.3"
    # Provisioning script to set up iptables rules

    # Provisioning script to enable password authentication and set user password
    internal.vm.provision "shell", inline: <<-SHELL
      # Enable password authentication
      sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
      sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

      # Reload SSH to apply configuration changes
      systemctl reload sshd

      # Set the password for the vagrant user
      echo 'vagrant:vagrant' | chpasswd
    SHELL
  end
end
