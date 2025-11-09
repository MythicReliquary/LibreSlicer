// Adaptive pressure advance interpolation helper (ported from OrcaSlicer)
// Provides a small PCHIP (Piecewise Cubic Hermite Interpolating Polynomial)
// implementation used by AdaptivePAInterpolator.

#ifndef slic3r_PchipInterpolatorHelper_hpp_
#define slic3r_PchipInterpolatorHelper_hpp_

#include <vector>

class PchipInterpolatorHelper
{
public:
    PchipInterpolatorHelper() = default;
    PchipInterpolatorHelper(const std::vector<double>& x, const std::vector<double>& y) { setData(x, y); }

    void setData(const std::vector<double>& x, const std::vector<double>& y);
    double interpolate(double xi) const;

private:
    std::vector<double> x_;
    std::vector<double> y_;
    std::vector<double> h_;
    std::vector<double> delta_;
    std::vector<double> d_;

    void sortData();
    void computePCHIP();

    double h(size_t i) const { return x_[i + 1] - x_[i]; }
    double delta(size_t i) const { return (y_[i + 1] - y_[i]) / h(i); }
};

#endif // slic3r_PchipInterpolatorHelper_hpp_
