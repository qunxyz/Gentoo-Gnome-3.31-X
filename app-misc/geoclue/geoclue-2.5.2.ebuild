# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 systemd user meson

DESCRIPTION="A geoinformation D-Bus service"
HOMEPAGE="https://gitlab.freedesktop.org/geoclue/geoclue/wikis/home"
SRC_URI="https://gitlab.freedesktop.org/geoclue/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="2.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE="+introspection modemmanager zeroconf"

RDEPEND="
	>=dev-libs/glib-2.44:2
	>=dev-libs/json-glib-0.14
	>=net-libs/libsoup-2.42:2.4
	sys-apps/dbus
	introspection? ( >=dev-libs/gobject-introspection-0.9.6:= )
	modemmanager? ( >=net-misc/modemmanager-1.6 )
	zeroconf? ( >=net-dns/avahi-0.6.10[dbus] )
	!<sci-geosciences/geocode-glib-3.10.0
	x11-libs/libnotify
"
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=dev-util/gtk-doc-1
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Denable-backend=true
		-Ddbus-srv-user=geoclue
		-Dsystemd-system-unit-dir="$(systemd_get_systemunitdir)"
		
		-Dintrospection=$(usex introspection true false)
		-D3g-source=$(usex modemmanager true false)
		-Dcdma-source=$(usex modemmanager true false)
		-Dmodem-gps-source=$(usex modemmanager true false)
		-Dnmea-source=$(usex zeroconf true false)
	)
	meson_src_configure
}

pkg_preinst() {
	enewgroup geoclue
	enewuser geoclue -1 -1 /var/lib/geoclue geoclue
	gnome2_pkg_preinst
}
