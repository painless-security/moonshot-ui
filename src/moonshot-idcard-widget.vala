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

class IdCardWidget : Box
{
    static MoonshotLogger logger = get_logger("IdCardWidget");

    public IdCard id_card { get; set; default = null; }
    private VBox main_vbox;
    private HBox table;
    private EventBox event_box;
    private bool   is_selected = false;
    
    private Label label;

    internal int _position = 0;
    internal int position {
        get {return _position;}
        set {_position = value; set_idcard_color();}
    }

    public signal void expanded();
    public signal void collapsed();

    private void select()
    {
        expand();
        this.expanded();
    }

    private void unselect()
    {
        collapse();
        this.collapsed();
    }

    public void expand()
    {
        is_selected = true;
        update_id_card_label();

        set_idcard_color();
        this.expanded();
    }

    public void collapse()
    {
        is_selected = false;
        update_id_card_label();

        set_idcard_color();
    }

    private bool button_press_cb()
    {
        if (is_selected)
            unselect();
        else
            select();

        return false;
    }

    private void set_idcard_color()
    {
        var color = Gdk.Color();

        if (is_selected)
        {
                color.red = 0xd9 << 8;
                color.green = 0xf7 << 8;
                color.blue = 65535;
        }
        else {
            if (position % 2 == 0)
            {
                color.red = color.green = color.blue = 0xf2 << 8;
            }
            else
            {
                color.red = 65535;
                color.green = 65535;
                color.blue = 65535;

            }
        }
        var state = this.get_state();
        this.event_box.modify_bg(state, color);
    }
    
    private void
    update_id_card_label()
    {
        // !!TODO: Use a table to format the labels and values
        string services_text = _("Services:  ");
        string service_spacer = _("\n                ");

        var label_text = Markup.printf_escaped(_("<big>%s</big>"), this.id_card.display_name);

        if (is_selected)
        {
            label_text += "\nUsername:  " + id_card.username;
            label_text += "\nRealm:  " + id_card.issuer;
            if (!id_card.trust_anchor.is_empty()) {
                label_text += _("\nTrust anchor: Enterprise provisioned");
            }
            services_text += this.id_card.get_services_string(service_spacer);
            label_text += _("\n") + services_text;
        }

        label.set_markup(label_text);
    }

    public IdCardWidget(IdCard id_card)
    {
        this.id_card = id_card;

        var image = new Image.from_pixbuf(get_pixbuf(id_card));

        label = new Label(null);
        label.set_alignment((float) 0, (float) 0.5);
        label.set_ellipsize(Pango.EllipsizeMode.END);
        update_id_card_label();

        table = new Gtk.HBox(false, 6);
        table.pack_start(image, false, false, 0);
        table.pack_start(label, true, true, 0);

        this.main_vbox = new VBox(false, 12);
        main_vbox.pack_start(table, true, true, 0);
        main_vbox.set_border_width(12);

        event_box = new EventBox();
        event_box.add(main_vbox);
        event_box.button_press_event.connect(button_press_cb);
        event_box.set_visible(false);
        this.pack_start(event_box, true, true);

        this.show_all();

        set_idcard_color();
    }
}
