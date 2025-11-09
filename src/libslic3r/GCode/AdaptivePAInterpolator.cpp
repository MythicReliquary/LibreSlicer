// Adaptive pressure advance interpolator (ported from OrcaSlicer)

#include "AdaptivePAInterpolator.hpp"

#include <algorithm>
#include <cmath>
#include <sstream>
#include <stdexcept>

int AdaptivePAInterpolator::parseAndSetData(const std::string& data)
{
    m_flow_models.clear();
    m_accelerations.clear();

    try {
        std::istringstream                                              ss(data);
        std::string                                                     line;
        std::map<double, std::vector<std::pair<double, double>>> acc_to_samples;

        while (std::getline(ss, line)) {
            if (line.empty())
                continue;

            std::istringstream line_stream(line);
            std::string        token;

            double pa_value = 0.;
            double flow     = 0.;
            double accel    = 0.;

            if (std::getline(line_stream, token, ',') && !token.empty())
                pa_value = std::stod(token);
            if (std::getline(line_stream, token, ',') && !token.empty())
                flow = std::stod(token);
            if (std::getline(line_stream, token, ',') && !token.empty())
                accel = std::stod(token);

            acc_to_samples[accel].emplace_back(flow, pa_value);
        }

        for (const auto& kv : acc_to_samples) {
            const double                 accel  = kv.first;
            const auto&                  pairs  = kv.second;
            std::vector<double>          flows;
            std::vector<double>          pa_values;
            flows.reserve(pairs.size());
            pa_values.reserve(pairs.size());
            for (const auto& sample : pairs) {
                flows.push_back(sample.first);
                pa_values.push_back(sample.second);
            }
            if (flows.size() > 1) {
                PchipInterpolatorHelper model(flows, pa_values);
                m_flow_models.emplace(accel, std::move(model));
                m_accelerations.push_back(accel);
            }
        }
    } catch (const std::exception&) {
        m_is_initialised = false;
        return -1;
    }

    m_is_initialised = !m_flow_models.empty();
    return 0;
}

double AdaptivePAInterpolator::operator()(double flow_rate, double acceleration)
{
    std::vector<double> pa_values;
    std::vector<double> accel_values;

    for (const auto& kv : m_flow_models) {
        const double pa = kv.second.interpolate(flow_rate);
        if (pa == -1.)
            continue;
        pa_values.push_back(pa);
        accel_values.push_back(kv.first);
    }

    if (accel_values.empty())
        return -1.;
    if (accel_values.size() == 1)
        return std::round(pa_values.front() * 1000.) / 1000.;

    PchipInterpolatorHelper accel_model(accel_values, pa_values);
    return std::round(accel_model.interpolate(acceleration) * 1000.) / 1000.;
}
