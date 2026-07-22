pkgname="hourglass"
arch=("amd64")
pkgver="1.5.1"
source=("https://gitlab.com/Alxhr0/${pkgname}/-/archive/${pkgver}/${pkgname}-${pkgver}.tar.gz")
makedepends=("cargo | rustup")
maintainer=("Alxhr0 <alxhr0@proton.me>")
pkgdesc="Get install date of the system"
sha256sums=("5a48e91516ca2310bf802a77ce934609389a75e4aebcf557d2ada62ff061b8a3")
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
