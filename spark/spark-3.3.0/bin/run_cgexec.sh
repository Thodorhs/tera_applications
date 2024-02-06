#!/usr/bin/env bash

export LIBRARY_PATH=/spare/thodp/teraheap/allocator/lib:$LIBRARY_PATH
export LD_LIBRARY_PATH=/spare/thodp/teraheap/allocator/lib:$LD_LIBRARY_PATH
export PATH=/spare/thodp/teraheap/allocator/include:$PATH
export C_INCLUDE_PATH=/spare/thodp/teraheap/allocator/include:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=/spare/thodp/teraheap/allocator/include:$CPLUS_INCLUDE_PATH

export LIBRARY_PATH=/spare/thodp/teraheap/tera_malloc/lib:$LIBRARY_PATH
export LD_LIBRARY_PATH=/spare/thodp/teraheap/tera_malloc/lib:$LD_LIBRARY_PATH
export PATH=/spare/thodp/teraheap/tera_malloc/include:$PATH
export C_INCLUDE_PATH=/spare/thodp/teraheap/tera_malloc/include:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=/spare/thodp/teraheap/tera_malloc/include:$CPLUS_INCLUDE_PATH

LD_PRELOAD=/usr/lib64/libjemalloc.so.1
export LD_PRELOAD
"$@"
#numactl --cpunodebind=0 "$@"
