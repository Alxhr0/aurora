pkgname="odin"
arch=("amd64")
pkgver="2026-07a"
source=("https://github.com/${pkgname}-lang/Odin/archive/refs/tags/dev-${pkgver}.tar.gz")
makedepends=("make" "clang")
maintainer=("Alxhr0 <alxhr0@proton.me>")
pkgdesc="Odin Programming Language"
sha256sums=("8f4f02fd9a3426b441cd0dfbe0aca1b95fd93c95d86940fcb4417ef6044c83cd")
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
