// RUN: %clang_cc1 -fsycl-is-device -no-enable-noundef-analysis -emit-llvm -triple spir64 -verify -emit-llvm %s -o - | FileCheck %s

// expected-no-diagnostics

template <typename Name, typename Func>
__attribute__((sycl_kernel)) void kernel_single_task(const Func &kernelFunc) {
  kernelFunc();
}

// CHECK: define dso_local spir_func{{.*}}invoke_function{{.*}}(i32 ()* nocapture %fptr, i32 addrspace(4)* nocapture %ptr)
void invoke_function(int (*fptr)(), int *ptr) {}

int f() { return 0; }

int main() {
  kernel_single_task<class fake_kernel>([=]() {
    int (*p)() = f;
    int (&r)() = *p;
    int a = 10;
    invoke_function(p, &a);
    invoke_function(r, &a);
    invoke_function(f, &a);
  });
  return 0;
}
