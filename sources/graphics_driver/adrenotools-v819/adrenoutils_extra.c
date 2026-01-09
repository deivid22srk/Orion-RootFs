#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include <dlfcn.h>
#include <stdarg.h>
#include <android/log.h>

int get_override_device_uuid(uint8_t *uuid_out, uint32_t size, uint32_t a1, uint32_t a2, uint32_t a3) {
	int (*get_device_uuid)(uint8_t *, uint32_t, uint32_t, uint32_t, uint32_t);
    void *handle = dlopen("./notadreno_utils.so", RTLD_NOW);
    
    if (!handle)
        __android_log_print(ANDROID_LOG_ERROR, "AdrenoUtils", "Failed to open notadreno_utils.so handle, %s", dlerror());
    
    get_device_uuid = dlsym(handle, "get_device_uuid");

    int res = get_device_uuid(uuid_out, size, a1, a2, a3);

    return res;
}

int get_driver_uuid(uint8_t *uuid_out, uint32_t size, uint32_t a1, uint32_t a2, uint32_t a3) {
	int (*get_driver_uuid)(uint8_t *, uint32_t, uint32_t, uint32_t, uint32_t);
	void *handle = dlopen("/vendor/lib64/libadreno_utils.so", RTLD_NOW);

	if (!handle)
	    __android_log_print(ANDROID_LOG_ERROR, "AdrenoUtils", "Failed to open libadreno_utils.so handle, %s", dlerror());

	get_driver_uuid = dlsym(handle, "get_driver_uuid");

	int res = get_driver_uuid(uuid_out, size, a1, a2, a3);

	return res;
}
