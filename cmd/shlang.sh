#!/bin/env sh

set -e

fn_run() {
  if ! shellcheck "$1"; then
    exit 1
  fi

  sh "$1"
}

fn_install() {
  if ! shellcheck "$1"; then
    exit 1
  fi

  filename="$(basename "$1")"
  filename="${filename%.*}"
  binpath="$SHPATH"/bin/"$filename"

  if test -L "$binpath"; then
    rm "$binpath"
  fi

  ln -sv "$PWD"/"$1" "$binpath"
  chmod +x "$PWD"/"$1"

}

main() {
  case "$1" in
  run | install)
    fn_"$1" "$2"
    ;;
  *)
    echo "Invalid operation $1"
    ;;
  esac
}

main "$@"
