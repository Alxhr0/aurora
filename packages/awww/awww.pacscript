pkgname="awww"
arch=("amd64")
pkgver="0.12.1"
source=("https://codeberg.org/LGFae/${pkgname}/archive/v${pkgver}.tar.gz")
makedepends=("cargo | rustup" "liblz4-dev")
maintainer=("Alxhr0 <alxhr0@proton.me>")
pkgdesc="Answer to your Wayland Wallpaper Woes"
sha256sums=("97b3f1c6d65d9d30e51b17092a45244f8c8549607c9207f3c98d82b28ba18fca")
external_connection=true
license="GPL-3.0"

build() {
  cd "${pkgname}"
  export RUSTUP_TOOLCHAIN=stable
  cargo build -j"${NCPU}" --locked --release
}

package() {
  cd "${pkgname}"
  install -Dm755 target/release/awww -t "${pkgdir}/usr/bin"
  install -Dm755 target/release/awww-daemon -t "${pkgdir}/usr/bin"

  install -Dm644 LICENSE -t "${pkgdir}/usr/share/licenses/${pkgname}"
}
