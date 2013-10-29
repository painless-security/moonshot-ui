#if OS_WIN32
extern string? g_win32_get_package_installation_directory_of_module (void *module);
#endif

public Gdk.Pixbuf? find_icon_sized (string name, Gtk.IconSize icon_size)
{
    int width, height;
    Gtk.icon_size_lookup (icon_size, out width, out height);
    return find_icon (name, width);
}

/* Portability hack: making Gtk icon themes work on Windows is
 * difficult; let's just bundle the icons that are necessary and
 * load them manually.
 */

public bool gtk_available = false;

public Gdk.Pixbuf? get_pixbuf(IdCard id)
{
    return find_icon("avatar-default", 48);
}

public Gdk.Pixbuf? find_icon (string name, int size)
{
    if (!gtk_available)
        return null;
    try
    {
#if OS_WIN32
        string? base_path = g_win32_get_package_installation_directory_of_module (null);

        // Hack to allow running within the source tree
        int last_dir_index = base_path.last_index_of_char ('\\');
        if (base_path.substring (last_dir_index) == "\\.libs" || base_path.substring (last_dir_index) == "src")
            base_path = base_path.slice(0, last_dir_index);

        string? filename = Path.build_filename (base_path, "share", "icons", "%s.png".printf (name));
        return new Gdk.Pixbuf.from_file_at_size (filename, size, size);

#else
        var icon_theme = Gtk.IconTheme.get_default ();
        return icon_theme.load_icon (name, size, Gtk.IconLookupFlags.FORCE_SIZE);
#endif
    }
    catch (Error e)
    {
        stdout.printf("Error loading icon '%s': %s\n", name, e.message);
        return null;
    }
}

public extern unowned string GetUserName();
public extern unowned string GetFlatStoreUsersFilePath();

public bool UserForcesFlatFileStore()
{
    string username = GetUserName();
    string flatstore_users_filename = GetFlatStoreUsersFilePath();
    FileStream flatstore_users = FileStream.open(flatstore_users_filename, "r");
    if (flatstore_users == null) {
        return false;
    }
    string? flatstore_username = null;
    while ((flatstore_username = flatstore_users.read_line()) != null) {
        if (username == flatstore_username) {
            return true;
        }
    }
    return false;
}
