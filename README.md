Unofficial Gentoo Gnome 3.30 overlay
--------------------------------------------

Versions
--------

 - Gnome 3.30 (stable)

General information
-------------------

 - All ebuilds are keyworded amd64
 - Portions taken from the hhfeuer Gnome overlay

Usage
-----

## via local overlays

Create a `/etc/portage/repos.conf/Gnome-3.30-X.conf` file containing

```
[Gnome-3-30-X]
location = /usr/local/portage/Gnome-3-30-X
sync-type = git
sync-uri = https://github.com/qunxyz/Gentoo-Gnome-3.30-X.git
priority=9999
```

Then run emerge --sync

## via layman

Add via layman:

	layman -o https://raw.github.com/qunxyz/Gentoo-Gnome-3.30-X/master/repositories.xml -f -a Gnome-3-30-X

Then run layman -s Gnome-3-30-X


