pkgname="ols-git"
_name="ols"
pkgver="2026-07a"
pkgdesc="Language server for Odin"
arch=("amd64")
url="https://github.com/DanielGavin/ols"
provides=("ols")
maintainer=("Alxhr0 <alxhr0@proton.me>")
license=("MIT")
source=(
    "https://github.com/DanielGavin/ols.git"
)
sha256sums=(
    "SKIP"
)
pacdeps=("odin")

build() {
    cd "${_name}"

    ./build.sh
}

package() {
    cd "${_name}"

    mkdir -pv "${pkgdir}/usr/bin"
    cp ols "${pkgdir}/usr/bin"
}
