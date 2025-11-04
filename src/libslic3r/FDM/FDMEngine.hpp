#ifndef SLIC3R_FDM_FDMENGINE_HPP_
#define SLIC3R_FDM_FDMENGINE_HPP_

#include <functional>
#include <vector>
#include <boost/filesystem/path.hpp>

#include "libslic3r/Print.hpp"
#include "libslic3r/PrintConfig.hpp"

namespace Slic3r {
class Model;
}

namespace Slic3r::FDM {

struct SliceRequest {
    const Model*                       model{ nullptr };
    DynamicPrintConfig                 config;
    boost::filesystem::path            output_path;
    bool                               export_gcode{ true };
};

struct SliceResult {
    boost::filesystem::path            gcode_path;
    std::vector<std::string>           warnings;
    bool                               success{ false };
};

class Engine
{
public:
    Engine() = default;
    explicit Engine(Print* print) : m_print(print) {}

    void set_print(Print* print) { m_print = print; }
    Print* print() const { return m_print; }

    SliceResult slice(const SliceRequest& request);

private:
    SliceResult run_slice(const SliceRequest& request);

    Print* m_print{ nullptr };
};

} // namespace Slic3r::FDM

#endif // SLIC3R_FDM_FDMENGINE_HPP_
