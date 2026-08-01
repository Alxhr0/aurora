pkgname="ignis-gvc"
arch=("amd64")
pkgver="0.1.0"
source=(
  "https://github.com/ignis-sh/${pkgname}/archive/refs/tags/v${pkgver}.tar.gz"
)
makedepends=("meson" "ninja-build" "libglib2.0-dev" "libgirepository1.0-dev" "libgtk-4-dev" "libpulse-dev" "pkg-config")
pkgdesc="Standalone libgvc for Ignis"
maintainer=("Alxhr0 <alxhr0@proton.me>")
sha256sums=(
  "6d0bf30be78e3b35b70f9364684dd7574120e82c918d4bfe39346f2c541808f6"
)
external_connection=true
license=("MIT")

prepare() {
  cd "${pkgname}-${pkgver}"

  meson setup build -Dprefix=/usr -Dbuildtype=release
}

build() {
  cd "${pkgname}-${pkgver}"
  ninja -C build
}

package() {
  cd "${pkgname}-${pkgver}"
  DESTDIR="${pkgdir}" ninja -C build install
}
