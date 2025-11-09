#include "MeshRepair.hpp"

#include <algorithm>

#include "Model.hpp"
#include "TriangleMesh.hpp"

namespace Slic3r::MeshRepair {

namespace {

std::size_t repaired_error_count(const RepairedMeshErrors& errors)
{
    return static_cast<std::size_t>(errors.edges_fixed)
         + static_cast<std::size_t>(errors.degenerate_facets)
         + static_cast<std::size_t>(errors.facets_removed)
         + static_cast<std::size_t>(errors.facets_reversed)
         + static_cast<std::size_t>(errors.backwards_edges);
}

bool should_process_volume(std::size_t index, const std::vector<std::size_t>* filter)
{
    if (filter == nullptr)
        return true;
    return std::find(filter->begin(), filter->end(), index) != filter->end();
}

VolumeReport repair_volume(ModelVolume& volume, const Options& options)
{
    VolumeReport report;
    report.volume_name = volume.name;

    if (!options.run_default_pass)
        return report;

    TriangleMesh mesh(*volume.get_mesh_shared_ptr());
    const auto before = mesh.stats().repaired_errors;
    mesh.repair();
    const auto after = mesh.stats().repaired_errors;

    if (after.repaired() && repaired_error_count(after) != repaired_error_count(before)) {
        volume.set_mesh(std::move(mesh));
        if (ModelObject* object = volume.get_object())
            object->invalidate_bounding_box();
        report.repaired = true;
        report.errors_fixed = repaired_error_count(after);
    }

    return report;
}

void accumulate(Report& summary, const VolumeReport& volume_report)
{
    summary.volumes_processed += 1;
    summary.details.push_back(volume_report);
    if (volume_report.repaired) {
        summary.volumes_repaired += 1;
        summary.total_errors_fixed += volume_report.errors_fixed;
        summary.modifications_applied = true;
    }
}

} // namespace

Report repair_model_object(ModelObject& object, const Options& options, const std::vector<std::size_t>* volume_filter)
{
    Report report;
    report.objects_processed = 1;

    for (std::size_t idx = 0; idx < object.volumes.size(); ++idx) {
        if (!should_process_volume(idx, volume_filter))
            continue;
        if (ModelVolume* volume = object.volumes[idx])
            accumulate(report, repair_volume(*volume, options));
    }

    return report;
}

Report repair_model_selection(const std::vector<ModelObject*>& objects, const Options& options)
{
    Report summary;
    for (ModelObject* object : objects) {
        if (object == nullptr)
            continue;
        auto report = repair_model_object(*object, options);
        summary.objects_processed += report.objects_processed;
        summary.volumes_processed += report.volumes_processed;
        summary.volumes_repaired += report.volumes_repaired;
        summary.total_errors_fixed += report.total_errors_fixed;
        summary.modifications_applied = summary.modifications_applied || report.modifications_applied;
        summary.details.insert(summary.details.end(), report.details.begin(), report.details.end());
    }
    return summary;
}

} // namespace Slic3r::MeshRepair
