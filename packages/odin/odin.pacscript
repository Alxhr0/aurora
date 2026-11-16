pkgname="odin"
arch=("amd64")
pkgver="2026-11a"
source=("https://github.com/${pkgname}-lang/Odin/archive/refs/tags/dev-${pkgver}.tar.gz")
depends=("clang")
makedepends=("make" "clang")
maintainer=("Alxhr0 <alxhr0@proton.me>")
pkgdesc="Odin Programming Language"
sha256sums=("f8ab36b8d6045d7ae953b60e30edea80d2e616da44b0712d73dd0688d684f278")
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
