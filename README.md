# lokinetd-macos - the missing lokinet daemon for macOS

A simple utility to enable running Lokinet on macOS without causing issues with
other software that may alter DNS configurations, since macOS Lokinet completely
overrides global DNS resolution

## Installation

First ensure that `curl` or `wget` is already installed on your machine.

This will add the installation folder to your env PATH so you can run from anywhere.

[View the installation script here](./install.sh)

```sh
curl -fsSL https://raw.githubusercontent.com/entropi-hk/lokinetd-macos/main/install.sh | bash
```

```sh
wget -qO- https://raw.githubusercontent.com/entropi-hk/lokinetd-macos/main/install.sh | bash
```

## Usage

- `lokinet up [LOKINET_PATH]`: Start Lokinet daemon and reconfigure the hardcoded DNS configuration. Optionally provide path to Lokinet executable.
- `lokinet down [LOKINET_PATH]`: Stop the Lokinet daemon. Optionally provide path to Lokinet executable.
- `lokinetd update`: Update lokinetd-macos to latest available version.
- `lokinetd version`: Display current version of lokinetd-macos.

## Why?

Some software such as [Surge](https://nssurge.com/), [dnscrypt-proxy](https://github.com/DNSCrypt/dnscrypt-proxy) 
and others rely on DNS hijacking, and the current macOS implementation of Lokinet
does not allow for configuration and totally hijacks system DNS *BEFORE* any other
software gets a change to perform their intended purpose.

When starting the Lokinet macOS app, it starts it's macOS Network Extension
which sets Lokinet as the global DNS provider. This is so that it can resolve
.loki and .snode domains.

But many other software options allow to do the same thing with a much higher
level of configurability and flexibility. And this can prevent that from happening.
If you have your own custom DNS setup, chances are you still want to use them
instead of whichever resolver Lokinet uses.

The Lokinet DNS resolver can also cause issues because it resolves domains *before*
reaching other software such as Surge or [Little Snitch](https://www.obdev.at/products/littlesnitch/index.html).
This can cause issues if you have any blocking/routing rules which rely on domain
names and not just IP addresses (which can always change).

So this little utility starts up Lokinet but removes the troublesome issues caused
by the Lokinet Network Extension, allowing you to use all your custom DNS setups
as normal, whilst still allowing you to properly resolve .loki and .snode domains.

## What does it do?

This simple utility does the following:
1. Starts Lokinet (non-gui mode) - please ensure to [install the Lokinet app first!](https://lokinet.org/)
2. Removes the hardcoded global DNS override from your Mac's settings using `scutil`,
   *not* /etc/resolv.conf or other methods
3. That's it! You can now access .loki domains as normal, AND keep your existing
   DNS & firewall/network blocking rules in place (provided you have other software 
   to enable customising your system's DNS resolution)

`sudo` is required as it is required by macOS to make changes to network configuration.
You can [view the simple script here](./lokinet)

## Important

This small utility assumes that you are using other DNS configuration software,
because since it removes Lokinet's default *global* DNS resolver, it does not replace
it with anything. This can be fixed many ways. Unfortunately /etc/hosts is not featureful
enough since it does not allow wildcards.

On the other hand, many popular options exist to accomplish that. You just need
to point *.loki and *.snode domains to Lokinet's DNS resolver
(either 127.0.0.1 or 127.3.2.1).

A few solid options are:
- [Surge](https://nssurge.com/)
- [dnscrypt-proxy](https://github.com/DNSCrypt/dnscrypt-proxy) (available on Homebrew)
- [Unbound](https://unbound.docs.nlnetlabs.nl/en/latest/index.html) (available on Homebrew)
- [DNSMasq](https://thekelleys.org.uk/dnsmasq/doc.html) (available on Homebrew)
- [Bind9](https://www.isc.org/bind/) (available on Homebrew)

## Interop with Surge, dnscrypt-proxy & others

Since the Lokinet seems to use 127.0.0.1 as the resolver, in order to get it to
coincide with everything else, for example I simply changed the port of my locally
running dnscrypt-proxy DNS resolver, e.g. 127.0.0.1:54. And in doing that, I was
able to use Surge and point it to dnscrypt-proxy for DNS resolution, and in Surge's
DNS Local Mapping, just added *.loki and *.snode to the local mappings, using
127.0.0.1 as the DNS server. And now you can access .loki domains just like normal!

However you decide to implement it is up to you. If you're a developer or tinkerer,
I feel this is very useful. Nuking my firewall's domain based rules was not worth
the tradeoff.

Best of **ALL** worlds

I will continue to experiment because I'd love to be able to use Lokinet as a proxy
profile within Surge.

## Uninstallation

1. Delete `~/.lokinetd-macos` directory from home dir
2. Edit .zshrc or .bashrc to remove references to lokinetd-macos
3. Done!

### Closing thoughts

This was just for fun because I needed something doing, so thought I'd share.
Please feel free to use however you like, and would love to hear if anybody's made
further strides. Always open to PRs too if you feel like adding something.

### Disclaimer

Currently for testing purposes only and compatibility with other DNS/VPN software.
Not tested with exit-nodes or VPN mode.

### License

MIT License

See [LICENSE](./LICENSE)
