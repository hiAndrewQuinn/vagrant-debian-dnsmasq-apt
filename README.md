# `vagrant-debian-dnsmasq-apt`: An experiment in SSH forwarding

Recently at work I've had to figure out how to get `apt` to work on a Linux box that doesn't have any Internet connectivity itself, but is connected to another Linux box that's working just fine. I decided to head home that day and first mock up my approach using [Vagrant](https://www.vagrantup.com/), since this is probably knowledge I will want to be able to reference later on as well.

## Quickstart

### The setup

Clone this repo, then use

```bash
vagrant up
```

to get these VMs working. If you run

```bash
# From your local box
vagrant ssh internet_server

# From within internet_server - password is `vagrant`
ssh vagrant@192.168.56.3

# From within internal_server, from within internet_server - password is, again, `vagrant`
ssh vagrant@192.168.56.2
```

you should be able to SSH from `internet_server` to `internal_server`. Then the fun begins...

... If you

```bash
# From within internet_server
ssh vagrant@192.168.56.3 "ping -c 3 8.8.8.8"
# Should return 3 normal pings.
```

you will see that `internal_server` can still very much reach the Internet. We do not want this. So we are going to shut this down, with

```bash
# From within internet_server
ssh vagrant@192.168.56.3 "sudo ip link set dev eth0 down"
sleep 10

# The confirm you can still SSH in as per usual, even though you've just eviscerated an Ethernet interface.
ssh vagrant@192.168.56.3 "ip a"
```

Finally, run

```bash
# From within internet_server
ssh vagrant@192.168.56.3 "ping -c 3 8.8.8.8"
# Should return NOTHING. NOTHING AT ALL
```

to ensure all is lost.

Let's just make sure we can't access the _thing we care about_ here, one more time:

```bash
# From within internet_server
sudo apt update
# should work fine

ssh vagrant@192.168.56.3

# From within internal_server
sudo apt udpate
# should fail
```

### The SOCKS5 proxy



## What did we learn, kids?

- In order to SOCKS5 proxy correctly, your `internet_server` and your `internal_server` must form an *SSH cycle* somewhere -- `internet_server` must be able to reach `internal_server` and vice versa. Ask yourself: Could I SSH back to where I started without ever exiting an earlier SSH session?
