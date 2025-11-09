// Adaptive pressure advance interpolation helper (ported from OrcaSlicer)

#include "PchipInterpolatorHelper.hpp"

#include <algorithm>
#include <cmath>
#include <stdexcept>

void PchipInterpolatorHelper::setData(const std::vector<double>& x, const std::vector<double>& y)
{
    if (x.size() != y.size() || x.size() < 2)
        throw std::invalid_argument("PCHIP data requires matching vectors with at least two points");

    x_ = x;
    y_ = y;
    sortData();
    computePCHIP();
}

void PchipInterpolatorHelper::sortData()
{
    std::vector<std::pair<double, double>> data;
    data.reserve(x_.size());
    for (size_t i = 0; i < x_.size(); ++i)
        data.emplace_back(x_[i], y_[i]);

    std::sort(data.begin(), data.end());
    for (size_t i = 0; i < data.size(); ++i) {
        x_[i] = data[i].first;
        y_[i] = data[i].second;
    }
}

void PchipInterpolatorHelper::computePCHIP()
{
    const size_t n = x_.size() - 1;
    h_.resize(n);
    delta_.resize(n);
    d_.resize(n + 1);

    for (size_t i = 0; i < n; ++i) {
        h_[i]     = h(i);
        delta_[i] = delta(i);
    }

    d_[0] = delta_[0];
    d_[n] = delta_[n - 1];
    for (size_t i = 1; i < n; ++i) {
        if (delta_[i - 1] * delta_[i] > 0.) {
            const double w1 = 2. * h_[i] + h_[i - 1];
            const double w2 = h_[i] + 2. * h_[i - 1];
            d_[i] = (w1 + w2) / (w1 / delta_[i - 1] + w2 / delta_[i]);
        } else {
            d_[i] = 0.;
        }
    }
}

double PchipInterpolatorHelper::interpolate(double xi) const
{
    if (x_.empty())
        return 0.;

    if (xi <= x_.front())
        return y_.front();
    if (xi >= x_.back())
        return y_.back();

    auto it = std::lower_bound(x_.begin(), x_.end(), xi);
    const size_t i = static_cast<size_t>(std::distance(x_.begin(), it) - 1);

    const double h_i  = h_[i];
    const double t    = (xi - x_[i]) / h_i;
    const double t2   = t * t;
    const double t3   = t2 * t;
    const double h00  = 2. * t3 - 3. * t2 + 1.;
    const double h10  = t3 - 2. * t2 + t;
    const double h01  = -2. * t3 + 3. * t2;
    const double h11  = t3 - t2;

    return h00 * y_[i] + h10 * h_i * d_[i] + h01 * y_[i + 1] + h11 * h_i * d_[i + 1];
}
