#include "FDMEngine.hpp"

#include <string>

#include "libslic3r/Exception.hpp"
#include "libslic3r/Model.hpp"

namespace Slic3r::FDM {

SliceResult Engine::slice(const SliceRequest& request)
{
    if (m_print == nullptr)
        throw Slic3r::RuntimeError("FDMEngine requires an attached Print instance");
    if (request.model == nullptr)
        throw Slic3r::RuntimeError("FDMEngine::slice requires a valid model pointer");
    return run_slice(request);
}

SliceResult Engine::run_slice(const SliceRequest& request)
{
    SliceResult result;
    m_print->clear();

    m_print->apply(*request.model, request.config);
    m_print->set_task(PrintBase::TaskParams());

    m_print->process();

    if (request.export_gcode) {
        if (request.output_path.empty())
            throw Slic3r::RuntimeError("FDMEngine::slice requested export but no output path was provided");
        m_print->export_gcode(request.output_path.string(), nullptr);
        result.gcode_path = request.output_path;
    }

    const std::string validation_error = m_print->validate(&result.warnings);
    if (!validation_error.empty())
        result.warnings.push_back(validation_error);

    m_print->cleanup();
    result.success = true;
    return result;
}

} // namespace Slic3r::FDM
