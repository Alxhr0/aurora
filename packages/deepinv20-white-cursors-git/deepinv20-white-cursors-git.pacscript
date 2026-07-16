pkgname="deepinv20-white-cursors-git"
_name="DeepinV20-white-cursors"
pkgver="1.0"
pkgdesc="This is an x-cursor theme inspired by UOS and based on capitaine-cursors."
arch=("any")
url="https://github.com/yeyushengfan258/DeepinV20-white-cursors"
provides=("deepinv20-white-cursors")
maintainer=("Alxhr0 <alxhr0@proton.me>")
license=("GPL-3.0")
source=(
    "https://github.com/yeyushengfan258/DeepinV20-white-cursors.git"
    "fix-theme-name.patch"
)
sha256sums=(
    "SKIP"
    "ee8055acc48d024bd917ee19075cfd737068d04fb3ca6d1e9d0600166386a3f7"
)

prepare() {
    cd "${_name}"

    patch -p1 < "${srcdir}/fix-theme-name.patch"
}

package() {
    cd "${_name}"

    mkdir -pv "${pkgdir}/usr/share/icons/DeepinV20-White-Cursors"

    cp -rv dist/* "${pkgdir}/usr/share/icons/DeepinV20-White-Cursors"
}
