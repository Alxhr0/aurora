pkgname="linux-darkstar"
_name="linux"
_localversion="darkstar"
arch=("amd64")
pkgver="7.1.5"
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
  "config.d/0901-no-module-sig.config"
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
  "dwarves"
)
maintainer=("Alxhr0 <alxhr0@proton.me>")
pkgdesc="Custom build of the Linux Kernel"
sha256sums=(
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
    "$(find "${srcdir}" -maxdepth 1 -name '*.config' | sort)"

  make olddefconfig
}

build() {
  cd "${_name}-${pkgver}"

  export KCFLAGS="-march=raptorlake -mtune=raptorlake -pipe"

  export RUSTUP_TOOLCHAIN=stable
  make -j8
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

  # prepare a genuinely complete headers tree for DKMS/out-of-tree builds
  make modules_prepare

  local hdrdir="${pkgdir}/usr/src/linux-headers-${kver}"
  install -dm755 "${hdrdir}"

  # copy the whole tree minus build artifacts we don't need to ship,
  # rather than hand-picking subdirectories (arch/x86/Makefile lives
  # under arch/, which the minimal copy missed)
  find . -maxdepth 1 -mindepth 1 \
    ! -name '.git' \
    ! -name 'Documentation' \
    ! -name 'samples' \
    ! -name '*.tar*' \
    -exec cp -a {} "${hdrdir}/" \;

  # drop the bulk of driver/module source we don't need for building
  # out-of-tree modules, keep the Kbuild/Makefile scaffolding
  find "${hdrdir}/drivers" "${hdrdir}/net" "${hdrdir}/sound" "${hdrdir}/fs" \
    -type f -name '*.c' -delete 2>/dev/null || true

  ln -sf "/usr/src/linux-headers-${kver}" \
    "${pkgdir}/lib/modules/${kver}/build"
}

post_install() {
  update-initramfs -k "${pkgver}-${_localversion}"
}
