#pragma once

#ifndef LIBRESLICER_UPDATER
#define LIBRESLICER_UPDATER 1
#endif

#ifndef LS_DISABLE_UPDATE_CHECKER
#define LS_DISABLE_UPDATE_CHECKER 0
#endif

namespace FeatureToggles {

inline constexpr bool kUpdaterEnabled = (LIBRESLICER_UPDATER != 0) && (LS_DISABLE_UPDATE_CHECKER == 0);

} // namespace FeatureToggles

