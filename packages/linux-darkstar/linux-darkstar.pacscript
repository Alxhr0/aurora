pkgname="linux-darkstar"
_name="linux"
arch=("amd64")
pkgver="7.1.3"
source=(
  "https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-${pkgver}.tar.xz"
  "patches/dkms-clang.patch"
  "patches/0001-acpi-call.patch"
  "patches/0001-aufs-7.1-merge-v20260713.patch"
  "patches/0001-clang-polly.patch"
  "patches/0001-handheld.patch"
  "patches/0001-rt-i915.patch"
  "patches/sched/0001-bore.patch"
  "config.d/ubuntu-config"
  "config.d/0000-localversion.config"
  "config.d/0002-no-amd.config"
  "config.d/0005-no-firewire.config"
  "config.d/0007-no-sony-memorystick.config"
  "config.d/0008-no-fujitsu.config"
  "config.d/0014-no-vmware.config"
  "config.d/0015-no-nfc.config"
  "config.d/0020-no-acer.config"
  "config.d/0021-no-asus.config"
  "config.d/0023-no-canbus.config"
  "config.d/0029-no-jfs.config"
  "config.d/0031-no-gfs.config"
  "config.d/0035-no-nilfs2.config"
  "config.d/0037-no-nfs.config"
  "config.d/0043-no-agp.config"
  "config.d/0049-no-marvell-wlan.config"
  "config.d/0051-no-ralink-wlan.config"
  "config.d/0053-no-quantenna-wlan.config"
  "config.d/0055-no-st-wlan.config"
  "config.d/0057-no-zydas-wlan.config"
  "config.d/0062-no-apple-hardware.config"
  "config.d/0063-no-gameport.config"
  "config.d/0064-no-old-keyboard-mice.config"
  "config.d/0067-no-chrome-hardware.config"
  "config.d/0068-no-old-odd-joysticks.config"
  "config.d/0074-no-lg-laptop.config"
  "config.d/0079-no-hp.config"
  "config.d/0080-no-hid-tablets.config"
  "config.d/0086-no-huawei.config"
)
makedepends=(
    "gcc"
    "cargo | rustup"
    "bc"
    "flex"
    "bison"
    "binutils"
    "cpio"
    "gettext"
    "libdw-dev"
    "libelf-dev"
    "libssl-dev"
    "perl"
    "python3"
    "tar"
    "xz-utils"
    "zlib1g-dev"
    "libzstd-dev"
)
maintainer=("Alxhr0 <alxhr0@proton.me>")
pkgdesc="Custom build of the Linux Kernel"
sha256sums=(
  "be41c068e88f5242a19bccdbffbe077b18c47b45f627e2325504b4fab79dd1dc"
  "SKIP"
  "SKIP"
  "SKIP"
  "SKIP"
  "SKIP"
  "SKIP"
  "SKIP"
  "SKIP"
  "SKIP"
  "SKIP"
  "SKIP"
  "SKIP"
  "SKIP"
  "SKIP"
  "SKIP"
  "SKIP"
  "SKIP"
  "SKIP"
  "SKIP"
)
external_connection=true
license="GPL-2.0"

prepare() {
  cd "${_name}-${pkgver}"

  make mrproper

  # apply all patches in the order listed in source[] (skip index 0, the tarball itself)
  for f in "${srcdir}"/*.patch "${srcdir}"/sched/*.patch; do
    [ -e "$f" ] || continue
    echo "Applying $(basename "$f")"
    patch -Np1 -i "$f"
  done

  cp "${srcdir}/ubuntu-config" .config
  # apply every fragment except the base, sorted numerically so ordering is explicit
  ./scripts/kconfig/merge_config.sh -m .config \
    $(find "${srcdir}" -maxdepth 1 -name '*.config' | sort)

  make olddefconfig
}

build() {
  cd "${_name}-${pkgver}"

  export KCFLAGS="-march=raptorlake -mtune=raptorlake -pipe"

  export RUSTUP_TOOLCHAIN=stable
  make -j"${NCPU}"
}

package() {
  cd "${_name}-${pkgver}"

  local kver
  kver="$(make -s kernelrelease)"

  install -Dm644 arch/x86/boot/bzImage \
    "${pkgdir}/boot/vmlinuz-${kver}"
  install -Dm644 System.map \
    "${pkgdir}/boot/System.map-${kver}"
  install -Dm644 .config \
    "${pkgdir}/boot/config-${kver}"

  make INSTALL_MOD_PATH="${pkgdir}" INSTALL_MOD_STRIP=1 modules_install
  rm -f "${pkgdir}/lib/modules/${kver}/build"
  rm -f "${pkgdir}/lib/modules/${kver}/source"

  install -dm755 "${pkgdir}/usr/src/linux-headers-${kver}"
  make INSTALL_HDR_PATH="${pkgdir}/usr" headers_install
  install -Dm644 Makefile "${pkgdir}/usr/src/linux-headers-${kver}/Makefile"
  install -Dm644 .config "${pkgdir}/usr/src/linux-headers-${kver}/.config"
  cp -a scripts "${pkgdir}/usr/src/linux-headers-${kver}/"
  cp -a include "${pkgdir}/usr/src/linux-headers-${kver}/"
  [ -f Module.symvers ] && install -Dm644 Module.symvers \
    "${pkgdir}/usr/src/linux-headers-${kver}/Module.symvers"

  ln -sf "/usr/src/linux-headers-${kver}" \
    "${pkgdir}/lib/modules/${kver}/build"

  install -Dm644 LICENSE -t "${pkgdir}/usr/share/licenses/${pkgname}"
}
