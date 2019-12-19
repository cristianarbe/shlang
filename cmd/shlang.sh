#!/bin/env sh

set -e

fn_get(){
  url_orig="$1"
  url="$(echo $url_orig | sed 's/https:\/\///g')"
  cd "$SHPATH"/src || exit
  mkdir -p "$url"
  git clone "$url_orig" "$url"
}

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

  if test -z "$SHPATH"; then
    echo "SHPATH is not set!"
    exit 1
  fi

  binpath="$SHPATH"/bin/"$filename"

  if test -L "$binpath"; then
    rm "$binpath"
  fi

  ln -sv "$PWD"/"$1" "$binpath"
  chmod +x "$PWD"/"$1"

}

main() {
  case "$1" in
  run | install | get)
    fn_"$1" "$2"
    ;;
  *)
    echo "Invalid operation $1"
    ;;
  esac
}

main "$@"
