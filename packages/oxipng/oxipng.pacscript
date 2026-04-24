pkgname="oxipng"
arch=("any")
pkgver="10.1.0"
source=("https://github.com/${pkgname}/${pkgname}/archive/refs/tags/v${pkgver}.tar.gz")
makedepends=("cargo" "pkg-config")
maintainer=("Alxhr0 <alxhr0@proton.me>")
pkgdesc="Multithreaded PNG optimizer written in Rust "
external_connection=true
sha256sums=("6c5e1d021a844ba730193943ab63ad99e7d9f1089c36f3db59014517ea99cf99")

build() {
  cd "${pkgname}~${pkgver}"
  cargo build -j"${NCPU}" --release --locked
}

package() {
  cd "${pkgname}~${pkgver}"

  install -Dm755 target/release/oxipng "${pkgdir}/usr/bin/oxipng"
  install -Dm644 LICENSE "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}