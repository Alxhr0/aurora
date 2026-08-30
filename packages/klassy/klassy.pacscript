_pkgname=klassy
pkgbase="${_pkgname}"
pkgname=("${_pkgname}"
  "${_pkgname}-qt5")
pkgver=6.7
pkgrel=1
pkgdesc='Highly customizable binary Window Decoration, Application Style and Global Theme plugin for recent versions of the KDE Plasma desktop.'
arch=(x86_64)
url="https://github.com/paulmcauley/klassy"
license=('MIT')
maintainer=("Alxhr0 <alxhr0@proton.me>")
depends=(
  "breeze-icon-theme"
  "hicolor-icon-theme"
  "frameworkintegration6"
  "libkf6kcmutils6"
  "libkf6colorscheme6"
  "libkf6configcore6"
  "libkf6configgui6"
  "libkf6coreaddons6"
  "libkdecorations3-6"
  "libkf6guiaddons6"
  "libkf6i18n6"
  "libkf6iconthemes6"
  "libkirigami6"
  "libkf6widgetsaddons6"
  "libkf6windowsystem6"
  "libqt6core6"
  "libqt6gui6"
  "libqt6widgets6"
  "libqt6qml6"
  "libqt6quick6"
  "libqt6svg6"
  "xdg-utils"
)

makedepends=(
  "cmake"
  "ninja-build"
  "extra-cmake-modules"
  "libkf5style-dev"
  "libkf6kcmutils-dev"
  "libkf6colorscheme-dev"
  "libkf5config-dev"
  "libkf5configwidgets-dev"
  "libkf5coreaddons-dev"
  "libkf5guiaddons-dev"
  "libkf6i18n-dev"
  "libkf6iconthemes-dev"
  "libkf6package-dev"
  "libkf6service-dev"
  "libkf6windowsystem-dev"
  "kwayland-dev"
  "libx11-dev"
  "libkdecorations3-dev"
  "libkf5i18n-dev"
  "libkf5iconthemes-dev"
  "libkf5kcmutils-dev"
  "libkf5package-dev"
  "libkf5service-dev"
  "libkf5wayland-dev"
  "libkf5windowsystem-dev"
  "libplasma-dev"
  "libqt5x11extras5-dev"
  "qt6-base-dev"
  "qt6-declarative-dev"
  "qtbase5-dev"
  "qtdeclarative5-dev"
  "gettext"
  "qt6-svg-dev"
)
source=("${_pkgname}-${pkgver}.tar.gz::${url}/archive/refs/tags/v${pkgver}.tar.gz")
sha256sums=('e6fa56f72ec390764051fb5905ea44d96bb48b072dda6273f31d4fe40fd414ef')

build() {
  cmake -B build -G Ninja -S "${_pkgname}-${pkgver}" \
    -DBUILD_TESTING=OFF \
    -DBUILD_QT5=OFF
  ninja -C build -j"${NCPU}"

  CMAKE_PREFIX_PATH="/usr/lib/cmake/plasma5" cmake \
    -B build5 -G Ninja -S "${_pkgname}-${pkgver}" \
    -DBUILD_TESTING=OFF \
    -DBUILD_QT6=OFF
  ninja -C build5 -j"${NCPU}"
}

package_klassy() {
  DESTDIR="${pkgdir}" ninja -C build install
  install -Dm644 "${_pkgname}-${pkgver}/LICENSES/MIT.txt" "${pkgdir}/usr/share/licenses/${_pkgname}/MIT.txt"
}

package_klassy-qt5() {
  arch=(x86_64)
  depends=("${_pkgname}"
    "breeze-icon-theme"
    "frameworkintegration"
    "libkf5configcore5"
    "libkf5configgui5"
    "libkf5configwidgets5"
    "libkf5guiaddons5"
    "libkf5iconthemes5"
    "libkf5kirigami2-5"
    "libkf5windowsystem5"
    "libqt5core5a"
    "libqt5gui5"
    "libqt5widgets5"
    "libqt5qml5"
    "libqt5quick5"
    "libqt5svg5")
  DESTDIR="${pkgdir}" ninja -C build5 install
  rm -r "${pkgdir}/usr/share/"{color-schemes,kstyle}
  install -Dm644 "${_pkgname}-${pkgver}/LICENSES/MIT.txt" "${pkgdir}/usr/share/licenses/${_pkgname}-qt5/MIT.txt"
}
