pkgname="kf6-servicemenus-imagetools"
arch=("any")
pkgver="7.0"
source=("@${pkgname}~${pkgver}::https://github.com/sharkdp/bat/archive/refs/tags/v${pkgver}.tar.gz")
depends=("libjxl-tools" "imagemagick" "optipng" "pngquant" "libimage-exiftool-perl")
pacdeps=("jpegoptim" "oxipng")
pkgdesc="KDE service menus for image file processing "
sha256sums=("907554a9eff239f256ee8fe05a922aad84febe4fe10a499def72a4557e9eedfb")

package() {
  cd "${pkgname}~${pkgver}"
  install -Dm755 bin/imagetools-kdialog -t "${pkgdir}/usr/bin"

  install -Dm644 servicemenus/*.desktop "${pkgdir}/usr/share/kio/servicemenus"

  install -Dm644 LICENSE -t "${pkgdir}/usr/share/licenses/${pkgname}"
}