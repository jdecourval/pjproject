#!/usr/bin/sh

export AFL_HARDEN=1
export AFL_LLVM_MAP_ADDR=1
export AFL_IMPORT_FIRST=1

make clean
(
  echo regular
  CC=afl-clang-lto CXX=afl-clang-lto++ RANLIB=llvm-ranlib AR=llvm-ar ./configure --disable-shared
  make -j $(nproc)
  cp pjsip-apps/bin/samples/x86_64-unknown-linux-gnu/strerror bin/regular
  make clean
)

(
  # TODO: Force 32 bits
  echo sanitizers
#  export AFL_USE_ASAN=1
  export AFL_USE_UBSAN=1
#  export AFL_USE_CFISAN=1
  unset AFL_HARDEN
  CC=afl-clang-lto CXX=afl-clang-lto++ RANLIB=llvm-ranlib AR=llvm-ar ./configure --disable-shared
  make -j $(nproc)
  cp pjsip-apps/bin/samples/x86_64-unknown-linux-gnu/strerror bin/sanitizers
  make clean
)

(
  echo cmplog
  export AFL_LLVM_CMPLOG=1
  CC=afl-clang-lto CXX=afl-clang-lto++ RANLIB=llvm-ranlib AR=llvm-ar ./configure --disable-shared
  make -j $(nproc)
  cp pjsip-apps/bin/samples/x86_64-unknown-linux-gnu/strerror bin/cmplog
)

 (
   echo laf-intel
   export AFL_LLVM_LAF_ALL=1
   CC=afl-clang-lto CXX=afl-clang-lto++ RANLIB=llvm-ranlib AR=llvm-ar ./configure --disable-shared
   make -j $(nproc)
   cp pjsip-apps/bin/samples/x86_64-unknown-linux-gnu/strerror bin/compcov
 )
