pkgname="hourglass"
arch=("amd64")
pkgver="1.5.0"
source=("https://gitlab.com/Alxhr0/${pkgname}/-/archive/${pkgver}/${pkgname}-${pkgver}.tar.gz")
makedepends=("cargo | rustup")
maintainer=("Alxhr0 <alxhr0@proton.me>")
pkgdesc="Get install date of the system"
sha256sums=("7926b5cd883a5dc3733a7199880ddc352ca29409dc904ca60aaac8bedacd59ea")
external_connection=true
license="MIT"

build() {
  cd "${pkgname}-${pkgver}"
  export RUSTUP_TOOLCHAIN=stable
  cargo build -j"${NCPU}" --locked --release
}

package() {
  cd "${pkgname}-${pkgver}"
  install -Dm755 target/release/hourglass -t "${pkgdir}/usr/bin"

  install -Dm644 LICENSE -t "${pkgdir}/usr/share/licenses/${pkgname}"
}
