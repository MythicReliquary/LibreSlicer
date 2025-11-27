#pragma once

#include <string_view>

#ifndef LIBRESLICER_UPDATER
#define LIBRESLICER_UPDATER 0
#endif

#ifndef LS_DISABLE_UPDATE_CHECKER
#define LS_DISABLE_UPDATE_CHECKER 1
#endif

#ifndef LIBRESLICER_TELEMETRY_ENABLED
#define LIBRESLICER_TELEMETRY_ENABLED 0
#endif

#ifndef LIBRESLICER_VENDOR_HOST
#define LIBRESLICER_VENDOR_HOST ""
#endif

namespace FeatureToggles {

inline constexpr bool kUpdaterEnabled = (LIBRESLICER_UPDATER != 0) && (LS_DISABLE_UPDATE_CHECKER == 0);
inline constexpr bool kTelemetryEnabled = (LIBRESLICER_TELEMETRY_ENABLED != 0);
inline constexpr std::string_view kVendorHost = std::string_view(LIBRESLICER_VENDOR_HOST);
inline constexpr bool kVendorHostConfigured = !kVendorHost.empty();

} // namespace FeatureToggles

