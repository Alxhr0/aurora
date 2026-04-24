pkgname="jpegoptim"
arch=("amd64")
pkgver="1.5.6"
source=("https://github.com/tjko/${pkgname}/archive/refs/tags/v${pkgver}.tar.gz")
makedepends=("gcc" "make" "libjpeg-dev")
maintainer=("Alxhr0 <alxhr0@proton.me>")
pkgdesc="utility to optimize/compress JPEG files "
sha256sums=("661a808dfffa933d78c6beb47a2937d572b9f03e94cbaaab3d4c0d72f410e9be")


build() {
  cd "${pkgname}-${pkgver}"
  ./configure --prefix=/usr

  make -j"${NCPU}"
  make strip -j"${NCPU}"
}

package() {
  cd "${pkgname}-${pkgver}"
  make install DESTDIR="${pkgdir}"
}