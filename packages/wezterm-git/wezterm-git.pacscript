pkgname="wezterm-git"
_name="wezterm"
arch=("amd64")
pkgver="20260304"
source=("https://github.com/wezterm/wezterm.git")
makedepends=(
  "cargo | rustup"
  "cmake"
  "gcc"
  "libxkbcommon-dev"
  "libxkbcommon-x11-dev"
  "libncurses-dev"
  "perl"
  "pkg-config"
  "libwayland-dev"
  "libxcb-keysyms1-dev"
  "libxcb-image0-dev"
  "zstd"
  "libfontconfig-dev"
  "libfreetype-dev"
  "libharfbuzz-dev"
  "libssh2-1-dev"
  "libxcb1-dev"
  "libxcb-util-dev"
  "libx11-xcb-dev"
)
maintainer=("Alxhr0 <alxhr0@proton.me>")
pkgdesc="A GPU-accelerated cross-platform terminal emulator and multiplexer written by @wez and implemented in Rust"
sha256sums=("5a48e91516ca2310bf802a77ce934609389a75e4aebcf557d2ada62ff061b8a3")
external_connection=true
conflicts=("wezterm" "wezterm-bin" "wezterm-app")
license="MIT"

build() {
  cd "${_name}"
  export RUSTUP_TOOLCHAIN=stable

  unset LIBSSH2_SYS_USE_PKG_CONFIG
  cargo build -j"${NCPU}" --locked --release --no-default-features --features vendored-fonts,wayland,distro-defaults

}

package() {
  cd "${_name}"

  install -Dm 0755 ./target/release/"${_name}" "${pkgdir}"/usr/bin/"${_name}"
  install -Dm 0755 ./target/release/"${_name}"-gui "${pkgdir}"/usr/bin/"${_name}"-gui
  install -Dm 0755 "${_name}"/target/release/"${_name}"-mux-server "${pkgdir}"/usr/bin/"${_name}"-mux-server
  install -Dm 0755 "${_name}"/target/release/strip-ansi-escapes "${pkgdir}"/usr/bin/strip-ansi-escapes

  install -Dm 0644 assets/"${_name}".desktop "${pkgdir}"/usr/share/applications/org.wezfurlong."${_name}".desktop
  install -Dm 0644 assets/icon/"${_name}"-icon.svg "${pkgdir}"/usr/share/icons/hicolor/scalable/apps/org.wezfurlong."${_name}".svg
  install -Dm 0644 assets/"${_name}".appdata.xml "${pkgdir}"/usr/share/metainfo/org.wezfurlong."${_name}".appdata.xml
  install -Dm 0644 assets/shell-integration/* -t "${pkgdir}"/etc/profile.d
  install -Dm 0644 assets/"${_name}"-nautilus.py "${pkgdir}"/usr/share/nautilus-python/extensions/"${_name}"-nautilus.py

  # Bash completion
  install -D -m 0644 assets/shell-completion/bash "${pkgdir}"/usr/share/bash-completion/completions/"${_name}"
  install -D -m 0644 assets/shell-completion/bash "${pkgdir}"/usr/share/bash-completion/completions/"${_name}"-gui

  # Zsh completion
  install -D -m 0644 assets/shell-completion/zsh "${pkgdir}"/usr/share/zsh/site-functions/_"${_name}"
  install -D -m 0644 assets/shell-completion/zsh "${pkgdir}"/usr/share/zsh/site-functions/_"${_name}"-gui

  # Fish completion
  install -D -m 0644 assets/shell-completion/fish "${pkgdir}"/usr/share/fish/vendor_completions.d/"${_name}".fish
  install -D -m 0644 assets/shell-completion/fish "${pkgdir}"/usr/share/fish/vendor_completions.d/"${_name}"-gui.fish

}
