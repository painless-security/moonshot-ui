/*
 * Copyright (c) 2016, JANET(UK)
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


// Defined here as workaround for emacs vala-mode indentation failure.
#if VALA_0_12
static const string CANCEL = Stock.CANCEL;
#else
static const string CANCEL = STOCK_CANCEL;
#endif


class IdentityDialog : Dialog
{
    private static Gdk.Color white = make_color(65535, 65535, 65535);
    private static Gdk.Color selected_color = make_color(0xd9 << 8, 0xf7 << 8, 65535);
    private static Gdk.Color alt_color = make_color(0xf2 << 8, 0xf2 << 8, 0xf2 << 8);

    private static Gdk.Color make_color(uint16 red, uint16 green, uint16 blue)
    {
        Gdk.Color color = Gdk.Color();
        color.red = red;
        color.green = green;
        color.blue = blue;

        return color;
    }

    private static MoonshotLogger logger = get_logger("IdentityDialog");

    static const string displayname_labeltext = _("Display Name");
    static const string realm_labeltext = _("Realm");
    static const string username_labeltext = _("Username");
    static const string password_labeltext = _("Password");

    private IdentityManagerView parent;
    private Entry displayname_entry;
    private Label displayname_label;
    private Entry realm_entry;
    private Label realm_label;
    private Entry username_entry;
    private Label username_label;
    private Entry password_entry;
    private Label password_label;
    private CheckButton remember_checkbutton;
    private Label message_label;
    public bool complete;
    private IdCard card;

    private Label selected_item = null;

    public string display_name {
        get { return displayname_entry.get_text(); }
    }

    public string issuer {
        get { return realm_entry.get_text(); }
    }

    public string username {
        get { return username_entry.get_text(); }
    }

    public string password {
        get { return password_entry.get_text(); }
    }

    public bool store_password {
        get { return remember_checkbutton.active; }
    }

    internal string[] get_services()
    {
        return card.services;
    }

    public IdentityDialog(IdentityManagerView parent)
    {
        this.with_idcard(null, _("Add ID Card"), parent);
    }

    public IdentityDialog.with_idcard(IdCard? a_card, string title, IdentityManagerView parent)
    {
        bool is_new_card = false;
        if (a_card == null)
        {
            is_new_card = true;
        }

        card = a_card ?? new IdCard();
        this.set_title(title);
        this.set_modal(true);
        this.set_transient_for(parent);
        this.parent = parent;

        this.add_buttons(_("OK"), ResponseType.OK, CANCEL, ResponseType.CANCEL);
        Box content_area = (Box) this.get_content_area();

        displayname_label = new Label(@"$displayname_labeltext:");
        displayname_label.set_alignment(0, (float) 0.5);
        displayname_entry = new Entry();
        displayname_entry.set_text(card.display_name);
        displayname_entry.set_width_chars(40);

        realm_label = new Label(@"$realm_labeltext:");
        realm_label.set_alignment(0, (float) 0.5);
        realm_entry = new Entry();
        realm_entry.set_text(card.issuer);
        realm_entry.set_width_chars(60);

        username_label = new Label(@"$username_labeltext:");
        username_label.set_alignment(0, (float) 0.5);
        username_entry = new Entry();
        username_entry.set_text(card.username);
        username_entry.set_width_chars(40);

        password_label = new Label(@"$password_labeltext:");
        password_label.set_alignment(0, (float) 0.5);
        password_entry = new Entry();
        password_entry.set_invisible_char('*');
        password_entry.set_visibility(false);
        password_entry.set_text(card.password);
        password_entry.set_width_chars(40);

        remember_checkbutton = new CheckButton.with_label(_("Remember password"));
        message_label = new Label("");
        message_label.set_visible(false);

        set_atk_relation(displayname_label, displayname_entry, Atk.RelationType.LABEL_FOR);
        set_atk_relation(realm_label, realm_entry, Atk.RelationType.LABEL_FOR);
        set_atk_relation(username_label, username_entry, Atk.RelationType.LABEL_FOR);
        set_atk_relation(password_entry, password_entry, Atk.RelationType.LABEL_FOR);

        content_area.pack_start(message_label, false, false, 6);
        add_as_vbox(content_area, displayname_label, displayname_entry);
        add_as_vbox(content_area, username_label, username_entry);
        add_as_vbox(content_area, realm_label, realm_entry);
        add_as_vbox(content_area, password_label, password_entry);

        // var entries = new VBox(false, 6);
        // add_as_vbox(entries, displayname_label, displayname_entry);
        // add_as_vbox(entries, realm_label, realm_entry);
        // add_as_vbox(entries, username_label, username_entry);
        // add_as_vbox(entries, password_label, password_entry);
        // content_area.pack_start(entries, false, false, 0);

        var remember_hbox = new HBox(false, 40);
        remember_hbox.pack_start(new HBox(false, 0), false, false, 0);
        remember_hbox.pack_start(remember_checkbutton, false, false, 0);
        content_area.pack_start(remember_hbox, false, false, 2);
        // content_area.pack_start(remember_checkbutton, false, false, 2);

        this.response.connect(on_response);
        content_area.set_border_width(6);

        if (!is_new_card)
        {
            var services_vbox = make_services_vbox();
            content_area.pack_start(services_vbox);
        }

        this.set_border_width(6);
        this.set_resizable(false);
        this.modify_bg(StateType.NORMAL, white);
        this.show_all();
    }

    private static void add_as_vbox(Box content_area, Label label, Entry entry)
    {
        VBox vbox = new VBox(false, 2);

        vbox.pack_start(label, false, false, 0);
        vbox.pack_start(entry, false, false, 0);

        // Hack to prevent the text entries from stretching horizontally
        HBox hbox = new HBox(false, 0);
        hbox.pack_start(vbox, false, false, 0);
        content_area.pack_start(hbox, false, false, 6);
    }

    private static string update_preamble(string preamble)
    {
        if (preamble == "")
            return _("Missing required field: ");
        return _("Missing required fields: ");
    }

    private static string update_message(string old_message, string new_item)
    {
        string message;
        if (old_message == "")
            message = new_item;
        else
            message = old_message + ", " + new_item;
        return message;
    }

    private static void check_field(string field, Label label, string fieldname, ref string preamble, ref string message)
    {
        if (field != "") {
            label.set_markup(@"$fieldname:");
            return;
        }
        label.set_markup(@"<span foreground=\"red\">$fieldname:</span>");
        preamble = update_preamble(preamble);
        message = update_message(message, fieldname);
    }

    private bool check_fields()
    {
        string preamble = "";
        string message = "";
        string password_test = store_password ? password : "not required";
        check_field(display_name, displayname_label, displayname_labeltext, ref preamble, ref message);
        check_field(username, username_label, username_labeltext, ref preamble, ref message);
        check_field(issuer, realm_label, realm_labeltext, ref preamble, ref message);
        check_field(password_test, password_label, password_labeltext, ref preamble, ref message);
        if (message != "") {
            message_label.set_visible(true);
            message_label.set_markup(@"<span foreground=\"red\">$preamble$message</span>");
            return false;
        }
        return true;
    }

    private void on_response(Dialog source, int response_id)
    {
        switch (response_id) {
        case ResponseType.OK:
            complete = check_fields();
            break;
        case ResponseType.CANCEL:
            complete = true;
            break;
        }
    }

    private void set_atk_relation(Widget widget, Widget target_widget, Atk.RelationType relationship)
    {
        var atk_widget = widget.get_accessible();
        var atk_target_widget = target_widget.get_accessible();

        atk_widget.add_relationship(relationship, atk_target_widget);
    }

    private static void label_make_bold(Label label)
    {
        var font_desc = new Pango.FontDescription();

        font_desc.set_weight(Pango.Weight.BOLD);

        /* This will only affect the weight of the font. The rest is
         * from the current state of the widget, which comes from the
         * theme or user prefs, since the font desc only has the
         * weight flag turned on.
         */
        label.modify_font(font_desc);
    }

    private VBox make_services_vbox()
    {
        logger.trace("make_services_vbox");

        var services_vbox_alignment = new Alignment(0, 0, 0, 1);
        services_vbox_alignment.set_padding(6, 6, 6, 6);
        var services_vscroll = new ScrolledWindow(null, null);
        services_vscroll.set_policy(PolicyType.NEVER, PolicyType.AUTOMATIC);
        services_vscroll.set_shadow_type(ShadowType.IN);
        services_vscroll.set_size_request(0, 60);
        services_vscroll.add_with_viewport(services_vbox_alignment);

#if VALA_0_12
        var remove_button = new Button.from_stock(Stock.REMOVE);
#else
        var remove_button = new Button.from_stock(STOCK_REMOVE);
#endif
        remove_button.set_sensitive(false);


        var services_table = new Table(card.services.length, 1, false);
        services_table.set_row_spacings(5);

        var table_button_hbox = new HBox(false, 6);
        table_button_hbox.pack_start(services_vscroll, true, true, 6);

        // Hack to prevent the button from growing vertically
        VBox fixed_height = new VBox(false, 0);
        fixed_height.pack_start(remove_button, false, false, 0);
        table_button_hbox.pack_start(fixed_height, false, false, 6);
        services_vbox_alignment.add(services_table);

        var services_vbox_title = new Label(_("Services:"));
        label_make_bold(services_vbox_title);
        services_vbox_title.set_alignment(0, (float) 0.5);

        var services_vbox = new VBox(false, 6);
        services_vbox.pack_start(services_vbox_title, false, false, 6);
        services_vbox.pack_start(table_button_hbox, true, true, 6);

        int i = 0;
        foreach (string service in card.services)
        {
            var label = new Label(service);
            label.set_alignment(0, (float) 0);

            EventBox event_box = new EventBox();
            event_box.add(label);
            event_box.button_press_event.connect(() =>
                {
                    var state = label.get_state();
                    if (selected_item == label)
                    {
                        // Deselect
                        selected_item.modify_bg(state, white);
                        selected_item = null;
                        remove_button.set_sensitive(false);
                    }
                    else
                    {
                        if (selected_item != null)
                        {
                            // Deselect
                            selected_item.modify_bg(state, white);
                            selected_item = null;
                        }

                        // Select
                        selected_item = label;
                        selected_item.modify_bg(state, selected_color);
                        remove_button.set_sensitive(true);
                    }
                    return false;
                });

            services_table.attach_defaults(event_box, 0, 1, i, i+1);
            i++;
        }

        remove_button.clicked.connect((remove_button) =>
            {
                var dialog = new Gtk.MessageDialog(this,
                                                   Gtk.DialogFlags.DESTROY_WITH_PARENT,
                                                   Gtk.MessageType.QUESTION,
                                                   Gtk.ButtonsType.YES_NO,
                                                   _("You are about to remove the service '%s'. Are you sure you want to do this?"),
                                                   selected_item.label);
                var ret = dialog.run();
                dialog.destroy();

                if (ret == Gtk.ResponseType.YES)
                {
                    if (card != null) {
                        SList<string> services = new SList<string>();

                        foreach (string srv in card.services)
                        {
                            if (srv != selected_item.label)
                                services.append(srv);
                        }

                        card.services = new string[services.length()];
                        for (int j = 0; j < card.services.length; j++)
                        {
                            card.services[j] = services.nth_data(j);
                        }

                        services_table.remove(selected_item.parent);
                        selected_item = null;
                        remove_button.set_sensitive(false);
                    }
                }

            });

        return services_vbox;
    }


}
