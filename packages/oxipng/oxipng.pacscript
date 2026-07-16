pkgname="oxipng"
arch=("any")
pkgver="10.1.1"
source=("https://github.com/${pkgname}/${pkgname}/archive/refs/tags/v${pkgver}.tar.gz")
makedepends=("cargo | rustup" "pkg-config")
maintainer=("Alxhr0 <alxhr0@proton.me>")
pkgdesc="Multithreaded PNG optimizer written in Rust "
external_connection=true
sha256sums=("ce19b1f060d586ceb3ea682f27d00e41675ec4093d8ac200a61ccd9d967d0999")
license="MIT"

build() {
  cd "${pkgname}-${pkgver}"
  export RUSTUP_TOOLCHAIN=stable
  cargo build -j"${NCPU}" --release --locked
}

package() {
  cd "${pkgname}-${pkgver}"

  install -Dm755 target/release/oxipng "${pkgdir}/usr/bin/oxipng"
  install -Dm644 LICENSE "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}
