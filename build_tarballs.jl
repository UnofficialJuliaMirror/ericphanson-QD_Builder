# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "QD"
version = v"2.3.22"

# Collection of sources required to build SDPA-QD
sources = [
    "https://www.davidhbailey.com/dhbsoftware/qd-2.3.22.tar.gz" =>
    "30c1ffe46b95a0e9fa91085949ee5fca85f97ff7b41cd5fe79f79bab730206d3",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/qd-2.3.22
update_configure_scripts
./configure --enable-shared --enable-fast-install=no  --prefix=$prefix --host=$target --build=x86_64-linux-gnu
make
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:i686, libc=:musl),
    Linux(:x86_64, libc=:musl),
    Linux(:aarch64, libc=:musl),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf),
    MacOS(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libqd_f_main", :libqd_f_main),
    LibraryProduct(prefix, "libqdmod", :libqdmod),
    LibraryProduct(prefix, "libqd", :libqd)
]

# Dependencies that must be installed before this package can be built
dependencies = []

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
