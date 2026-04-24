pkgname="kf6-servicemenus-imagetools"
arch=("any")
pkgver="7.0"
_pkgver="7"
source=("https://github.com/marco-mania/${pkgname}/archive/refs/tags/v${_pkgver}.tar.gz")
depends=("libjxl-tools" "imagemagick" "optipng" "pngquant" "libimage-exiftool-perl")
pacdeps=("jpegoptim" "oxipng")
pkgdesc="KDE service menus for image file processing "
maintainer=("Alxhr0 <alxhr0@proton.me>")
sha256sums=("41fa40c0e7c64fae135d88cb963ec5139d550c019d5d8592c9e2924e43a21a58")

package() {
  cd "${pkgname}-${_pkgver}"
  install -Dm755 bin/imagetools-kdialog -t "${pkgdir}/usr/bin"

  install -Dm644 servicemenus/*.desktop "${pkgdir}/usr/share/kio/servicemenus"

  install -Dm644 LICENSE -t "${pkgdir}/usr/share/licenses/${pkgname}"
}