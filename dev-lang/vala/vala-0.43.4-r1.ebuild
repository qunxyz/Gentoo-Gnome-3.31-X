# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="Compiler for the GObject type system"
HOMEPAGE="https://wiki.gnome.org/Projects/Vala"

LICENSE="LGPL-2.1"
SLOT="0.44"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~arm-linux ~x86-linux"
IUSE="doc test"

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=dev-libs/vala-common-${PV}
	>=media-gfx/graphviz-2.16
"
DEPEND="${RDEPEND}
	!<${CATEGORY}/${PN}-${PV}
	!>${CATEGORY}/${PN}-${PV}
	dev-libs/libxslt
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc
	test? (
		dev-libs/dbus-glib
		>=dev-libs/glib-2.26:2
		dev-libs/gobject-introspection )
"

src_configure() {
	# bug 483134
	export GIT_CEILING_DIRECTORIES="${WORKDIR}"

	# weasyprint enables generation of PDF from HTML
	gnome2_src_configure \
		--disable-unversioned \
		$(usex doc --enable-valadoc --disable-valadoc) \
		VALAC=: \
		WEASYPRINT=:
}

src_install() {
	gnome2_src_install
	dosym /usr/bin/vala-${SLOT} /usr/bin/vala
	dosym /usr/bin/valac-${SLOT} /usr/bin/valac
	use doc && dosym /usr/bin/valadoc-${SLOT} /usr/bin/valadoc
	dosym /usr/bin/vapigen-${SLOT} /usr/bin/vapigen
	dosym /usr/bin/vala-gen-introspect-${SLOT} /usr/bin/vala-gen-introspect
}
