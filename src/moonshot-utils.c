/* moonshot-utils.c generated by valac 0.16.1, the Vala compiler
 * generated from moonshot-utils.vala, do not modify */


#include <glib.h>
#include <glib-object.h>
#include <stdlib.h>
#include <string.h>
#include <gtk/gtk.h>
#include <gdk-pixbuf/gdk-pixbuf.h>
#include <stdio.h>

#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))
#define _g_error_free0(var) ((var == NULL) ? NULL : (var = (g_error_free (var), NULL)))



GdkPixbuf* find_icon_sized (const gchar* name, GtkIconSize icon_size);
GdkPixbuf* find_icon (const gchar* name, gint size);


GdkPixbuf* find_icon_sized (const gchar* name, GtkIconSize icon_size) {
	GdkPixbuf* result = NULL;
	gint width = 0;
	gint height = 0;
	GtkIconSize _tmp0_;
	gint _tmp1_ = 0;
	gint _tmp2_ = 0;
	const gchar* _tmp3_;
	GdkPixbuf* _tmp4_ = NULL;
#line 5 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
	g_return_val_if_fail (name != NULL, NULL);
#line 8 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
	_tmp0_ = icon_size;
#line 8 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
	gtk_icon_size_lookup (_tmp0_, &_tmp1_, &_tmp2_);
#line 8 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
	width = _tmp1_;
#line 8 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
	height = _tmp2_;
#line 9 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
	_tmp3_ = name;
#line 9 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
	_tmp4_ = find_icon (_tmp3_, width);
#line 9 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
	result = _tmp4_;
#line 9 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
	return result;
#line 50 "moonshot-utils.c"
}


static gpointer _g_object_ref0 (gpointer self) {
#line 33 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
	return self ? g_object_ref (self) : NULL;
#line 57 "moonshot-utils.c"
}


GdkPixbuf* find_icon (const gchar* name, gint size) {
	GdkPixbuf* result = NULL;
	GError * _inner_error_ = NULL;
#line 17 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
	g_return_val_if_fail (name != NULL, NULL);
#line 66 "moonshot-utils.c"
	{
		GtkIconTheme* _tmp0_ = NULL;
		GtkIconTheme* _tmp1_;
		GtkIconTheme* icon_theme;
		const gchar* _tmp2_;
		gint _tmp3_;
		GdkPixbuf* _tmp4_ = NULL;
		GdkPixbuf* _tmp5_;
#line 33 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
		_tmp0_ = gtk_icon_theme_get_default ();
#line 33 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
		_tmp1_ = _g_object_ref0 (_tmp0_);
#line 33 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
		icon_theme = _tmp1_;
#line 34 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
		_tmp2_ = name;
#line 34 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
		_tmp3_ = size;
#line 34 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
		_tmp4_ = gtk_icon_theme_load_icon (icon_theme, _tmp2_, _tmp3_, GTK_ICON_LOOKUP_FORCE_SIZE, &_inner_error_);
#line 34 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
		_tmp5_ = _tmp4_;
#line 34 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
		if (_inner_error_ != NULL) {
#line 34 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
			_g_object_unref0 (icon_theme);
#line 93 "moonshot-utils.c"
			goto __catch7_g_error;
		}
#line 34 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
		result = _tmp5_;
#line 34 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
		_g_object_unref0 (icon_theme);
#line 34 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
		return result;
#line 102 "moonshot-utils.c"
	}
	goto __finally7;
	__catch7_g_error:
	{
		GError* e = NULL;
		FILE* _tmp6_;
		const gchar* _tmp7_;
		GError* _tmp8_;
		const gchar* _tmp9_;
#line 19 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
		e = _inner_error_;
#line 19 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
		_inner_error_ = NULL;
#line 39 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
		_tmp6_ = stdout;
#line 39 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
		_tmp7_ = name;
#line 39 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
		_tmp8_ = e;
#line 39 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
		_tmp9_ = _tmp8_->message;
#line 39 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
		fprintf (_tmp6_, "Error loading icon '%s': %s\n", _tmp7_, _tmp9_);
#line 40 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
		result = NULL;
#line 40 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
		_g_error_free0 (e);
#line 40 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
		return result;
#line 132 "moonshot-utils.c"
	}
	__finally7:
#line 19 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
	g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
#line 19 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
	g_clear_error (&_inner_error_);
#line 19 "/build/slave/submodule_amd64/build/ui/src/moonshot-utils.vala"
	return NULL;
#line 141 "moonshot-utils.c"
}



