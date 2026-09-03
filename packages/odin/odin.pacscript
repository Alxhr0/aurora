pkgname="odin"
arch=("amd64")
pkgver="2026-09"
source=("https://github.com/${pkgname}-lang/Odin/archive/refs/tags/dev-${pkgver}.tar.gz")
depends=("clang")
makedepends=("make" "clang")
maintainer=("Alxhr0 <alxhr0@proton.me>")
pkgdesc="Odin Programming Language"
sha256sums=("f52230de6ad28bed99b4440018cb659c13e3fd78c4521ca3ce661698c1f6135d")
license="Zlib"

build() {
  cd "Odin-dev-${pkgver}"

  make release-native -j"${NCPU}"
}

package() {
  cd "Odin-dev-${pkgver}"

  install -d "${pkgdir}/usr/"{bin,lib/"${pkgname}"}
  cp odin "${pkgdir}/usr/lib/${pkgname}/${pkgname}"
  cp -r base core shared vendor "${pkgdir}/usr/lib/${pkgname}/"
  ln -s "/usr/lib/${pkgname}/${pkgname}" "${pkgdir}/usr/bin/${pkgname}"
  install -Dm644 LICENSE "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
  install -Dm644 PROPOSAL-PROCESS.md "${pkgdir}/usr/share/doc/${pkgname}/PROPOSAL-PROCESS.md"
  install -Dm644 README.md "${pkgdir}/usr/share/doc/${pkgname}/README.md"
}
