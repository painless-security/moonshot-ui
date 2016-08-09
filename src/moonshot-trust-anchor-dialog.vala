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

class TrustAnchorDialog : Dialog
{
    private static Gdk.Color white = make_color(65535, 65535, 65535);

    private Entry trust_anchor_entry;

    public bool complete = false;

    public TrustAnchorDialog(IdCard idcard, Window parent)
    {
        this.set_title(_("Trust Anchor"));
        this.set_modal(true);
        this.set_transient_for(parent);
        this.modify_bg(StateType.NORMAL, white);

        this.add_buttons(_("Connect"), ResponseType.OK,
                         _("Cancel"), ResponseType.CANCEL);

        this.set_default_response(ResponseType.OK);

        var content_area = this.get_content_area();
        ((Box) content_area).set_spacing(12);
        content_area.modify_bg(StateType.NORMAL, white);

        Label dialog_label = new Label("");
        dialog_label.set_alignment(0, 0);

        string label_markup = _("<span font-weight='heavy'>You are using this identity for the first time with the following trust anchor:</span>");

        dialog_label.set_markup(label_markup);
        dialog_label.set_line_wrap(true);
        dialog_label.set_width_chars(60);
                                                   
        var user_label = new Label(_("Username: ") + idcard.username);
        user_label.set_alignment(0, 0.5f);

        var realm_label = new Label(_("Realm: ") + idcard.issuer);
        realm_label.set_alignment(0, 0.5f);

        var fingerprint_label = new Label(_("SHA-256 fingerprint:"));
        fingerprint_label.set_alignment(0, 0.5f);

        var footprint = new TextView();
        //footprint.activates_default = false;
        // footprint.set_sensitive(false);
        footprint.set_editable(false);
        // footprint.set_text(idcard.trust_anchor.server_cert);
        var buffer = footprint.get_buffer();
        buffer.set_text(colonize(idcard.trust_anchor.server_cert), -1);
        footprint.wrap_mode = WrapMode.WORD_CHAR;

        set_atk_relation(fingerprint_label, footprint, Atk.RelationType.LABEL_FOR);

        var footprint_width_constraint = new ScrolledWindow(null, null);
        footprint_width_constraint.set_policy(PolicyType.NEVER, PolicyType.NEVER);
        footprint_width_constraint.set_shadow_type(ShadowType.IN);
        footprint_width_constraint.set_size_request(400, 60);
        footprint_width_constraint.add_with_viewport(footprint);

        Label confirm_label = new Label(_("Please confirm that this is the correct trust anchor."));
        confirm_label.set_alignment(0, 0.5f);

        var vbox = new VBox(false, 0);
        vbox.set_border_width(6);
        vbox.pack_start(dialog_label, true, true, 12);
        vbox.pack_start(user_label, true, true, 2);
        vbox.pack_start(realm_label, true, true, 2);
        vbox.pack_start(fingerprint_label, true, true, 2);
        vbox.pack_start(footprint_width_constraint, true, true, 2);
        vbox.pack_start(confirm_label, true, true, 12);

        ((Container) content_area).add(vbox);

        this.set_border_width(6);
        this.set_resizable(false);

        this.response.connect(on_response);

        this.show_all();
    }

    private void on_response(Dialog source, int response_id)
    {
        switch (response_id) {
        case ResponseType.OK:
            complete = true;
            break;
        case ResponseType.CANCEL:
            complete = true;
            break;
        }
    }

    // Yeah, it doesn't mean "colonize" the way you might think... :-)
    private static string colonize(string input) {
        return_if_fail(input.length % 2 == 0);

        string result = "";
        int i = 0;
        while (i < input.length) {
            if (i > 0) {
                result += ":";
            }
            result += input[i : i + 2];
            i += 2;
        }
        return result;
    }
}
