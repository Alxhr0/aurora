pkgname="oxipng"
arch=("any")
pkgver="10.1.0"
source=("@${pkgname}~${pkgver}::https://github.com/oxipng/oxipng/archive/refs/tags/v${pkgver}.tar.gz")
makedepends=("cargo" "pkg-config")
maintainer=("Alxhr0 <alxhr0@proton.me>")
pkgdesc="Multithreaded PNG optimizer written in Rust "
external_connection=true
sha256sums=("")

build() {
  cd "${pkgname}~${pkgver}"
  cargo build -j"${NCPU}" --release --locked
}

package() {
  cd "${pkgname}~${pkgver}"

  install -Dm755 target/release/oxipng "${pkgdir}/usr/bin/oxipng"
  install -Dm644 LICENSE "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}