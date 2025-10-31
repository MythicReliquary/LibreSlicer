#pragma once

#include <wx/string.h>

inline wxString LabelNoAccel(const wxString& s)
{
    const int tab = s.Find('\t');
    return tab == wxNOT_FOUND ? s : s.substr(0, tab);
}

