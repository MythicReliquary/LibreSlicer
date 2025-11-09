// Adaptive pressure advance post-processing (ported from OrcaSlicer)

#ifndef slic3r_AdaptivePAProcessor_hpp_
#define slic3r_AdaptivePAProcessor_hpp_

#include <memory>
#include <regex>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>

#include "AdaptivePAInterpolator.hpp"

namespace Slic3r {

class GCodeGenerator;
class PrintConfig;

class AdaptivePAProcessor
{
public:
    AdaptivePAProcessor(GCodeGenerator& gcodegen, const std::vector<unsigned int>& tools_used);

    std::string process_layer(std::string&& gcode);
    void        resetPreviousPA(double pa) { m_last_predicted_pa = pa; }

private:
    AdaptivePAInterpolator* getInterpolator(unsigned int tool_id);

    GCodeGenerator&                                            m_gcodegen;
    std::unordered_map<unsigned int, std::unique_ptr<AdaptivePAInterpolator>> m_interpolators;
    const PrintConfig&                                        m_config;
    double                                                    m_last_predicted_pa { 0. };
    double                                                    m_max_next_feedrate { 0. };
    double                                                    m_next_feedrate { 0. };
    double                                                    m_current_feedrate { 0. };
    int                                                       m_last_extruder_id { -1 };
    std::regex                                                m_pa_change_pattern;
    std::regex                                                m_g1_f_pattern;
    std::smatch                                               m_match;
};

} // namespace Slic3r

#endif // slic3r_AdaptivePAProcessor_hpp_
