pkgname="ignis-git"
arch=("amd64")
pkgver="0.1.0"
source=(
  "https://github.com/ignis-sh/ignis.git"
)
pacdeps=("ignis-gvc" "dart-sass-bin")
makedepends=("meson" "ninja-build" "libglib2.0-dev" "libgirepository1.0-dev" "libgtk-4-dev" "libpulse-dev" "pkg-config" "python3" "python3-pip" "python3-installer" "python3-build" "python3-gi" "python3-gi-cairo" "python3-dev" "python3-cairo-dev" "python3-click" "python3-loguru" "python3-rich")
pkgdesc="Widget framework for building desktop shells, written and configurable in Python"
maintainer=("Alxhr0 <alxhr0@proton.me>")
external_connection=true
license=("LGPL-2.1")

prepare() {
  cd "ignis"

  git describe --long --tags --abbrev=7 | sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g'
}

build() {
  cd "ignis"
  python3 -m build --wheel --no-isolation
}

package() {
  cd "ignis"
  python3 - << EOF
import sysconfig, glob
from installer import install
from installer.destinations import SchemeDictionaryDestination
from installer.sources import WheelFile

scheme = sysconfig.get_paths(scheme='posix_prefix', vars={'base': '/usr', 'platbase': '/usr'})
scheme['headers'] = '/usr/include'
scheme['purelib'] = scheme['purelib'].replace('site-packages', 'dist-packages')
scheme['platlib'] = scheme['platlib'].replace('site-packages', 'dist-packages')

destination = SchemeDictionaryDestination(
    scheme,
    interpreter='/usr/bin/python3',
    script_kind='posix',
    destdir='${pkgdir}',
)

for wheel_path in glob.glob('dist/*.whl'):
    with WheelFile.open(wheel_path) as source:
        install(source, destination, {})
EOF
}
