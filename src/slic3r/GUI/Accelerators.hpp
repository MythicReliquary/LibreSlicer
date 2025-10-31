#pragma once

#include <wx/defs.h>

class wxFrame;

namespace Slic3r::GUI {

void ResetGlobalAccelerators();
void AddGlobalAccelerator(int modifiers, int keycode, int command_id);
void InstallGlobalAccelerators(wxFrame* frame);

} // namespace Slic3r::GUI

