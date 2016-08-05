/*
 * Copyright (c) 2011-2016, JANET(UK)
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * 3. Neither the name of JANET(UK) nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
*/
using Gtk;

// MessageDialog doesn't allow subclassing, so we merely wrap the
// constructor for it the dialog, and then run it, returning the result.
class WarningDialog 
{
    public static bool confirm(Window parent, string message, string dialog_name)
    {
        Gdk.Color white = make_color(65535, 65535, 65535);

        MessageDialog dialog = new Gtk.MessageDialog(parent,
                                                     Gtk.DialogFlags.DESTROY_WITH_PARENT,
                                                     Gtk.MessageType.WARNING,
                                                     Gtk.ButtonsType.YES_NO,
                                                     "");

        var content_area = dialog.get_content_area();
        CheckButton remember_checkbutton;

        if (dialog_name != null && dialog_name != "")
        {
            remember_checkbutton = new CheckButton.with_label(_("Do not show this message again"));
            remember_checkbutton.set_focus_on_click(false);
            remember_checkbutton.has_focus = false;
            content_area.has_focus = true;

// Not sure if 0.26 is the minimum for MessageDialog.get_message_area. 0.16 sure isn't :-(
#if VALA_0_26
            var message_area = dialog.get_message_area();
            ((Box)message_area).pack_start(remember_checkbutton, false, false, 12);
#else
            HBox hbox = new HBox(false, 0);
            hbox.pack_start(new HBox(false, 0), true, true, 20);
            hbox.pack_start(remember_checkbutton, false, false, 12);
            ((Box)content_area).pack_start(hbox, true, true, 12);
#endif
        }

        // dialog.set_modal(true);
        dialog.set_title(_("Warning"));
        dialog.modify_bg(StateType.NORMAL, white);

        // ((Box) content_area).set_spacing(12);
        content_area.modify_bg(StateType.NORMAL, white);

        content_area.show_all();

        dialog.set_markup(message);

        var ret = dialog.run();
        dialog.destroy();
        return (ret == Gtk.ResponseType.YES);
    }
}
