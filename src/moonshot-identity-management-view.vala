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
using Gee;
using Gtk;

public class IdentityManagerView : Window {
    static MoonshotLogger logger = get_logger("IdentityManagerView");

    // The latest year in which Moonshot sources were modified.
    private static int LATEST_EDIT_YEAR = 2016;

    public static Gdk.Color white = make_color(65535, 65535, 65535);

    private const int WINDOW_WIDTH = 700;
    private const int WINDOW_HEIGHT = 500;
    protected IdentityManagerApp parent_app;
    #if OS_MACOS
        public OSXApplication osxApp;
    #endif
    private UIManager ui_manager = new UIManager();
    private Entry search_entry;
    private VBox vbox_right;
    private CustomVBox custom_vbox;
    private VBox service_prompt_vbox;
    private Label no_identity_title;
    private Button edit_button;
    private Button remove_button;

    private Button send_button;
    
    private Gtk.ListStore* listmodel;
    private TreeModelFilter filter;

    internal IdentityManagerModel identities_manager;
    private unowned SList<IdCard>    candidates;

    private GLib.Queue<IdentityRequest> request_queue;

    internal CheckButton remember_identity_binding = null;

    private enum Columns
    {
        IDCARD_COL,
        LOGO_COL,
        ISSUER_COL,
        USERNAME_COL,
        PASSWORD_COL,
        N_COLUMNS
    }

    private const string menu_layout =
    "<menubar name='MenuBar'>" +
    "        <menu name='HelpMenu' action='HelpMenuAction'>" +
    "             <menuitem name='About' action='AboutAction' />" +
    "        </menu>" +
    "</menubar>";

    public IdentityManagerView(IdentityManagerApp app) {
        parent_app = app;
        #if OS_MACOS
            osxApp = OSXApplication.get_instance();
        #endif
        identities_manager = parent_app.model;
        request_queue = new GLib.Queue<IdentityRequest>();
        this.title = "Moonshot Identity Selector";
        this.set_position(WindowPosition.CENTER);
        set_default_size(WINDOW_WIDTH, WINDOW_HEIGHT);
        build_ui();
        setup_list_model(); 
        load_id_cards(); 
        connect_signals();
    }
    
    public void on_card_list_changed() {
        load_id_cards();
    }
    
    private bool visible_func(TreeModel model, TreeIter iter)
    {
        IdCard id_card;

        model.get(iter,
                  Columns.IDCARD_COL, out id_card);

        if (id_card == null)
            return false;
        
        if (candidates != null)
        {
            bool is_candidate = false;
            foreach (IdCard candidate in candidates)
            {
                if (candidate == id_card)
                    is_candidate = true;
            }
            if (!is_candidate)
                return false;
        }
        
        string entry_text = search_entry.get_text();
        if (entry_text == null || entry_text == "")
        {
            return true;
        }

        foreach (string search_text in entry_text.split(" "))
        {
            if (search_text == "")
                continue;
         

            string search_text_casefold = search_text.casefold();

            if (id_card.issuer != null)
            {
                string issuer_casefold = id_card.issuer;

                if (issuer_casefold.contains(search_text_casefold))
                    return true;
            }

            if (id_card.display_name != null)
            {
                string display_name_casefold = id_card.display_name.casefold();
              
                if (display_name_casefold.contains(search_text_casefold))
                    return true;
            }
            
            if (id_card.services.size > 0)
            {
                foreach (string service in id_card.services)
                {
                    string service_casefold = service.casefold();

                    if (service_casefold.contains(search_text_casefold))
                        return true;
                }
            }
        }
        return false;
    }

    private void setup_list_model()
    {
        this.listmodel = new Gtk.ListStore(Columns.N_COLUMNS, typeof(IdCard),
                                           typeof(Gdk.Pixbuf),
                                           typeof(string),
                                           typeof(string),
                                           typeof(string));
        this.filter = new TreeModelFilter(listmodel, null);

        filter.set_visible_func(visible_func);
    }

    private void search_entry_icon_press_cb(EntryIconPosition pos, Gdk.Event event)
    {
        if (pos == EntryIconPosition.PRIMARY)
        {
            print("Search entry icon pressed\n");
        }
        else
        {
            this.search_entry.set_text("");
        }
    }

    private void search_entry_text_changed_cb()
    {
        this.filter.refilter();
        redraw_id_card_widgets();

        var has_text = this.search_entry.get_text_length() > 0;
        this.search_entry.set_icon_sensitive(EntryIconPosition.PRIMARY, has_text);
        this.search_entry.set_icon_sensitive(EntryIconPosition.SECONDARY, has_text);
    }

    private bool search_entry_key_press_event_cb(Gdk.EventKey e)
    {
        if(Gdk.keyval_name(e.keyval) == "Escape")
            this.search_entry.set_text("");

        // Continue processing this event, since the
        // text entry functionality needs to see it too.
        return false;
    }

    private void load_id_cards() {
        logger.trace("load_id_cards");

        string current_idcard_nai = null;
        if (this.custom_vbox.current_idcard != null) {
            current_idcard_nai = custom_vbox.current_idcard.id_card.nai;
            custom_vbox.current_idcard = null;
        }

        custom_vbox.clear();
        this.listmodel->clear();
        LinkedList<IdCard> card_list = identities_manager.get_card_list() ;
        if (card_list == null) {
            return;
        }

        foreach (IdCard id_card in card_list) {
            logger.trace(@"load_id_cards: Adding card with display name '$(id_card.display_name)'");
            add_id_card_data(id_card);
            IdCardWidget id_card_widget = add_id_card_widget(id_card);
            if (id_card_widget.id_card.nai == current_idcard_nai) {
                // fill_details(id_card_widget.id_card);
                id_card_widget.expand();
            }
        }
    }
    
    private IdCard update_id_card_data(IdentityDialog dialog, IdCard id_card)
    {
        id_card.display_name = dialog.display_name;
        id_card.issuer = dialog.issuer;
        id_card.username = dialog.username;
        id_card.password = dialog.password;
        id_card.store_password = dialog.store_password;

        id_card.update_services_from_list(dialog.get_services());

        if (dialog.clear_trust_anchor) {
            id_card.clear_trust_anchor();
        }

        return id_card;
    }

    private void add_id_card_data(IdCard id_card)
    {
        TreeIter   iter;
        Gdk.Pixbuf pixbuf;
        this.listmodel->append(out iter);
        pixbuf = get_pixbuf(id_card);
        listmodel->set(iter,
                       Columns.IDCARD_COL, id_card,
                       Columns.LOGO_COL, pixbuf,
                       Columns.ISSUER_COL, id_card.issuer,
                       Columns.USERNAME_COL, id_card.username,
                       Columns.PASSWORD_COL, id_card.password);
    }

    private void remove_id_card_data(IdCard id_card)
    {
        TreeIter iter;
        string issuer;

        if (listmodel->get_iter_first(out iter))
        {
            do
            {
                listmodel->get(iter,
                               Columns.ISSUER_COL, out issuer);

                if (id_card.issuer == issuer)
                {
                    listmodel->remove(iter);
                    break;
                }
            }
            while (listmodel->iter_next(ref iter));
        }
    }

    private IdCardWidget add_id_card_widget(IdCard id_card)
    {
        var id_card_widget = new IdCardWidget(id_card, this);
        this.custom_vbox.add_id_card_widget(id_card_widget);
        id_card_widget.expanded.connect(this.widget_selected_cb);
        id_card_widget.collapsed.connect(this.widget_unselected_cb);
        return id_card_widget;
    }

    private void widget_selected_cb(IdCardWidget id_card_widget)
    {
        this.remove_button.set_sensitive(true);
        this.edit_button.set_sensitive(true);
        this.custom_vbox.receive_expanded_event(id_card_widget);

        if (this.selection_in_progress())
             this.send_button.set_sensitive(true);
    }

    private void widget_unselected_cb(IdCardWidget id_card_widget)
    {
        this.remove_button.set_sensitive(false);
        this.edit_button.set_sensitive(false);
        this.custom_vbox.receive_collapsed_event(id_card_widget);

        this.send_button.set_sensitive(false);
    }

    public bool add_identity(IdCard id_card, bool force_flat_file_store)
    {
        #if OS_MACOS
        /* 
         * TODO: We should have a confirmation dialog, but currently it will crash on Mac OS
         * so for now we will install silently
         */
        var ret = Gtk.ResponseType.YES;
        #else
        Gtk.MessageDialog dialog;
        IdCard? prev_id = identities_manager.find_id_card(id_card.nai, force_flat_file_store);
        logger.trace("add_identity(flat=%s, card='%s'): find_id_card returned %s"
                     .printf(force_flat_file_store.to_string(), id_card.display_name, (prev_id != null ? prev_id.display_name : "null")));
        if (prev_id!=null) {
            int flags = prev_id.Compare(id_card);
            logger.trace("add_identity: compare returned " + flags.to_string());
            if (flags == 0) {
                return false; // no changes, no need to update
            } else if ((flags & (1 << IdCard.DiffFlags.DISPLAY_NAME)) != 0) {
                dialog = new Gtk.MessageDialog(this,
                                               Gtk.DialogFlags.DESTROY_WITH_PARENT,
                                               Gtk.MessageType.QUESTION,
                                               Gtk.ButtonsType.YES_NO,
                                               _("Would you like to replace ID Card '%s' using nai '%s' with the new ID Card '%s'?"),
                                               prev_id.display_name,
                                               prev_id.nai,
                                               id_card.display_name);
            } else {
                dialog = new Gtk.MessageDialog(this,
                                               Gtk.DialogFlags.DESTROY_WITH_PARENT,
                                               Gtk.MessageType.QUESTION,
                                               Gtk.ButtonsType.YES_NO,
                                               _("Would you like to update ID Card '%s' using nai '%s'?"),
                                               id_card.display_name,
                                               id_card.nai);
            }
        } else {
            dialog = new Gtk.MessageDialog(this,
                                           Gtk.DialogFlags.DESTROY_WITH_PARENT,
                                           Gtk.MessageType.QUESTION,
                                           Gtk.ButtonsType.YES_NO,
                                           _("Would you like to add '%s' ID Card to the ID Card Organizer?"),
                                           id_card.display_name);
        }
        var ret = dialog.run();
        dialog.destroy();
        #endif

        if (ret == Gtk.ResponseType.YES) {
            this.identities_manager.add_card(id_card, force_flat_file_store);
            return true;
        }
        return false;
    }

    private void add_identity_cb()
    {
        var dialog = new IdentityDialog(this);
        int result = ResponseType.CANCEL;
        while (!dialog.complete)
            result = dialog.run();

        switch (result) {
        case ResponseType.OK:
            this.identities_manager.add_card(update_id_card_data(dialog, new IdCard()), false);
            break;
        default:
            break;
        }
        dialog.destroy();
    }

    private void edit_identity_cb(IdCard card)
    {
        var dialog = new IdentityDialog.with_idcard(card, _("Edit Identity"), this);
        int result = ResponseType.CANCEL;
        while (!dialog.complete)
            result = dialog.run();

        switch (result) {
        case ResponseType.OK:
            this.identities_manager.update_card(update_id_card_data(dialog, card));
            break;
        default:
            break;
        }
        dialog.destroy();
    }

    private void remove_identity(IdCardWidget id_card_widget)
    {
        var id_card = id_card_widget.id_card;
        this.custom_vbox.remove_id_card_widget(id_card_widget);

        this.identities_manager.remove_card(id_card);

        // Nothing is selected, so disable buttons
        this.edit_button.set_sensitive(false);
        this.remove_button.set_sensitive(false);
        this.send_button.set_sensitive(false);
    }

    private void redraw_id_card_widgets()
    {
        logger.trace("redraw_id_card_widgets");

        TreeIter iter;
        IdCard id_card;

        this.custom_vbox.clear();

        if (filter.get_iter_first(out iter))
        {
            do
            {
                filter.get(iter,
                           Columns.IDCARD_COL, out id_card);

                add_id_card_widget(id_card);
            }
            while (filter.iter_next(ref iter));
        }
    }

    private void remove_identity_cb(IdCardWidget id_card_widget)
    {
        var id_card = id_card_widget.id_card;

        bool remove = WarningDialog.confirm(this, 
                                            Markup.printf_escaped(
                                                "<span font-weight='heavy'>You are about to remove the identity '%s'.</span>",
                                                id_card.display_name)
                                            + "\n\nAre you sure you want to do this?",
                                            "delete_idcard");
        if (remove) 
            remove_identity(id_card_widget);
    }

    private void set_prompting_service(string service)
    {
        clear_selection_prompts();

        var prompting_service = new Label(_("Identity requested for service:\n%s").printf(service));
        prompting_service.set_line_wrap(true);

        // left-align
        prompting_service.set_alignment(0, (float )0.5);

        var selection_prompt = new Label(_("Select your identity:"));
        selection_prompt.set_alignment(0, 1);

        this.service_prompt_vbox.pack_start(prompting_service, false, false, 12);
        this.service_prompt_vbox.pack_start(selection_prompt, false, false, 2);
        this.service_prompt_vbox.show_all();
    }

    private void clear_selection_prompts()
    {
        var list = service_prompt_vbox.get_children();
        foreach (Widget w in list)
        {
            service_prompt_vbox.remove(w);
        }
    }


    public void queue_identity_request(IdentityRequest request)
    {
        if (!this.selection_in_progress())
        { /* setup widgets */
            candidates = request.candidates;
            filter.refilter();
            redraw_id_card_widgets();
            set_prompting_service(request.service);
            remember_identity_binding.show();
            make_visible();
        }
        this.request_queue.push_tail(request);
    }


    /** Makes the window visible, or at least, notifies the user that the window
     * wants to be visible.
     *
     * This differs from show() in that show() does not guarantee that the 
     * window will be moved to the foreground. Actually, neither does this
     * method, because the user's settings and window manager may affect the
     * behavior significantly.
     */
    public void make_visible()
    {
        set_urgency_hint(true);
        present();
    }

    public IdCard check_add_password(IdCard identity, IdentityRequest request, IdentityManagerModel model)
    {
        logger.trace(@"check_add_password");
        IdCard retval = identity;
        bool idcard_has_pw = (identity.password != null) && (identity.password != "");
        bool request_has_pw = (request.password != null) && (request.password != "");
        if ((!idcard_has_pw) && (!identity.is_no_identity())) {
            if (request_has_pw) {
                identity.password = request.password;
                retval = model.update_card(identity);
            } else {
                var dialog = new AddPasswordDialog(identity, request);
                var result = dialog.run();

                switch (result) {
                case ResponseType.OK:
                    identity.password = dialog.password;
                    identity.store_password = dialog.remember;
                    if (dialog.remember)
                        identity.temporary = false;
                    retval = model.update_card(identity);
                    break;
                default:
                    identity = null;
                    break;
                }
                dialog.destroy();
            }
        }
        return retval;
    }

    private void send_identity_cb(IdCard id)
    {
        return_if_fail(this.selection_in_progress());

        if (!check_and_confirm_trust_anchor(id)) {
            // Allow user to pick again
            return;
        }

        var request = this.request_queue.pop_head();
        var identity = check_add_password(id, request, identities_manager);
        send_button.set_sensitive(false);

        candidates = null;
      
        if (!this.selection_in_progress())
        {
            candidates = null;
            clear_selection_prompts();
            if (!parent_app.explicitly_launched) {
// The following occasionally causes the app to exit without sending the dbus
// reply, so for now we just don't exit
//                Gtk.main_quit();
// just hide instead
                this.hide();
            }
        } else {
            IdentityRequest next = this.request_queue.peek_head();
            candidates = next.candidates;
            set_prompting_service(next.service);
        }
        filter.refilter();
        redraw_id_card_widgets();

        if ((identity != null) && (!identity.is_no_identity()))
            parent_app.default_id_card = identity;

        request.return_identity(identity, remember_identity_binding.active);

        remember_identity_binding.active = false;
        remember_identity_binding.hide();
    }

    private bool check_and_confirm_trust_anchor(IdCard id)
    {
        if (!id.trust_anchor.is_empty() && id.trust_anchor.get_anchor_type() == TrustAnchor.TrustAnchorType.SERVER_CERT) {
            if (!id.trust_anchor.user_verified) {

                bool ret = false;
                int result = ResponseType.CANCEL;
                var dialog = new TrustAnchorDialog(id, this);
                while (!dialog.complete)
                    result = dialog.run();

                switch (result) {
                case ResponseType.OK:
                    id.trust_anchor.user_verified = true;
                    ret = true;
                    break;
                default:
                    break;
                }

                dialog.destroy();
                return ret;
            }
        }
        return true;
    }


    // private void label_make_bold(Label label)
    // {
    //     var font_desc = new Pango.FontDescription();

    //     font_desc.set_weight(Pango.Weight.BOLD);

    //     /* This will only affect the weight of the font, the rest is
    //      * from the current state of the widget, which comes from the
    //      * theme or user prefs, since the font desc only has the
    //      * weight flag turned on.
    //      */
    //     label.modify_font(font_desc);
    // }

    private void on_about_action()
    {
        string copyright = "Copyright (c) 2011, %d JANET".printf(LATEST_EDIT_YEAR);

        string license =
        """
Copyright (c) 2011, %d JANET(UK)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

3. Neither the name of JANET(UK) nor the names of its contributors
   may be used to endorse or promote products derived from this software
   without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
SUCH DAMAGE.
""".printf(LATEST_EDIT_YEAR);

        AboutDialog about = new AboutDialog();

        about.set_comments(_("Moonshot project UI"));
        about.set_copyright(copyright);
        about.set_website(Config.PACKAGE_URL);
        about.set_website_label(_("Visit the Moonshot project web site"));

        // Note: The package version is configured at the top of moonshot/ui/configure.ac
        about.set_version(Config.PACKAGE_VERSION);
        about.set_license(license);
        about.set_modal(true);
        about.set_transient_for(this);
        about.response.connect((a, b) => {about.destroy();});
        about.modify_bg(StateType.NORMAL, white);
        
        about.run();
    }

    private Gtk.ActionEntry[] create_actions() {
        Gtk.ActionEntry[] actions = new Gtk.ActionEntry[0];

        Gtk.ActionEntry helpmenu = { "HelpMenuAction",
                                     null,
                                     N_("_Help"),
                                     null, null, null };
        actions += helpmenu;
        Gtk.ActionEntry about = { "AboutAction",
                                  #if VALA_0_12
                                  Stock.ABOUT,
                                  #else
                                  STOCK_ABOUT,
                                  #endif
                                  N_("About"),
                                  null,
                                  N_("About this application"),
                                  on_about_action };
        actions += about;

        return actions;
    }


    private void create_ui_manager()
    {
        Gtk.ActionGroup action_group = new Gtk.ActionGroup("GeneralActionGroup");
        action_group.add_actions(create_actions(), this);
        ui_manager.insert_action_group(action_group, 0);
        try
        {
            ui_manager.add_ui_from_string(menu_layout, -1);
        }
        catch (Error e)
        {
            stderr.printf("%s\n", e.message);
            logger.error("create_ui_manager: Caught error: " + e.message);
        }
        ui_manager.ensure_update();
    }

    private void build_ui()
    {
        // Note: On Debian7/Gtk+2, the menu bar remains gray. This doesn't happen on Debian8/Gtk+3.
        this.modify_bg(StateType.NORMAL, white);

        create_ui_manager();

        this.search_entry = new Entry();

        set_atk_name_description(search_entry, _("Search entry"), _("Search for a specific ID Card"));
        this.search_entry.set_icon_from_pixbuf(EntryIconPosition.PRIMARY,
                                               find_icon_sized("edit-find", Gtk.IconSize.MENU));
        this.search_entry.set_icon_tooltip_text(EntryIconPosition.PRIMARY,
                                                _("Search for an identity or service"));
        this.search_entry.set_icon_sensitive(EntryIconPosition.PRIMARY, false);

        this.search_entry.set_icon_from_pixbuf(EntryIconPosition.SECONDARY,
                                               find_icon_sized("process-stop", Gtk.IconSize.MENU));
        this.search_entry.set_icon_tooltip_text(EntryIconPosition.SECONDARY,
                                                _("Clear the current search"));
        this.search_entry.set_icon_sensitive(EntryIconPosition.SECONDARY, false);


        this.search_entry.icon_press.connect(search_entry_icon_press_cb);
        this.search_entry.notify["text"].connect(search_entry_text_changed_cb);
        this.search_entry.key_press_event.connect(search_entry_key_press_event_cb);
        this.search_entry.set_width_chars(30);


        this.custom_vbox = new CustomVBox(this, false, 2);

        var viewport = new Viewport(null, null);
        viewport.set_border_width(2);
        viewport.set_shadow_type(ShadowType.NONE);
        viewport.add(custom_vbox);
        var id_scrollwin = new ScrolledWindow(null, null);
        id_scrollwin.set_policy(PolicyType.NEVER, PolicyType.AUTOMATIC);
        id_scrollwin.set_shadow_type(ShadowType.IN);
        id_scrollwin.add_with_viewport(viewport);

        service_prompt_vbox = new VBox(false, 0);

        var vbox_left = new VBox(false, 0);
        vbox_left.pack_start(service_prompt_vbox, false, false, 12);

        var search_hbox = new HBox(false, 6);
        search_hbox.pack_end(search_entry, false, false, 0);
        //// var search_label = new Label(_("Search:"));
        //// search_label.set_alignment(1, (float) 0.5);
        //// set_atk_relation(search_label, search_entry, Atk.RelationType.LABEL_FOR);
        //// search_hbox.pack_end(search_label, false, false, 6);

        var full_search_label = new Label(_("Search for an identity or service"));
        full_search_label.set_alignment(1, 0);
        var search_vbox = new VBox(false, 4);
        search_vbox.pack_start(full_search_label, false, false, 0);
        search_vbox.pack_start(search_hbox, false, false, 0);

        var inner_left_vbox = new VBox(false, 6);
        inner_left_vbox.pack_start(search_vbox, false, false, 6);
//        inner_left_vbox.pack_start(selection_prompt, false, false, 6);
        inner_left_vbox.pack_start(id_scrollwin, true, true, 0);

        var id_and_button_box = new HBox(false, 6);
        id_and_button_box.pack_start(inner_left_vbox, true, true, 6);
        vbox_left.pack_start(id_and_button_box, true, true, 0);
        // vbox_left.pack_start(prompting_service, false, false, 6);
        vbox_left.set_size_request(WINDOW_WIDTH, 0);

        this.no_identity_title = new Label(_("No Identity: Send this identity to services which should not use Moonshot"));
        no_identity_title.set_alignment(0, (float ) 0.5);
        no_identity_title.set_line_wrap(true);
        no_identity_title.show();

        this.vbox_right = new VBox(false, 6);

        var add_button = new Button.with_label(_("Add"));
        add_button.clicked.connect((w) => {add_identity_cb();});

        this.edit_button = new Button.with_label(_("Edit"));
        edit_button.clicked.connect((w) => {edit_identity_cb(custom_vbox.current_idcard.id_card);});
        edit_button.set_sensitive(false);

        this.remove_button = new Button.with_label(_("Remove"));
        remove_button.clicked.connect((w) => {remove_identity_cb(custom_vbox.current_idcard);});
        remove_button.set_sensitive(false);

        this.send_button = new Button.with_label(_("Send"));
        send_button.clicked.connect((w) => {send_identity_cb(custom_vbox.current_idcard.id_card);});
        // send_button.set_visible(false);
        send_button.set_sensitive(false);

        var empty_box = new VBox(false, 0);
        empty_box.set_size_request(0, 0);
        vbox_right.pack_start(empty_box, false, false, 14);
        vbox_right.pack_start(add_button, false, false, 6);
        vbox_right.pack_start(edit_button, false, false, 6);
        vbox_right.pack_start(remove_button, false, false, 6);
        vbox_right.pack_start(send_button, false, false, 24);

        id_and_button_box.pack_start(vbox_right, false, false, 0);

        var main_vbox = new VBox(false, 0);

        // Note: This places a border above the menubar. Is that what we want?
        main_vbox.set_border_width(12);

#if OS_MACOS
        // hide the  File | Quit menu item which is now on the Mac Menu
//        Gtk.Widget quit_item =  this.ui_manager.get_widget("/MenuBar/FileMenu/Quit");
//        quit_item.hide();
        
        Gtk.MenuShell menushell = this.ui_manager.get_widget("/MenuBar") as Gtk.MenuShell;
        menushell.modify_bg(StateType.NORMAL, white);

        osxApp.set_menu_bar(menushell);
        osxApp.set_use_quartz_accelerators(true);
        osxApp.sync_menu_bar();
        osxApp.ready();
#else
        var menubar = this.ui_manager.get_widget("/MenuBar");
        main_vbox.pack_start(menubar, false, false, 0);
        menubar.modify_bg(StateType.NORMAL, white);
#endif
        main_vbox.pack_start(vbox_left, true, true, 0);

        remember_identity_binding = new CheckButton.with_label(_("Remember my identity choice for this service"));
        remember_identity_binding.active = false;
        main_vbox.pack_start(remember_identity_binding, false, false, 6);

        add(main_vbox);
        main_vbox.show_all();

        if (!this.selection_in_progress())
            remember_identity_binding.hide();
    } 

    internal bool selection_in_progress() {
        return !this.request_queue.is_empty();
    }

    private void set_atk_name_description(Widget widget, string name, string description)
    {
        var atk_widget = widget.get_accessible();

        atk_widget.set_name(name);
        atk_widget.set_description(description);
    }

    private void connect_signals()
    {
        this.destroy.connect(() => {
                logger.trace("Destroy event; calling Gtk.main_quit()");
                Gtk.main_quit();
            });
        this.identities_manager.card_list_changed.connect(this.on_card_list_changed);
        this.delete_event.connect(() => {return confirm_quit();});
    }

    private bool confirm_quit() {
        logger.trace("delete_event intercepted; selection_in_progress()=" + selection_in_progress().to_string());

        if (selection_in_progress()) {
            var result = WarningDialog.confirm(this,
                                               Markup.printf_escaped(
                                                   _("<span font-weight='heavy'>Do you wish to use the %s service?</span>"),
                                                   this.request_queue.peek_head().service)
                                               + _("\n\nSelect Yes to select an ID for this service, or No to cancel"),
                                               "close_moonshot_window");
            if (result) {
                // Prevent other handlers from handling this event; this keeps the window open.
                return true; 
            }
        }

        // Allow the window deletion to proceed.
        return false;
    }
}
