pkgname="hourglass"
arch=("amd64")
pkgver="1.4.2"
source=("https://gitlab.com/Alxhr0/${pkgname}/-/archive/${pkgver}/${pkgname}-${pkgver}.tar.gz")
makedepends=("cargo")
maintainer=("Alxhr0 <alxhr0@proton.me>")
pkgdesc="Get install date of the system"
sha256sums=("e2cb12f91f616a601b8f4d01fc3afbdb0e88efd029f1d091d010e345d574733a")
external_connection=true

build() {
  cd "${pkgname}-${pkgver}"
  cargo build -j"${NCPU}" --release
}

package() {
  cd "${pkgname}-${pkgver}"
  install -Dm755 target/release/hourglass -t "${pkgdir}/usr/bin"

  install -Dm644 LICENSE -t "${pkgdir}/usr/share/licenses/${pkgname}"
}