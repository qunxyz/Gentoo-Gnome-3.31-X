# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
GNOME2_EAUTORECONF="yes"

inherit gnome2 systemd meson

DESCRIPTION="Virtual filesystem implementation for gio"
HOMEPAGE="https://wiki.gnome.org/Projects/gvfs"
#SRC_URI+=" https://dev.gentoo.org/~leio/distfiles/${P}-patchset.tar.xz"

LICENSE="LGPL-2+"
SLOT="0"

IUSE="afp archive bluray cdda elogind fuse google gnome-keyring gnome-online-accounts gphoto2 +http ios mtp nfs sftp policykit samba systemd test +udev udisks dnssd gcrypt"
REQUIRED_USE="
	cdda? ( udev )
	elogind? ( !systemd udisks )
	google? ( gnome-online-accounts )
	mtp? ( udev )
	udisks? ( udev )
	systemd? ( !elogind udisks )
"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"

RDEPEND="
	app-crypt/gcr:=
	>=dev-libs/glib-2.51:2
	dev-libs/libxml2:2
	net-misc/openssh
	afp? ( >=dev-libs/libgcrypt-1.2.2:0= )
	archive? ( app-arch/libarchive:= )
	bluray? ( media-libs/libbluray:= )
	elogind? ( >=sys-auth/elogind-229:0= )
	fuse? ( >=sys-fs/fuse-2.8.0:0 )
	gnome-keyring? ( app-crypt/libsecret )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.7.1:= )
	google? (
		>=dev-libs/libgdata-0.17.9:=[crypt,gnome-online-accounts]
		>=net-libs/gnome-online-accounts-3.17.1:= )
	gphoto2? ( >=media-libs/libgphoto2-2.5.0:= )
	http? ( >=net-libs/libsoup-2.42:2.4 )
	ios? (
		>=app-pda/libimobiledevice-1.2:=
		>=app-pda/libplist-1:= )
	mtp? (
		>=dev-libs/libusb-1.0.21
		>=media-libs/libmtp-1.1.12 )
	nfs? ( >=net-fs/libnfs-1.9.8 )
	policykit? (
		sys-auth/polkit
		sys-libs/libcap )
	samba? ( >=net-fs/samba-4[client] )
	systemd? ( >=sys-apps/systemd-206:0= )
	udev? (
		cdda? ( dev-libs/libcdio-paranoia )
		>=virtual/libgudev-147:=
		virtual/libudev:= )
	udisks? ( >=sys-fs/udisks-1.97:2 )
	zeroconf? ( >=net-dns/avahi-0.6 )
"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
	dev-util/gdbus-codegen
	dev-util/gtk-doc-am
	test? (
		>=dev-python/twisted-16
		|| (
			net-analyzer/netcat
			net-analyzer/netcat6 ) )
	!udev? ( >=dev-libs/libgcrypt-1.2.2:0 )
"
# libgcrypt.m4, provided by libgcrypt, needed for eautoreconf, bug #399043
# test dependencies needed per https://bugzilla.gnome.org/700162

# Tests with multiple failures, this is being handled upstream at:
# https://bugzilla.gnome.org/700162
RESTRICT="test"

src_configure() {
        local emesonargs=(
            -Dsystemduserunitdir="$(systemd_get_userunitdir)"
            -Dman=true
            -Dgcr=true
            -Dgcrypt=$(usex gcrypt true false)
            
            -Dafp=$(usex afp true false)
            -Darchive=$(usex archive true false)
            -Dbluray=$(usex bluray true false)
            -Dcdda=$(usex cdda true false)
            -Ddnssd=$(usex dnssd true false)
            -Dlogind=$(usex elogind true false)
            -Dfuse=$(usex fuse true false)
            -Dkeyring=$(usex gnome-keyring true false)
            -Dgoa=$(usex gnome-online-accounts true false)
            -Dgoogle=$(usex google true false)
            -Dgphoto2=$(usex gphoto2 true false)
            -Dhttp=$(usex http true false)
            -Dafc=$(usex ios true false)
            -Dmtp=$(usex mtp true false)
            -Dlibusb=$(usex mtp true false)
            -Dnfs=$(usex nfs true false)
            -Dsftp=$(usex sftp true false)
            -Dadmin=$(usex policykit true false)
            -Dsmb=$(usex samba true false)
            -Dgudev=$(usex udev true false)
            -Dudisks2=$(usex udisks true false)
            -Dlogind=$(usex systemd true false)
            -Dinstalled_tests=$(usex test true false)
        )
	meson_src_configure
}

src_install() {
	meson_src_install
}
