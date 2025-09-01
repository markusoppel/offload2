#include<sycl/sycl.hpp>
#include<sycl/device_selector.hpp>
#include "gpuinit.hpp"

using namespace sycl;
using namespace std;
#
extern "C" {
    void DPCPPinit() {
        // The default device selector will select the most performant device.
	default_selector device;
            queue q(device, exception_handler);

            // Print out the device information used for the kernel code.
            std::cout << "Running on device: "
                << q.get_device().get_info<info::device::name>() << "\n";
            std::cout << "Device vendor: "
                << q.get_device().get_info<info::device::vendor>() << "\n";
            std::cout << "Global device memory: "
                << q.get_device().get_info<info::device::global_mem_size>() << "\n";
    }
}
