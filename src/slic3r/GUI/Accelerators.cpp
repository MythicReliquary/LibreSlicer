#include "Accelerators.hpp"

#include <algorithm>
#include <vector>

#include <wx/accel.h>
#include <wx/frame.h>

namespace Slic3r::GUI {

namespace {

std::vector<wxAcceleratorEntry>& accelerators()
{
    static std::vector<wxAcceleratorEntry> entries;
    return entries;
}

} // namespace

void ResetGlobalAccelerators()
{
    accelerators().clear();
}

void AddGlobalAccelerator(int modifiers, int keycode, int command_id)
{
    if (command_id == wxID_NONE)
        return;
    wxAcceleratorEntry entry;
    entry.Set(modifiers, keycode, command_id);
    accelerators().push_back(entry);
}

void InstallGlobalAccelerators(wxFrame* frame)
{
    if (frame == nullptr) {
        accelerators().clear();
        return;
    }

    std::vector<wxAcceleratorEntry> entries = accelerators();

#if defined(_WIN32)
    // Allow Ctrl+Numpad digits to behave the same as Ctrl+digits.
    const int base_id = wxID_HIGHEST + 1;
    for (int idx = 0; idx < 6; ++idx) {
        wxAcceleratorEntry entry;
        entry.Set(wxACCEL_CTRL, WXK_NUMPAD1 + idx, base_id + idx);
        entries.push_back(entry);
    }
#endif

    if (entries.empty()) {
        frame->SetAcceleratorTable(wxAcceleratorTable());
        return;
    }

    frame->SetAcceleratorTable(wxAcceleratorTable(static_cast<int>(entries.size()), entries.data()));
    accelerators().clear();
}

} // namespace Slic3r::GUI

