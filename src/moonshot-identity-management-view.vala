/*
 * Copyright (c) 2011-2014, JANET(UK)
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

    private const int WINDOW_WIDTH = 400;
    private const int WINDOW_HEIGHT = 500;
    protected IdentityManagerApp parent_app;
    #if OS_MACOS
        public OSXApplication osxApp;
    #endif
    private UIManager ui_manager = new UIManager();
    private Entry search_entry;
    private VBox vbox_right;
    private VBox login_vbox;
    private VBox services_vbox;
    private CustomVBox custom_vbox;
    private VBox services_internal_vbox;
    private ScrolledWindow services_vscroll;
    private Entry issuer_entry;
    private Entry username_entry;
    private Entry password_entry;
    private Label prompting_service;
    private Label no_identity_title;
    private CheckButton remember_checkbutton;
    private Button update_password_button;

    private Gtk.ListStore* listmodel;
    private TreeModelFilter filter;

    public IdentityManagerModel identities_manager;
    private unowned SList<IdCard>    candidates;

    public GLib.Queue<IdentityRequest> request_queue;

    private HashTable<Gtk.Button, string> service_button_map;

    private enum Columns
    {
        IDCARD_COL,
        LOGO_COL,
        ISSUER_COL,
        USERNAME_COL,
        PASSWORD_COL,
        N_COLUMNS
    }

    private const string layout =
    "<menubar name='MenuBar'>" +
    "        <menu name='FileMenu' action='FileMenuAction'>" +
    "            <menuitem name='AddIdCard' action='AddIdCardAction' />" +
    "            <separator />" +
    "            <menuitem name='Quit' action='QuitAction' />" +
    "        </menu>" +
    "" +
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
        service_button_map = new HashTable<Gtk.Button, string>(direct_hash, direct_equal);
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
            
            if (id_card.services.length > 0)
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

        this.vbox_right.set_visible(false);
    }

    private bool search_entry_key_press_event_cb(Gdk.EventKey e)
    {
        if(Gdk.keyval_name(e.keyval) == "Escape")
            this.search_entry.set_text("");

        // Continue processing this event, since the
        // text entry functionality needs to see it too.
        return false;
    }

    private void update_password_cb()
    {
        if (this.custom_vbox.current_idcard != null) {
            var identity = this.custom_vbox.current_idcard.id_card;
            var dialog = new AddPasswordDialog(identity, null);
            var result = dialog.run();

            switch (result) {
            case ResponseType.OK:
                identity.password = dialog.password;
                identity.store_password = dialog.remember;
                if (dialog.remember)
                    identity.temporary = false;
                identity = identities_manager.update_card(identity);
                break;
            default:
                break;
            }
            dialog.destroy();
        }
    }

    private void load_id_cards() {
        string current_idcard_nai = null;
        if (this.custom_vbox.current_idcard != null) {
            current_idcard_nai = custom_vbox.current_idcard.id_card.nai;
            custom_vbox.current_idcard = null;
        }
        var children = this.custom_vbox.get_children();
        foreach (var id_card_widget in children) {
            remove_id_card_widget((IdCardWidget)id_card_widget);
        }   
        this.listmodel->clear();
        LinkedList<IdCard> card_list = identities_manager.get_card_list() ;
        if (card_list == null) {
            return;
        }

        foreach (IdCard id_card in card_list) {
            add_id_card_data(id_card);
            IdCardWidget id_card_widget = add_id_card_widget(id_card);
            if (id_card_widget.id_card.nai == current_idcard_nai) {
                fill_details(id_card_widget.id_card);
                id_card_widget.expand();
            }
        }
    }
    
    private void fill_details(IdCard id_card)
    {
        logger.trace("fill_details: id_card=%s".printf(id_card == null ? "null" : "non-null"));

        if (id_card != null) {
            if (id_card.display_name == IdCard.NO_IDENTITY) {
                logger.trace("fill_details: Displaying title for NO_IDENTITY");
                login_vbox.hide();
                no_identity_title.show_all();
            } else {
                logger.trace("fill_details: Displaying details for selected card");
                this.issuer_entry.set_text(id_card.issuer);
                this.username_entry.set_text(id_card.username);
                this.password_entry.set_text(id_card.password ?? "");
                this.remember_checkbutton.active = id_card.store_password;
                no_identity_title.hide();
                login_vbox.show_all();              
            }

            fill_services_vbox(id_card);
        }
    }

    private void show_details(IdCard id_card)
    {
        this.vbox_right.set_visible(!vbox_right.get_visible());

        if (this.vbox_right.get_visible() == false)
        {
            this.resize(WINDOW_WIDTH, WINDOW_HEIGHT);
        }
    }

    private void details_identity_cb(IdCardWidget id_card_widget)
    {
        fill_details(id_card_widget.id_card);
        show_details(id_card_widget.id_card);
    }

    private IdCard get_id_card_data(AddIdentityDialog dialog)
    {
        var id_card = new IdCard();

        id_card.display_name = dialog.display_name;
        id_card.issuer = dialog.issuer;
        id_card.username = dialog.username;
        id_card.password = dialog.password;
        id_card.store_password = dialog.store_password;
        id_card.services = {};

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
        var id_card_widget = new IdCardWidget(id_card);
        this.custom_vbox.add_id_card_widget(id_card_widget);
        id_card_widget.details_id.connect(details_identity_cb);
        id_card_widget.remove_id.connect(remove_identity_cb);
        id_card_widget.send_id.connect((w) => send_identity_cb(w.id_card));
        id_card_widget.expanded.connect(this.custom_vbox.receive_expanded_event);
        id_card_widget.expanded.connect((w) => fill_details(w.id_card));
        return id_card_widget;
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
        if (prev_id!=null) {
            int flags = prev_id.Compare(id_card);
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

    private void add_identity_manual_cb()
    {
        var dialog = new AddIdentityDialog();
        int result = ResponseType.CANCEL;
        while (!dialog.complete)
            result = dialog.run();

        switch (result) {
        case ResponseType.OK:
            this.identities_manager.add_card(get_id_card_data(dialog), false);
            break;
        default:
            break;
        }
        dialog.destroy();
    }

    private void remove_id_card_widget(IdCardWidget id_card_widget) {
        this.custom_vbox.remove_id_card_widget(id_card_widget);
    }

    private void remove_identity(IdCardWidget id_card_widget)
    {
        var id_card = id_card_widget.id_card;
        remove_id_card_widget(id_card_widget);

        this.identities_manager.remove_card(id_card);
    }

    private void redraw_id_card_widgets()
    {
        TreeIter iter;
        IdCard id_card;

        var children = this.custom_vbox.get_children();
        foreach (var id_card_widget in children) {
            remove_id_card_widget((IdCardWidget )id_card_widget); //id_card_widget.destroy();
        }

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

        var dialog = new MessageDialog(this,
                                       DialogFlags.DESTROY_WITH_PARENT,
                                       MessageType.QUESTION,
                                       Gtk.ButtonsType.YES_NO,
                                       _("Are you sure you want to delete %s ID Card?"), id_card.issuer);
        var result = dialog.run();
        switch (result) {
        case ResponseType.YES:
            remove_identity(id_card_widget);
            break;
        default:
            break;
        }
        dialog.destroy();
    }

    public void set_prompting_service(string service)
    {
        prompting_service.set_label( _("Identity requested for service: %s").printf(service) );
    }

    public void queue_identity_request(IdentityRequest request)
    {
        if (this.request_queue.is_empty())
        { /* setup widgets */
            candidates = request.candidates;
            filter.refilter();
            redraw_id_card_widgets();
            set_prompting_service(request.service);
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
        IdCard retval = identity;
        bool idcard_has_pw = (identity.password != null) && (identity.password != "");
        bool request_has_pw = (request.password != null) && (request.password != "");
        if ((!idcard_has_pw) && (!identity.IsNoIdentity())) {
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

    public void send_identity_cb(IdCard id)
    {
        IdCard identity = id;
        return_if_fail(request_queue.length > 0);

        candidates = null;
        var request = this.request_queue.pop_head();
        identity = check_add_password(identity, request, identities_manager);
        if (this.request_queue.is_empty())
        {
            candidates = null;
            prompting_service.set_label(_(""));
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

        if ((identity != null) && (!identity.IsNoIdentity()))
            parent_app.default_id_card = identity;

        request.return_identity(identity);
    }

    private void label_make_bold(Label label)
    {
        var font_desc = new Pango.FontDescription();

        font_desc.set_weight(Pango.Weight.BOLD);

        /* This will only affect the weight of the font, the rest is
         * from the current state of the widget, which comes from the
         * theme or user prefs, since the font desc only has the
         * weight flag turned on.
         */
        label.modify_font(font_desc);
    }

    private void fill_services_vbox(IdCard id_card)
    {
        logger.trace("fill_services_vbox");

        var children = this.services_internal_vbox.get_children();
        foreach (var widget in children) {
            services_internal_vbox.remove(widget);
        }

        int i = 0;
        var n_rows = id_card.services.length;

        var services_table = new Table(n_rows, 2, false);
        services_table.set_col_spacings(10);
        services_table.set_row_spacings(10);
        this.services_internal_vbox.pack_start(services_table, true, false, 0);
        
        service_button_map.remove_all();

        foreach (string service in id_card.services)
        {
            var label = new Label(service);
            label.set_alignment(0, (float) 0.5);
#if VALA_0_12
            var remove_button = new Button.from_stock(Stock.REMOVE);
#else
            var remove_button = new Button.from_stock(STOCK_REMOVE);
#endif


            service_button_map.insert(remove_button, service);
            
            remove_button.clicked.connect((remove_button) =>
                {
                    var candidate = service_button_map.lookup(remove_button);
                    if (candidate == null)
                        return;
                    var dialog = new Gtk.MessageDialog(this,
                                                       Gtk.DialogFlags.DESTROY_WITH_PARENT,
                                                       Gtk.MessageType.QUESTION,
                                                       Gtk.ButtonsType.YES_NO,
                                                       _("Are you sure you want to stop '%s' ID Card from being used with %s?"),
                                                       custom_vbox.current_idcard.id_card.display_name,
                                                       candidate);
                    var ret = dialog.run();
                    dialog.hide();
              
                    if (ret == Gtk.ResponseType.YES)
                    {
                        IdCard idcard = custom_vbox.current_idcard.id_card;
                        if (idcard != null) {
                            SList<string> services = new SList<string>();
                
                            foreach (string srv in idcard.services)
                            {
                                if (srv == candidate)
                                    continue;
                                services.append(srv);
                            }
                
                            idcard.services = new string[services.length()];
                            for (int j = 0; j < idcard.services.length; j++)
                            {
                                idcard.services[j] = services.nth_data(j);
                            }
                
                            identities_manager.update_card(idcard);
                        }
                    }
              
                });
            services_table.attach_defaults(label, 0, 1, i, i+1);
            services_table.attach_defaults(remove_button, 1, 2, i, i+1);
            i++;
        }

        services_vbox.show_all();
    }

    private void on_about_action()
    {
        string[] authors = {
            "Javier Jardón <jjardon@codethink.co.uk>",
            "Sam Thursfield <samthursfield@codethink.co.uk>",
            "Alberto Ruiz <alberto.ruiz@codethink.co.uk>",
            null
        };

        string copyright = "Copyright 2011 JANET";

        string license =
        """
Copyright (c) 2011, JANET(UK)
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
""";

        Gtk.show_about_dialog(this,
                              "comments", _("Moonshot project UI"),
                              "copyright", copyright,
                              "website", Config.PACKAGE_URL,
                              "version", Config.PACKAGE_VERSION,
                              "license", license,
                              "website-label", _("Visit the Moonshot project web site"),
                              "authors", authors,
                              "translator-credits", _("translator-credits"),
                              null
            );
    }

    private Gtk.ActionEntry[] create_actions() {
        Gtk.ActionEntry[] actions = new Gtk.ActionEntry[0];

        Gtk.ActionEntry filemenu = { "FileMenuAction",
                                     null,
                                     N_("_File"),
                                     null, null, null };
        actions += filemenu;
        Gtk.ActionEntry add = { "AddIdCardAction",
                                #if VALA_0_12
                                Stock.ADD,
                                #else
                                STOCK_ADD,
                                #endif
                                N_("Add ID Card"),
                                null,
                                N_("Add a new ID Card"),
                                add_identity_manual_cb };
        actions += add;
        Gtk.ActionEntry quit = { "QuitAction",
                                 #if VALA_0_12
                                 Stock.QUIT,
                                 #else
                                 STOCK_QUIT,
                                 #endif
                                 N_("Quit"),
                                 "<control>Q",
                                 N_("Quit the application"),
                                 Gtk.main_quit };
        actions += quit;

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
            ui_manager.add_ui_from_string(layout, -1);
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
        create_ui_manager();

        this.search_entry = new Entry();

        set_atk_name_description(search_entry, _("Search entry"), _("Search for a specific ID Card"));
        this.search_entry.set_icon_from_pixbuf(EntryIconPosition.PRIMARY,
                                               find_icon_sized("edit-find", Gtk.IconSize.MENU));
//                                                find_icon_sized("edit-find-symbolic", Gtk.IconSize.MENU));
        this.search_entry.set_icon_tooltip_text(EntryIconPosition.PRIMARY,
                                                _("Search identity or service"));
        this.search_entry.set_icon_sensitive(EntryIconPosition.PRIMARY, false);

        this.search_entry.set_icon_from_pixbuf(EntryIconPosition.SECONDARY,
                                               find_icon_sized("process-stop", Gtk.IconSize.MENU));
//                                                find_icon_sized("edit-clear-symbolic", Gtk.IconSize.MENU));
        this.search_entry.set_icon_tooltip_text(EntryIconPosition.SECONDARY,
                                                _("Clear the current search"));
        this.search_entry.set_icon_sensitive(EntryIconPosition.SECONDARY, false);


        this.search_entry.icon_press.connect(search_entry_icon_press_cb);
        this.search_entry.notify["text"].connect(search_entry_text_changed_cb);
        this.search_entry.key_press_event.connect(search_entry_key_press_event_cb);

        this.custom_vbox = new CustomVBox(this, false, 6);

        var viewport = new Viewport(null, null);
        viewport.set_border_width(6);
        viewport.set_shadow_type(ShadowType.NONE);
        viewport.add(custom_vbox);
        var id_scrollwin = new ScrolledWindow(null, null);
        id_scrollwin.set_policy(PolicyType.NEVER, PolicyType.AUTOMATIC);
        id_scrollwin.set_shadow_type(ShadowType.IN);
        id_scrollwin.add_with_viewport(viewport);
        this.prompting_service = new Label(_(""));
        // left-align
        prompting_service.set_alignment(0, (float )0.5);

        var vbox_left = new VBox(false, 0);
        vbox_left.pack_start(search_entry, false, false, 6);
        vbox_left.pack_start(id_scrollwin, true, true, 0);
        vbox_left.pack_start(prompting_service, false, false, 6);
        vbox_left.set_size_request(WINDOW_WIDTH, 0);

        this.no_identity_title = new Label(_("No Identity: Send this identity to services which should not use Moonshot"));
        no_identity_title.set_alignment(0, (float ) 0.5);
        no_identity_title.set_line_wrap(true);
        no_identity_title.show();

        var login_vbox_title = new Label(_("Login: "));
        label_make_bold(login_vbox_title);
        login_vbox_title.set_alignment(0, (float) 0.5);
        var issuer_label = new Label(_("Issuer:"));
        issuer_label.set_alignment(1, (float) 0.5);
        this.issuer_entry = new Entry();
        issuer_entry.set_can_focus(false);
        var username_label = new Label(_("Username:"));
        username_label.set_alignment(1, (float) 0.5);
        this.username_entry = new Entry();
        username_entry.set_can_focus(false);
        var password_label = new Label(_("Password:"));
        password_label.set_alignment(1, (float) 0.5);
        this.password_entry = new Entry();
        password_entry.set_invisible_char('*');
        password_entry.set_visibility(false);
        password_entry.set_sensitive(false);
        this.remember_checkbutton = new CheckButton.with_label(_("Remember password"));
        remember_checkbutton.set_sensitive(false);
        this.update_password_button = new Button.with_label(_("Update Password"));
        this.update_password_button.clicked.connect(update_password_cb);

        set_atk_relation(issuer_label, issuer_entry, Atk.RelationType.LABEL_FOR);
        set_atk_relation(username_label, username_entry, Atk.RelationType.LABEL_FOR);
        set_atk_relation(password_entry, password_entry, Atk.RelationType.LABEL_FOR);

        // Create the login_vbox. This starts off hidden, because the first card we
        // display, by default, is NO_IDENTITY.
        var login_table = new Table(5, 2, false);
        login_table.set_col_spacings(10);
        login_table.set_row_spacings(10);
        login_table.attach_defaults(issuer_label, 0, 1, 0, 1);
        login_table.attach_defaults(issuer_entry, 1, 2, 0, 1);
        login_table.attach_defaults(username_label, 0, 1, 1, 2);
        login_table.attach_defaults(username_entry, 1, 2, 1, 2);
        login_table.attach_defaults(password_label, 0, 1, 2, 3);
        login_table.attach_defaults(password_entry, 1, 2, 2, 3);
        login_table.attach_defaults(remember_checkbutton,  1, 2, 3, 4);
        login_table.attach_defaults(update_password_button, 0, 1, 4, 5);
        var login_vbox_alignment = new Alignment(0, 0, 0, 0);
        login_vbox_alignment.set_padding(0, 0, 12, 0);
        login_vbox_alignment.add(login_table);
        this.login_vbox = new VBox(false, 6);
        login_vbox.pack_start(login_vbox_title, false, true, 0);
        login_vbox.pack_start(login_vbox_alignment, false, true, 0);
        login_vbox.hide();

        var services_vbox_title = new Label(_("Services:"));
        label_make_bold(services_vbox_title);
        services_vbox_title.set_alignment(0, (float) 0.5);
        
        this.services_internal_vbox = new VBox(true, 6);

        var services_vbox_alignment = new Alignment(0, 0, 0, 1);
        services_vbox_alignment.set_padding(6, 6, 6, 6);
        services_vbox_alignment.add(services_internal_vbox);
        services_vscroll = new ScrolledWindow(null, null);
        services_vscroll.set_policy(PolicyType.NEVER, PolicyType.AUTOMATIC);
        services_vscroll.set_shadow_type(ShadowType.IN);
        services_vscroll.add_with_viewport(services_vbox_alignment);

        services_vbox = new VBox(false, 6);
        this.vbox_right = new VBox(false, 18);
        services_vbox.pack_start(services_vbox_title, false, false, 0);
        services_vbox.pack_start(services_vscroll, true, true, 0);

        vbox_right.pack_start(no_identity_title, true, false, 0);
        vbox_right.pack_start(login_vbox, false, false, 0);
        vbox_right.pack_start(services_vbox, true, true, 0);

        var hbox = new HBox(false, 12);
        hbox.pack_start(vbox_left, false, false, 0);
        hbox.pack_start(vbox_right, true, true, 0);

        var main_vbox = new VBox(false, 0);
        main_vbox.set_border_width(12);

        #if OS_MACOS
        // hide the  File | Quit menu item which is now on the Mac Menu
        Gtk.Widget quit_item =  this.ui_manager.get_widget("/MenuBar/FileMenu/Quit");
        quit_item.hide();
        
        Gtk.MenuShell menushell = this.ui_manager.get_widget("/MenuBar") as Gtk.MenuShell;
        osxApp.set_menu_bar(menushell);
        osxApp.set_use_quartz_accelerators(true);
        osxApp.sync_menu_bar();
        osxApp.ready(); 
#else
        var menubar = this.ui_manager.get_widget("/MenuBar");
        main_vbox.pack_start(menubar, false, false, 0);
#endif
        main_vbox.pack_start(hbox, true, true, 0);
        add(main_vbox);
        main_vbox.show_all();
        this.vbox_right.hide();
    } 

    private void set_atk_name_description(Widget widget, string name, string description)
    {
        var atk_widget = widget.get_accessible();

        atk_widget.set_name(name);
        atk_widget.set_description(description);
    }

    private void connect_signals()
    {
        this.destroy.connect(Gtk.main_quit);
        this.identities_manager.card_list_changed.connect(this.on_card_list_changed);
    }

    private static void set_atk_relation(Widget widget, Widget target_widget, Atk.RelationType relationship)
    {
        var atk_widget = widget.get_accessible();
        var atk_target_widget = target_widget.get_accessible();

        atk_widget.add_relationship(relationship, atk_target_widget);
    }
}
