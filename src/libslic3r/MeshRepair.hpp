#ifndef SLIC3R_MESH_REPAIR_HPP_
#define SLIC3R_MESH_REPAIR_HPP_

#include <cstddef>
#include <string>
#include <vector>

namespace Slic3r {

class ModelObject;
class ModelVolume;

namespace MeshRepair {

struct Options {
    bool run_default_pass{ true };
};

struct VolumeReport {
    std::string volume_name;
    bool        repaired{ false };
    std::size_t errors_fixed{ 0 };
};

struct Report {
    std::size_t                 objects_processed{ 0 };
    std::size_t                 volumes_processed{ 0 };
    std::size_t                 volumes_repaired{ 0 };
    std::size_t                 total_errors_fixed{ 0 };
    bool                        modifications_applied{ false };
    std::vector<VolumeReport>   details;
};

Report repair_model_object(ModelObject& object, const Options& options, const std::vector<std::size_t>* volume_filter = nullptr);
Report repair_model_selection(const std::vector<ModelObject*>& objects, const Options& options);

} // namespace MeshRepair
} // namespace Slic3r

#endif // SLIC3R_MESH_REPAIR_HPP_
