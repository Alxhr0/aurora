pkgname="dart-sass"
arch=("amd64")
pkgver="1.102.0"
source=(
  "https://github.com/sass/${pkgname}/releases/download/${pkgver}/${pkgname}-${pkgver}-linux-x64.tar.gz"
  "change-dart-path.patch"
)
pkgdesc="Reference implementation of Sass, written in Dart."
maintainer=("Alxhr0 <alxhr0@proton.me>")
sha256sums=(
  "2a2ce6036f94534b39356252b1a3d4aa7879ab139c73bf62f7c9b5beafcfc367"
  "SKIP"
)
license=("MIT")

prepare() {
  cd "${pkgname}"
  patch -Np1 -i "${srcdir}/change-dart-path.patch"
}

package() {
  cd "${pkgname}"
  mkdir -p "${pkgdir}/usr/lib/${pkgname}"

  install -Dm755 sass -t "${pkgdir}/usr/bin"

  cp -r src "${pkgdir}/usr/lib/${pkgname}"

  install -Dm644 src/LICENSE -t "${pkgdir}/usr/share/licenses/${pkgname}"
}
