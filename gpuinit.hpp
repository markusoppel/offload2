#include <sycl/sycl.hpp>

auto exception_handler = [](sycl::exception_list exceptionList) {
  for (std::exception_ptr const& e : exceptionList) {
    try {
      std::rethrow_exception(e);
    } catch (sycl::exception const& e) {
      std::terminate();  // exit the process immediately.
    }
  }
};

