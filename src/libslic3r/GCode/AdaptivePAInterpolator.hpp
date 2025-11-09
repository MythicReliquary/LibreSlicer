// Adaptive pressure advance interpolator (ported from OrcaSlicer)

#ifndef slic3r_AdaptivePAInterpolator_hpp_
#define slic3r_AdaptivePAInterpolator_hpp_

#include <map>
#include <string>
#include <vector>

#include "PchipInterpolatorHelper.hpp"

class AdaptivePAInterpolator
{
public:
    AdaptivePAInterpolator() = default;

    int    parseAndSetData(const std::string& data);
    double operator()(double flow_rate, double acceleration);

    bool isInitialised() const { return m_is_initialised; }

private:
    std::map<double, PchipInterpolatorHelper> m_flow_models;
    std::vector<double>                       m_accelerations;
    bool                                      m_is_initialised { false };
};

#endif // slic3r_AdaptivePAInterpolator_hpp_
