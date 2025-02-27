//===-- Linux implementation of the mtx_init function ---------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "src/threads/mtx_init.h"
#include "include/threads.h" // For mtx_t definition.
#include "src/__support/common.h"
#include "src/__support/threads/mutex.h"

namespace __llvm_libc {

LLVM_LIBC_FUNCTION(int, mtx_init, (mtx_t * m, int type)) {
  auto err = Mutex::init(m, type & mtx_timed, type & mtx_recursive, 0);
  return err == MutexError::NONE ? thrd_success : thrd_error;
}

} // namespace __llvm_libc
