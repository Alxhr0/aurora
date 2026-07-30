pkgname="rust-coreutils"
_name="coreutils"
arch=("amd64")
pkgver="0.9.0"
source=("https://github.com/uutils/coreutils/archive/refs/tags/${pkgver}.tar.gz")
makedepends=("cargo | rustup")
maintainer=("Alxhr0 <alxhr0@proton.me>")
pkgdesc="Cross-platform Rust rewrite of the GNU coreutils"
sha256sums=("")
external_connection=true
license="MIT"


package() {
  cd "${_name}-${pkgver}"
  export RUSTUP_TOOLCHAIN=stable

  make install PREFIX=/usr/lib/cargo/coreutils LIBSTDBUF_DIR=/usr/libexec/rust-coreutils PROG_PREFIX= PROFILE=release MULTICALL=y LN="f" MANDIR=/usr/share/man/man1 DESTDIR="${pkgdir}"
}
