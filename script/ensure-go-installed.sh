# This file is meant to be sourced with ROOTDIR set.

if [ -z "$ROOTDIR" ]; then
    echo 1>&2 'ensure-go-installed.sh invoked without ROOTDIR set!'
fi

# Is go installed, and at least 1.7?
go_ok() {
    case "$(go version 2>/dev/null | sed -n 's/.*go\([0-9][0-9]*\.[0-9][0-9]*\).*/\1/p' | head -n 1)" in
        ""|0.*|1.[012345678])
            false ;;
        *)
            true ;;
    esac
}

# If a local go is installed, use it.
set_up_vendored_go() {
    GO_VERSION=go1.9.2
    VENDORED_GOROOT="$ROOTDIR/vendor/$GO_VERSION/go"
    if [ -x "$VENDORED_GOROOT/bin/go" ]; then
        export GOROOT="$VENDORED_GOROOT"
        export PATH="$GOROOT/bin:$PATH"
    fi
}

set_up_vendored_go

if ! go_ok; then
    script/install-vendored-go >/dev/null || exit 1
    set_up_vendored_go
fi
