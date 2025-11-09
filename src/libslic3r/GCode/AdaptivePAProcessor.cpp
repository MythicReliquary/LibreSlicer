// Adaptive pressure advance post-processing (ported from OrcaSlicer)

#include "../GCode.hpp"
#include "AdaptivePAProcessor.hpp"

#include <cmath>
#include <sstream>

namespace Slic3r {

AdaptivePAProcessor::AdaptivePAProcessor(GCodeGenerator& gcodegen, const std::vector<unsigned int>& tools_used)
    : m_gcodegen(gcodegen)
    , m_config(gcodegen.config())
    , m_pa_change_pattern(R"(; PA_CHANGE:T(\d+) MM3MM:([0-9]*\.[0-9]+) ACCEL:(\d+) BR:(\d+) RC:(\d+) OV:(\d+))")
    , m_g1_f_pattern(R"(G1 F([0-9]+))")
{
    for (const unsigned int tool : tools_used) {
        if (!m_config.adaptive_pressure_advance.get_at(tool) || !m_config.enable_pressure_advance.get_at(tool))
            continue;
        auto interpolator = std::make_unique<AdaptivePAInterpolator>();
        interpolator->parseAndSetData(m_config.adaptive_pressure_advance_model.get_at(tool));
        m_interpolators.emplace(tool, std::move(interpolator));
    }
}

AdaptivePAInterpolator* AdaptivePAProcessor::getInterpolator(unsigned int tool_id)
{
    auto it = m_interpolators.find(tool_id);
    return it != m_interpolators.end() ? it->second.get() : nullptr;
}

std::string AdaptivePAProcessor::process_layer(std::string&& gcode)
{
    std::istringstream stream(gcode);
    std::ostringstream output;
    std::string        line;

    double       mm3mm_value   = 0.0;
    unsigned int accel_value   = 0;
    std::string  pa_change_line;
    bool         wipe_command  = false;

    while (std::getline(stream, line)) {
        if (line.find("WIPE_START") != std::string::npos)
            wipe_command = true;

        if (!wipe_command && line.rfind("G1 F", 0) == 0) {
            const std::size_t pos = line.find('F');
            if (pos != std::string::npos)
                m_current_feedrate = std::stod(line.substr(pos + 1)) / 60.0;
        }

        if (line.find("WIPE_END") != std::string::npos)
            wipe_command = false;

        m_next_feedrate = 0.0;

        if (std::regex_search(line, m_match, m_pa_change_pattern)) {
            const unsigned int extruder_id = static_cast<unsigned int>(std::stoi(m_match[1].str()));
            mm3mm_value = std::stod(m_match[2].str());
            accel_value = static_cast<unsigned int>(std::stoi(m_match[3].str()));
            const bool is_bridge    = std::stoi(m_match[4].str()) != 0;
            const bool role_change  = std::stoi(m_match[5].str()) != 0;
            const bool overhang_hit = std::stoi(m_match[6].str()) != 0;
            pa_change_line = line;

            AdaptivePAInterpolator* interpolator = getInterpolator(extruder_id);
            if (!interpolator || !interpolator->isInitialised()) {
                output << line << '\n';
                continue;
            }

            if (m_last_extruder_id != static_cast<int>(extruder_id)) {
                m_last_predicted_pa = m_config.pressure_advance.get_at(extruder_id);
                m_max_next_feedrate = 0.0;
                m_last_extruder_id  = static_cast<int>(extruder_id);
            }

            std::streampos checkpoint = stream.tellg();
            std::string    lookahead;
            while (std::getline(stream, lookahead)) {
                if (lookahead.empty())
                    continue;
                if (lookahead.rfind("G1 F", 0) == 0) {
                    const std::size_t pos = lookahead.find('F');
                    if (pos != std::string::npos)
                        m_next_feedrate = std::stod(lookahead.substr(pos + 1)) / 60.0;
                    break;
                }
                if (lookahead.find("WIPE_END") != std::string::npos)
                    break;
            }
            stream.clear();
            stream.seekg(checkpoint);

            if (m_next_feedrate > m_max_next_feedrate)
                m_max_next_feedrate = m_next_feedrate;

            double eval_speed = m_current_feedrate;
            if (m_next_feedrate > 0.)
                eval_speed = std::max(eval_speed, m_next_feedrate);
            if (m_max_next_feedrate > 0.)
                eval_speed = std::max(eval_speed, m_max_next_feedrate);

            const double flow_rate = mm3mm_value * eval_speed;
            double       predicted_pa = interpolator->operator()(flow_rate, double(accel_value));

            if (is_bridge && m_config.adaptive_pressure_advance_bridges.get_at(extruder_id) > EPSILON)
                predicted_pa = m_config.adaptive_pressure_advance_bridges.get_at(extruder_id);

            if (!role_change && !overhang_hit && std::fabs(predicted_pa - m_last_predicted_pa) <= EPSILON) {
                output << line << '\n';
                continue;
            }

            output << pa_change_line << '\n';
            if (extruder_id != static_cast<unsigned int>(m_last_extruder_id) || std::fabs(predicted_pa - m_last_predicted_pa) > EPSILON) {
                output << m_gcodegen.writer().set_pressure_advance(predicted_pa);
                m_last_predicted_pa = predicted_pa;
            }
            continue;
        }

        output << line << '\n';
    }

    return output.str();
}

} // namespace Slic3r
