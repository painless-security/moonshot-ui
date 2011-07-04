/* moonshot-server.c generated by valac 0.10.4, the Vala compiler
 * generated from moonshot-server.vala, do not modify */


#include <glib.h>
#include <glib-object.h>
#include <gtk/gtk.h>
#include <gio/gio.h>
#include <stdlib.h>
#include <string.h>
#include <dbus/dbus.h>
#include <dbus/dbus-glib.h>
#include <dbus/dbus-glib-lowlevel.h>


#define TYPE_MOONSHOT_SERVER (moonshot_server_get_type ())
#define MOONSHOT_SERVER(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_MOONSHOT_SERVER, MoonshotServer))
#define MOONSHOT_SERVER_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_MOONSHOT_SERVER, MoonshotServerClass))
#define IS_MOONSHOT_SERVER(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_MOONSHOT_SERVER))
#define IS_MOONSHOT_SERVER_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_MOONSHOT_SERVER))
#define MOONSHOT_SERVER_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_MOONSHOT_SERVER, MoonshotServerClass))

typedef struct _MoonshotServer MoonshotServer;
typedef struct _MoonshotServerClass MoonshotServerClass;
typedef struct _MoonshotServerPrivate MoonshotServerPrivate;

#define TYPE_MAIN_WINDOW (main_window_get_type ())
#define MAIN_WINDOW(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_MAIN_WINDOW, MainWindow))
#define MAIN_WINDOW_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_MAIN_WINDOW, MainWindowClass))
#define IS_MAIN_WINDOW(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_MAIN_WINDOW))
#define IS_MAIN_WINDOW_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_MAIN_WINDOW))
#define MAIN_WINDOW_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_MAIN_WINDOW, MainWindowClass))

typedef struct _MainWindow MainWindow;
typedef struct _MainWindowClass MainWindowClass;
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))
#define _g_free0(var) (var = (g_free (var), NULL))

#define TYPE_IDENTITY_REQUEST (identity_request_get_type ())
#define IDENTITY_REQUEST(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_IDENTITY_REQUEST, IdentityRequest))
#define IDENTITY_REQUEST_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_IDENTITY_REQUEST, IdentityRequestClass))
#define IS_IDENTITY_REQUEST(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_IDENTITY_REQUEST))
#define IS_IDENTITY_REQUEST_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_IDENTITY_REQUEST))
#define IDENTITY_REQUEST_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_IDENTITY_REQUEST, IdentityRequestClass))

typedef struct _IdentityRequest IdentityRequest;
typedef struct _IdentityRequestClass IdentityRequestClass;
typedef struct _IdentityRequestPrivate IdentityRequestPrivate;

#define TYPE_ID_CARD (id_card_get_type ())
#define ID_CARD(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_ID_CARD, IdCard))
#define ID_CARD_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_ID_CARD, IdCardClass))
#define IS_ID_CARD(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_ID_CARD))
#define IS_ID_CARD_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_ID_CARD))
#define ID_CARD_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_ID_CARD, IdCardClass))

typedef struct _IdCard IdCard;
typedef struct _IdCardClass IdCardClass;
typedef struct _Block2Data Block2Data;
typedef struct _MoonshotServerGetIdentityData MoonshotServerGetIdentityData;
typedef struct _Block3Data Block3Data;
typedef struct _MoonshotServerGetDefaultIdentityData MoonshotServerGetDefaultIdentityData;
typedef struct _DBusObjectVTable _DBusObjectVTable;

struct _MoonshotServer {
	GObject parent_instance;
	MoonshotServerPrivate * priv;
};

struct _MoonshotServerClass {
	GObjectClass parent_class;
};

struct _MoonshotServerPrivate {
	MainWindow* main_window;
};

typedef void (*ReturnIdentityCallback) (IdentityRequest* request, void* user_data);
struct _IdentityRequest {
	GObject parent_instance;
	IdentityRequestPrivate * priv;
	IdCard* id_card;
	gboolean complete;
	gboolean select_default;
};

struct _IdentityRequestClass {
	GObjectClass parent_class;
};

struct _Block2Data {
	int _ref_count_;
	MoonshotServer * self;
	gpointer _async_data_;
};

struct _MoonshotServerGetIdentityData {
	int _state_;
	GAsyncResult* _res_;
	GSimpleAsyncResult* _async_result;
	MoonshotServer* self;
	char* nai;
	char* password;
	char* service;
	char* nai_out;
	char* password_out;
	char* server_certificate_hash;
	char* ca_certificate;
	char* subject_name_constraint;
	char* subject_alt_name_constraint;
	gboolean result;
	IdentityRequest* request;
	char* _tmp0_;
	char* _tmp1_;
	char* _tmp2_;
	char* _tmp3_;
	char* _tmp4_;
	char* _tmp5_;
	IdCard* id_card;
	char* _tmp6_;
	char* _tmp7_;
	char* _tmp8_;
	Block2Data* _data2_;
};

struct _Block3Data {
	int _ref_count_;
	MoonshotServer * self;
	gpointer _async_data_;
};

struct _MoonshotServerGetDefaultIdentityData {
	int _state_;
	GAsyncResult* _res_;
	GSimpleAsyncResult* _async_result;
	MoonshotServer* self;
	char* nai_out;
	char* password_out;
	gboolean result;
	IdentityRequest* request;
	char* _tmp0_;
	char* _tmp1_;
	char* _tmp2_;
	char* _tmp3_;
	Block3Data* _data3_;
};

struct _DBusObjectVTable {
	void (*register_object) (DBusConnection*, const char*, void*);
};


static gpointer moonshot_server_parent_class = NULL;

GType moonshot_server_get_type (void) G_GNUC_CONST;
GType main_window_get_type (void) G_GNUC_CONST;
#define MOONSHOT_SERVER_GET_PRIVATE(o) (G_TYPE_INSTANCE_GET_PRIVATE ((o), TYPE_MOONSHOT_SERVER, MoonshotServerPrivate))
enum  {
	MOONSHOT_SERVER_DUMMY_PROPERTY
};
MoonshotServer* moonshot_server_new (GtkWindow* window);
MoonshotServer* moonshot_server_construct (GType object_type, GtkWindow* window);
static void moonshot_server_get_identity_data_free (gpointer _data);
static void moonshot_server_get_identity_ready (GObject* source_object, GAsyncResult* _res_, gpointer _user_data_);
void moonshot_server_get_identity (MoonshotServer* self, const char* nai, const char* password, const char* service, GAsyncReadyCallback _callback_, gpointer _user_data_);
gboolean moonshot_server_get_identity_finish (MoonshotServer* self, GAsyncResult* _res_, char** nai_out, char** password_out, char** server_certificate_hash, char** ca_certificate, char** subject_name_constraint, char** subject_alt_name_constraint);
static gboolean moonshot_server_get_identity_co (MoonshotServerGetIdentityData* data);
IdentityRequest* identity_request_new (MainWindow* main_window, const char* nai, const char* password, const char* certificate);
IdentityRequest* identity_request_construct (GType object_type, MainWindow* main_window, const char* nai, const char* password, const char* certificate);
GType identity_request_get_type (void) G_GNUC_CONST;
void identity_request_set_callback (IdentityRequest* self, ReturnIdentityCallback cb, void* cb_target, GDestroyNotify cb_target_destroy_notify);
static void _lambda1_ (IdentityRequest* IdentityRequest, Block2Data* _data2_);
static void __lambda1__return_identity_callback (IdentityRequest* request, gpointer self);
gboolean identity_request_execute (IdentityRequest* self);
GType id_card_get_type (void) G_GNUC_CONST;
const char* id_card_get_nai (IdCard* self);
const char* id_card_get_password (IdCard* self);
static Block2Data* block2_data_ref (Block2Data* _data2_);
static void block2_data_unref (Block2Data* _data2_);
static void moonshot_server_get_default_identity_data_free (gpointer _data);
static void moonshot_server_get_default_identity_ready (GObject* source_object, GAsyncResult* _res_, gpointer _user_data_);
void moonshot_server_get_default_identity (MoonshotServer* self, GAsyncReadyCallback _callback_, gpointer _user_data_);
gboolean moonshot_server_get_default_identity_finish (MoonshotServer* self, GAsyncResult* _res_, char** nai_out, char** password_out);
static gboolean moonshot_server_get_default_identity_co (MoonshotServerGetDefaultIdentityData* data);
IdentityRequest* identity_request_new_default (MainWindow* main_window);
IdentityRequest* identity_request_construct_default (GType object_type, MainWindow* main_window);
static void _lambda3_ (IdentityRequest* IdentityRequest, Block3Data* _data3_);
static void __lambda3__return_identity_callback (IdentityRequest* request, gpointer self);
static Block3Data* block3_data_ref (Block3Data* _data3_);
static void block3_data_unref (Block3Data* _data3_);
static void _vala_dbus_register_object (DBusConnection* connection, const char* path, void* object);
static void _vala_dbus_unregister_object (gpointer connection, GObject* object);
void moonshot_server_dbus_register_object (DBusConnection* connection, const char* path, void* object);
void _moonshot_server_dbus_unregister (DBusConnection* connection, void* _user_data_);
DBusHandlerResult moonshot_server_dbus_message (DBusConnection* connection, DBusMessage* message, void* object);
static DBusHandlerResult _dbus_moonshot_server_introspect (MoonshotServer* self, DBusConnection* connection, DBusMessage* message);
static DBusHandlerResult _dbus_moonshot_server_property_get_all (MoonshotServer* self, DBusConnection* connection, DBusMessage* message);
static DBusHandlerResult _dbus_moonshot_server_get_identity (MoonshotServer* self, DBusConnection* connection, DBusMessage* message);
static void _dbus_moonshot_server_get_identity_ready (GObject * source_object, GAsyncResult * _res_, gpointer * _user_data_);
static DBusHandlerResult _dbus_moonshot_server_get_default_identity (MoonshotServer* self, DBusConnection* connection, DBusMessage* message);
static void _dbus_moonshot_server_get_default_identity_ready (GObject * source_object, GAsyncResult * _res_, gpointer * _user_data_);
static void moonshot_server_finalize (GObject* obj);

static const DBusObjectPathVTable _moonshot_server_dbus_path_vtable = {_moonshot_server_dbus_unregister, moonshot_server_dbus_message};
static const _DBusObjectVTable _moonshot_server_dbus_vtable = {moonshot_server_dbus_register_object};


static gpointer _g_object_ref0 (gpointer self) {
	return self ? g_object_ref (self) : NULL;
}


MoonshotServer* moonshot_server_construct (GType object_type, GtkWindow* window) {
	MoonshotServer * self = NULL;
	MainWindow* _tmp0_;
	g_return_val_if_fail (window != NULL, NULL);
	self = (MoonshotServer*) g_object_new (object_type, NULL);
	self->priv->main_window = (_tmp0_ = _g_object_ref0 (MAIN_WINDOW (window)), _g_object_unref0 (self->priv->main_window), _tmp0_);
	return self;
}


MoonshotServer* moonshot_server_new (GtkWindow* window) {
	return moonshot_server_construct (TYPE_MOONSHOT_SERVER, window);
}


static void moonshot_server_get_identity_data_free (gpointer _data) {
	MoonshotServerGetIdentityData* data;
	data = _data;
	_g_free0 (data->nai);
	_g_free0 (data->password);
	_g_free0 (data->service);
	g_object_unref (data->self);
	g_slice_free (MoonshotServerGetIdentityData, data);
}


void moonshot_server_get_identity (MoonshotServer* self, const char* nai, const char* password, const char* service, GAsyncReadyCallback _callback_, gpointer _user_data_) {
	MoonshotServerGetIdentityData* _data_;
	_data_ = g_slice_new0 (MoonshotServerGetIdentityData);
	_data_->_async_result = g_simple_async_result_new (G_OBJECT (self), _callback_, _user_data_, moonshot_server_get_identity);
	g_simple_async_result_set_op_res_gpointer (_data_->_async_result, _data_, moonshot_server_get_identity_data_free);
	_data_->self = g_object_ref (self);
	_data_->nai = g_strdup (nai);
	_data_->password = g_strdup (password);
	_data_->service = g_strdup (service);
	moonshot_server_get_identity_co (_data_);
}


gboolean moonshot_server_get_identity_finish (MoonshotServer* self, GAsyncResult* _res_, char** nai_out, char** password_out, char** server_certificate_hash, char** ca_certificate, char** subject_name_constraint, char** subject_alt_name_constraint) {
	gboolean result;
	MoonshotServerGetIdentityData* _data_;
	_data_ = g_simple_async_result_get_op_res_gpointer (G_SIMPLE_ASYNC_RESULT (_res_));
	*nai_out = _data_->nai_out;
	_data_->nai_out = NULL;
	*password_out = _data_->password_out;
	_data_->password_out = NULL;
	*server_certificate_hash = _data_->server_certificate_hash;
	_data_->server_certificate_hash = NULL;
	*ca_certificate = _data_->ca_certificate;
	_data_->ca_certificate = NULL;
	*subject_name_constraint = _data_->subject_name_constraint;
	_data_->subject_name_constraint = NULL;
	*subject_alt_name_constraint = _data_->subject_alt_name_constraint;
	_data_->subject_alt_name_constraint = NULL;
	result = _data_->result;
	return result;
}


static void moonshot_server_get_identity_ready (GObject* source_object, GAsyncResult* _res_, gpointer _user_data_) {
	MoonshotServerGetIdentityData* data;
	data = _user_data_;
	data->_res_ = _res_;
	moonshot_server_get_identity_co (data);
}


/**
     * This is the function used by the GSS mechanism to get the NAI,
     * password and certificate of the ID card for the specificated service.
     *
     * The function will block until the user choose the ID card.
     *
     * There are two types of trust anchor that may be returned. If
     * server_certificate_hash is non-empty, the remaining parameters
     * will be empty. Otherwise, the ca_certificate paramater and the
     * subject name constraints will be returned.
     *
     * @param nai NAI of the ID Card (optional)
     * @param password Password of the ID Card (optional)
     * @param service Service application request an ID Card for (optional)
     * @param nai_out NAI stored in the ID Card
     * @param password_out Password stored in the ID Card
     * @param server_certificate_hash Hash of the identity server's certificate
     * @param ca_certificate Base64-encoded CA certificate
     * @param subject_name_constraint Subject name constraint
     * @param subject_alt_name_constraint Subject alternative name constraint
     *
     * @return true if the user choose a correct ID card for that service,
     *         false otherwise.
     */
static void _lambda1_ (IdentityRequest* IdentityRequest, Block2Data* _data2_) {
	MoonshotServer * self;
	self = _data2_->self;
	g_return_if_fail (IdentityRequest != NULL);
	moonshot_server_get_identity_co (_data2_->_async_data_);
}


static void __lambda1__return_identity_callback (IdentityRequest* request, gpointer self) {
	_lambda1_ (request, self);
}


static Block2Data* block2_data_ref (Block2Data* _data2_) {
	g_atomic_int_inc (&_data2_->_ref_count_);
	return _data2_;
}


static void block2_data_unref (Block2Data* _data2_) {
	if (g_atomic_int_dec_and_test (&_data2_->_ref_count_)) {
		_g_object_unref0 (_data2_->self);
		g_slice_free (Block2Data, _data2_);
	}
}


static gboolean moonshot_server_get_identity_co (MoonshotServerGetIdentityData* data) {
	switch (data->_state_) {
		case 0:
		goto _state_0;
		default:
		g_assert_not_reached ();
		case 1:
		goto _state_1;
	}
	_state_0:
	data->_data2_ = g_slice_new0 (Block2Data);
	data->_data2_->_ref_count_ = 1;
	data->_data2_->self = g_object_ref (data->self);
	data->_data2_->_async_data_ = data;
	data->request = identity_request_new (data->self->priv->main_window, data->nai, data->password, data->service);
	identity_request_set_callback (data->request, __lambda1__return_identity_callback, block2_data_ref (data->_data2_), block2_data_unref);
	identity_request_execute (data->request);
	data->_state_ = 1;
	return FALSE;
	_state_1:
	;
	data->nai_out = (data->_tmp0_ = g_strdup (""), _g_free0 (data->nai_out), data->_tmp0_);
	data->password_out = (data->_tmp1_ = g_strdup (""), _g_free0 (data->password_out), data->_tmp1_);
	data->server_certificate_hash = (data->_tmp2_ = g_strdup (""), _g_free0 (data->server_certificate_hash), data->_tmp2_);
	data->ca_certificate = (data->_tmp3_ = g_strdup (""), _g_free0 (data->ca_certificate), data->_tmp3_);
	data->subject_name_constraint = (data->_tmp4_ = g_strdup (""), _g_free0 (data->subject_name_constraint), data->_tmp4_);
	data->subject_alt_name_constraint = (data->_tmp5_ = g_strdup (""), _g_free0 (data->subject_alt_name_constraint), data->_tmp5_);
	data->id_card = _g_object_ref0 (data->request->id_card);
	if (data->id_card != NULL) {
		data->nai_out = (data->_tmp6_ = g_strdup (id_card_get_nai (data->id_card)), _g_free0 (data->nai_out), data->_tmp6_);
		data->password_out = (data->_tmp7_ = g_strdup (id_card_get_password (data->id_card)), _g_free0 (data->password_out), data->_tmp7_);
		data->server_certificate_hash = (data->_tmp8_ = g_strdup ("certificate"), _g_free0 (data->server_certificate_hash), data->_tmp8_);
		g_return_if_fail (data->nai_out != NULL);
		g_return_if_fail (data->password_out != NULL);
		data->result = TRUE;
		_g_object_unref0 (data->id_card);
		_g_object_unref0 (data->request);
		block2_data_unref (data->_data2_);
		{
			if (data->_state_ == 0) {
				g_simple_async_result_complete_in_idle (data->_async_result);
			} else {
				g_simple_async_result_complete (data->_async_result);
			}
			g_object_unref (data->_async_result);
			return FALSE;
		}
	}
	data->result = FALSE;
	_g_object_unref0 (data->id_card);
	_g_object_unref0 (data->request);
	block2_data_unref (data->_data2_);
	{
		if (data->_state_ == 0) {
			g_simple_async_result_complete_in_idle (data->_async_result);
		} else {
			g_simple_async_result_complete (data->_async_result);
		}
		g_object_unref (data->_async_result);
		return FALSE;
	}
	_g_object_unref0 (data->id_card);
	_g_object_unref0 (data->request);
	block2_data_unref (data->_data2_);
	{
		if (data->_state_ == 0) {
			g_simple_async_result_complete_in_idle (data->_async_result);
		} else {
			g_simple_async_result_complete (data->_async_result);
		}
		g_object_unref (data->_async_result);
		return FALSE;
	}
}


static void moonshot_server_get_default_identity_data_free (gpointer _data) {
	MoonshotServerGetDefaultIdentityData* data;
	data = _data;
	g_object_unref (data->self);
	g_slice_free (MoonshotServerGetDefaultIdentityData, data);
}


void moonshot_server_get_default_identity (MoonshotServer* self, GAsyncReadyCallback _callback_, gpointer _user_data_) {
	MoonshotServerGetDefaultIdentityData* _data_;
	_data_ = g_slice_new0 (MoonshotServerGetDefaultIdentityData);
	_data_->_async_result = g_simple_async_result_new (G_OBJECT (self), _callback_, _user_data_, moonshot_server_get_default_identity);
	g_simple_async_result_set_op_res_gpointer (_data_->_async_result, _data_, moonshot_server_get_default_identity_data_free);
	_data_->self = g_object_ref (self);
	moonshot_server_get_default_identity_co (_data_);
}


gboolean moonshot_server_get_default_identity_finish (MoonshotServer* self, GAsyncResult* _res_, char** nai_out, char** password_out) {
	gboolean result;
	MoonshotServerGetDefaultIdentityData* _data_;
	_data_ = g_simple_async_result_get_op_res_gpointer (G_SIMPLE_ASYNC_RESULT (_res_));
	*nai_out = _data_->nai_out;
	_data_->nai_out = NULL;
	*password_out = _data_->password_out;
	_data_->password_out = NULL;
	result = _data_->result;
	return result;
}


static void moonshot_server_get_default_identity_ready (GObject* source_object, GAsyncResult* _res_, gpointer _user_data_) {
	MoonshotServerGetDefaultIdentityData* data;
	data = _user_data_;
	data->_res_ = _res_;
	moonshot_server_get_default_identity_co (data);
}


/**
     * Returns the default identity - most recently used.
     *
     * @param nai_out NAI stored in the ID card
     * @param password_out Password stored in the ID card
     *
     * @return true on success, false if no identities are stored
     */
static void _lambda3_ (IdentityRequest* IdentityRequest, Block3Data* _data3_) {
	MoonshotServer * self;
	self = _data3_->self;
	g_return_if_fail (IdentityRequest != NULL);
	moonshot_server_get_default_identity_co (_data3_->_async_data_);
}


static void __lambda3__return_identity_callback (IdentityRequest* request, gpointer self) {
	_lambda3_ (request, self);
}


static Block3Data* block3_data_ref (Block3Data* _data3_) {
	g_atomic_int_inc (&_data3_->_ref_count_);
	return _data3_;
}


static void block3_data_unref (Block3Data* _data3_) {
	if (g_atomic_int_dec_and_test (&_data3_->_ref_count_)) {
		_g_object_unref0 (_data3_->self);
		g_slice_free (Block3Data, _data3_);
	}
}


static gboolean moonshot_server_get_default_identity_co (MoonshotServerGetDefaultIdentityData* data) {
	switch (data->_state_) {
		case 0:
		goto _state_0;
		default:
		g_assert_not_reached ();
		case 2:
		goto _state_2;
	}
	_state_0:
	data->_data3_ = g_slice_new0 (Block3Data);
	data->_data3_->_ref_count_ = 1;
	data->_data3_->self = g_object_ref (data->self);
	data->_data3_->_async_data_ = data;
	data->request = identity_request_new_default (data->self->priv->main_window);
	identity_request_set_callback (data->request, __lambda3__return_identity_callback, block3_data_ref (data->_data3_), block3_data_unref);
	identity_request_execute (data->request);
	data->_state_ = 2;
	return FALSE;
	_state_2:
	;
	data->nai_out = (data->_tmp0_ = g_strdup (""), _g_free0 (data->nai_out), data->_tmp0_);
	data->password_out = (data->_tmp1_ = g_strdup (""), _g_free0 (data->password_out), data->_tmp1_);
	if (data->request->id_card != NULL) {
		data->nai_out = (data->_tmp2_ = g_strdup (id_card_get_nai (data->request->id_card)), _g_free0 (data->nai_out), data->_tmp2_);
		data->password_out = (data->_tmp3_ = g_strdup (id_card_get_password (data->request->id_card)), _g_free0 (data->password_out), data->_tmp3_);
		g_return_val_if_fail (data->nai_out != NULL, FALSE);
		g_return_val_if_fail (data->password_out != NULL, FALSE);
		data->result = TRUE;
		_g_object_unref0 (data->request);
		block3_data_unref (data->_data3_);
		{
			if (data->_state_ == 0) {
				g_simple_async_result_complete_in_idle (data->_async_result);
			} else {
				g_simple_async_result_complete (data->_async_result);
			}
			g_object_unref (data->_async_result);
			return FALSE;
		}
	}
	data->result = FALSE;
	_g_object_unref0 (data->request);
	block3_data_unref (data->_data3_);
	{
		if (data->_state_ == 0) {
			g_simple_async_result_complete_in_idle (data->_async_result);
		} else {
			g_simple_async_result_complete (data->_async_result);
		}
		g_object_unref (data->_async_result);
		return FALSE;
	}
	_g_object_unref0 (data->request);
	block3_data_unref (data->_data3_);
	{
		if (data->_state_ == 0) {
			g_simple_async_result_complete_in_idle (data->_async_result);
		} else {
			g_simple_async_result_complete (data->_async_result);
		}
		g_object_unref (data->_async_result);
		return FALSE;
	}
}


static void _vala_dbus_register_object (DBusConnection* connection, const char* path, void* object) {
	const _DBusObjectVTable * vtable;
	vtable = g_type_get_qdata (G_TYPE_FROM_INSTANCE (object), g_quark_from_static_string ("DBusObjectVTable"));
	if (vtable) {
		vtable->register_object (connection, path, object);
	} else {
		g_warning ("Object does not implement any D-Bus interface");
	}
}


static void _vala_dbus_unregister_object (gpointer connection, GObject* object) {
	char* path;
	path = g_object_steal_data ((GObject*) object, "dbus_object_path");
	dbus_connection_unregister_object_path (connection, path);
	g_free (path);
}


void _moonshot_server_dbus_unregister (DBusConnection* connection, void* _user_data_) {
}


static DBusHandlerResult _dbus_moonshot_server_introspect (MoonshotServer* self, DBusConnection* connection, DBusMessage* message) {
	DBusMessage* reply;
	DBusMessageIter iter;
	GString* xml_data;
	char** children;
	int i;
	reply = dbus_message_new_method_return (message);
	dbus_message_iter_init_append (reply, &iter);
	xml_data = g_string_new ("<!DOCTYPE node PUBLIC \"-//freedesktop//DTD D-BUS Object Introspection 1.0//EN\" \"http://www.freedesktop.org/standards/dbus/1.0/introspect.dtd\">\n");
	g_string_append (xml_data, "<node>\n<interface name=\"org.freedesktop.DBus.Introspectable\">\n  <method name=\"Introspect\">\n    <arg name=\"data\" direction=\"out\" type=\"s\"/>\n  </method>\n</interface>\n<interface name=\"org.freedesktop.DBus.Properties\">\n  <method name=\"Get\">\n    <arg name=\"interface\" direction=\"in\" type=\"s\"/>\n    <arg name=\"propname\" direction=\"in\" type=\"s\"/>\n    <arg name=\"value\" direction=\"out\" type=\"v\"/>\n  </method>\n  <method name=\"Set\">\n    <arg name=\"interface\" direction=\"in\" type=\"s\"/>\n    <arg name=\"propname\" direction=\"in\" type=\"s\"/>\n    <arg name=\"value\" direction=\"in\" type=\"v\"/>\n  </method>\n  <method name=\"GetAll\">\n    <arg name=\"interface\" direction=\"in\" type=\"s\"/>\n    <arg name=\"props\" direction=\"out\" type=\"a{sv}\"/>\n  </method>\n</interface>\n<interface name=\"org.janet.Moonshot\">\n  <method name=\"GetIdentity\">\n    <arg name=\"nai\" type=\"s\" direction=\"in\"/>\n    <arg name=\"password\" type=\"s\" direction=\"in\"/>\n    <arg name=\"service\" type=\"s\" direction=\"in\"/>\n    <arg name=\"nai_out\" type=\"s\" direction=\"out\"/>\n    <arg name=\"password_out\" type=\"s\" direction=\"out\"/>\n    <arg name=\"server_certificate_hash\" type=\"s\" direction=\"out\"/>\n    <arg name=\"ca_certificate\" type=\"s\" direction=\"out\"/>\n    <arg name=\"subject_name_constraint\" type=\"s\" direction=\"out\"/>\n    <arg name=\"subject_alt_name_constraint\" type=\"s\" direction=\"out\"/>\n    <arg name=\"result\" type=\"b\" direction=\"out\"/>\n  </method>\n  <method name=\"GetDefaultIdentity\">\n    <arg name=\"nai_out\" type=\"s\" direction=\"out\"/>\n    <arg name=\"password_out\" type=\"s\" direction=\"out\"/>\n    <arg name=\"result\" type=\"b\" direction=\"out\"/>\n  </method>\n</interface>\n");
	dbus_connection_list_registered (connection, g_object_get_data ((GObject *) self, "dbus_object_path"), &children);
	for (i = 0; children[i]; i++) {
		g_string_append_printf (xml_data, "<node name=\"%s\"/>\n", children[i]);
	}
	dbus_free_string_array (children);
	g_string_append (xml_data, "</node>\n");
	dbus_message_iter_append_basic (&iter, DBUS_TYPE_STRING, &xml_data->str);
	g_string_free (xml_data, TRUE);
	if (reply) {
		dbus_connection_send (connection, reply, NULL);
		dbus_message_unref (reply);
		return DBUS_HANDLER_RESULT_HANDLED;
	} else {
		return DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
	}
}


static DBusHandlerResult _dbus_moonshot_server_property_get_all (MoonshotServer* self, DBusConnection* connection, DBusMessage* message) {
	DBusMessage* reply;
	DBusMessageIter iter, reply_iter, subiter;
	char* interface_name;
	const char* _tmp0_;
	if (strcmp (dbus_message_get_signature (message), "s")) {
		return DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
	}
	dbus_message_iter_init (message, &iter);
	reply = dbus_message_new_method_return (message);
	dbus_message_iter_init_append (reply, &reply_iter);
	dbus_message_iter_get_basic (&iter, &_tmp0_);
	dbus_message_iter_next (&iter);
	interface_name = g_strdup (_tmp0_);
	if (strcmp (interface_name, "org.janet.Moonshot") == 0) {
		dbus_message_iter_open_container (&reply_iter, DBUS_TYPE_ARRAY, "{sv}", &subiter);
		dbus_message_iter_close_container (&reply_iter, &subiter);
	} else {
		dbus_message_unref (reply);
		reply = NULL;
	}
	g_free (interface_name);
	if (reply) {
		dbus_connection_send (connection, reply, NULL);
		dbus_message_unref (reply);
		return DBUS_HANDLER_RESULT_HANDLED;
	} else {
		return DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
	}
}


static DBusHandlerResult _dbus_moonshot_server_get_identity (MoonshotServer* self, DBusConnection* connection, DBusMessage* message) {
	DBusMessageIter iter;
	char* nai = NULL;
	const char* _tmp1_;
	char* password = NULL;
	const char* _tmp2_;
	char* service = NULL;
	const char* _tmp3_;
	gpointer * _user_data_;
	if (strcmp (dbus_message_get_signature (message), "sss")) {
		return DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
	}
	dbus_message_iter_init (message, &iter);
	dbus_message_iter_get_basic (&iter, &_tmp1_);
	dbus_message_iter_next (&iter);
	nai = g_strdup (_tmp1_);
	dbus_message_iter_get_basic (&iter, &_tmp2_);
	dbus_message_iter_next (&iter);
	password = g_strdup (_tmp2_);
	dbus_message_iter_get_basic (&iter, &_tmp3_);
	dbus_message_iter_next (&iter);
	service = g_strdup (_tmp3_);
	_user_data_ = g_new0 (gpointer, 2);
	_user_data_[0] = dbus_connection_ref (connection);
	_user_data_[1] = dbus_message_ref (message);
	moonshot_server_get_identity (self, nai, password, service, (GAsyncReadyCallback) _dbus_moonshot_server_get_identity_ready, _user_data_);
	_g_free0 (nai);
	_g_free0 (password);
	_g_free0 (service);
	return DBUS_HANDLER_RESULT_HANDLED;
}


static void _dbus_moonshot_server_get_identity_ready (GObject * source_object, GAsyncResult * _res_, gpointer * _user_data_) {
	DBusConnection * connection;
	DBusMessage * message;
	DBusMessageIter iter;
	GError* error;
	char* nai_out = NULL;
	char* password_out = NULL;
	char* server_certificate_hash = NULL;
	char* ca_certificate = NULL;
	char* subject_name_constraint = NULL;
	char* subject_alt_name_constraint = NULL;
	gboolean result;
	DBusMessage* reply;
	const char* _tmp4_;
	const char* _tmp5_;
	const char* _tmp6_;
	const char* _tmp7_;
	const char* _tmp8_;
	const char* _tmp9_;
	dbus_bool_t _tmp10_;
	connection = _user_data_[0];
	message = _user_data_[1];
	error = NULL;
	result = moonshot_server_get_identity_finish ((MoonshotServer*) source_object, _res_, &nai_out, &password_out, &server_certificate_hash, &ca_certificate, &subject_name_constraint, &subject_alt_name_constraint);
	reply = dbus_message_new_method_return (message);
	dbus_message_iter_init_append (reply, &iter);
	_tmp4_ = nai_out;
	dbus_message_iter_append_basic (&iter, DBUS_TYPE_STRING, &_tmp4_);
	_g_free0 (nai_out);
	_tmp5_ = password_out;
	dbus_message_iter_append_basic (&iter, DBUS_TYPE_STRING, &_tmp5_);
	_g_free0 (password_out);
	_tmp6_ = server_certificate_hash;
	dbus_message_iter_append_basic (&iter, DBUS_TYPE_STRING, &_tmp6_);
	_g_free0 (server_certificate_hash);
	_tmp7_ = ca_certificate;
	dbus_message_iter_append_basic (&iter, DBUS_TYPE_STRING, &_tmp7_);
	_g_free0 (ca_certificate);
	_tmp8_ = subject_name_constraint;
	dbus_message_iter_append_basic (&iter, DBUS_TYPE_STRING, &_tmp8_);
	_g_free0 (subject_name_constraint);
	_tmp9_ = subject_alt_name_constraint;
	dbus_message_iter_append_basic (&iter, DBUS_TYPE_STRING, &_tmp9_);
	_g_free0 (subject_alt_name_constraint);
	_tmp10_ = result;
	dbus_message_iter_append_basic (&iter, DBUS_TYPE_BOOLEAN, &_tmp10_);
	dbus_connection_send (connection, reply, NULL);
	dbus_message_unref (reply);
	dbus_connection_unref (connection);
	dbus_message_unref (message);
	g_free (_user_data_);
}


static DBusHandlerResult _dbus_moonshot_server_get_default_identity (MoonshotServer* self, DBusConnection* connection, DBusMessage* message) {
	DBusMessageIter iter;
	gpointer * _user_data_;
	if (strcmp (dbus_message_get_signature (message), "")) {
		return DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
	}
	dbus_message_iter_init (message, &iter);
	_user_data_ = g_new0 (gpointer, 2);
	_user_data_[0] = dbus_connection_ref (connection);
	_user_data_[1] = dbus_message_ref (message);
	moonshot_server_get_default_identity (self, (GAsyncReadyCallback) _dbus_moonshot_server_get_default_identity_ready, _user_data_);
	return DBUS_HANDLER_RESULT_HANDLED;
}


static void _dbus_moonshot_server_get_default_identity_ready (GObject * source_object, GAsyncResult * _res_, gpointer * _user_data_) {
	DBusConnection * connection;
	DBusMessage * message;
	DBusMessageIter iter;
	GError* error;
	char* nai_out = NULL;
	char* password_out = NULL;
	gboolean result;
	DBusMessage* reply;
	const char* _tmp11_;
	const char* _tmp12_;
	dbus_bool_t _tmp13_;
	connection = _user_data_[0];
	message = _user_data_[1];
	error = NULL;
	result = moonshot_server_get_default_identity_finish ((MoonshotServer*) source_object, _res_, &nai_out, &password_out);
	reply = dbus_message_new_method_return (message);
	dbus_message_iter_init_append (reply, &iter);
	_tmp11_ = nai_out;
	dbus_message_iter_append_basic (&iter, DBUS_TYPE_STRING, &_tmp11_);
	_g_free0 (nai_out);
	_tmp12_ = password_out;
	dbus_message_iter_append_basic (&iter, DBUS_TYPE_STRING, &_tmp12_);
	_g_free0 (password_out);
	_tmp13_ = result;
	dbus_message_iter_append_basic (&iter, DBUS_TYPE_BOOLEAN, &_tmp13_);
	dbus_connection_send (connection, reply, NULL);
	dbus_message_unref (reply);
	dbus_connection_unref (connection);
	dbus_message_unref (message);
	g_free (_user_data_);
}


DBusHandlerResult moonshot_server_dbus_message (DBusConnection* connection, DBusMessage* message, void* object) {
	DBusHandlerResult result;
	result = DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
	if (dbus_message_is_method_call (message, "org.freedesktop.DBus.Introspectable", "Introspect")) {
		result = _dbus_moonshot_server_introspect (object, connection, message);
	} else if (dbus_message_is_method_call (message, "org.freedesktop.DBus.Properties", "GetAll")) {
		result = _dbus_moonshot_server_property_get_all (object, connection, message);
	} else if (dbus_message_is_method_call (message, "org.janet.Moonshot", "GetIdentity")) {
		result = _dbus_moonshot_server_get_identity (object, connection, message);
	} else if (dbus_message_is_method_call (message, "org.janet.Moonshot", "GetDefaultIdentity")) {
		result = _dbus_moonshot_server_get_default_identity (object, connection, message);
	}
	if (result == DBUS_HANDLER_RESULT_HANDLED) {
		return result;
	} else {
		return DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
	}
}


void moonshot_server_dbus_register_object (DBusConnection* connection, const char* path, void* object) {
	if (!g_object_get_data (object, "dbus_object_path")) {
		g_object_set_data (object, "dbus_object_path", g_strdup (path));
		dbus_connection_register_object_path (connection, path, &_moonshot_server_dbus_path_vtable, object);
		g_object_weak_ref (object, _vala_dbus_unregister_object, connection);
	}
}


static void moonshot_server_class_init (MoonshotServerClass * klass) {
	moonshot_server_parent_class = g_type_class_peek_parent (klass);
	g_type_class_add_private (klass, sizeof (MoonshotServerPrivate));
	G_OBJECT_CLASS (klass)->finalize = moonshot_server_finalize;
	g_type_set_qdata (TYPE_MOONSHOT_SERVER, g_quark_from_static_string ("DBusObjectVTable"), (void*) (&_moonshot_server_dbus_vtable));
}


static void moonshot_server_instance_init (MoonshotServer * self) {
	self->priv = MOONSHOT_SERVER_GET_PRIVATE (self);
}


static void moonshot_server_finalize (GObject* obj) {
	MoonshotServer * self;
	self = MOONSHOT_SERVER (obj);
	_g_object_unref0 (self->priv->main_window);
	G_OBJECT_CLASS (moonshot_server_parent_class)->finalize (obj);
}


GType moonshot_server_get_type (void) {
	static volatile gsize moonshot_server_type_id__volatile = 0;
	if (g_once_init_enter (&moonshot_server_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (MoonshotServerClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) moonshot_server_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (MoonshotServer), 0, (GInstanceInitFunc) moonshot_server_instance_init, NULL };
		GType moonshot_server_type_id;
		moonshot_server_type_id = g_type_register_static (G_TYPE_OBJECT, "MoonshotServer", &g_define_type_info, 0);
		g_once_init_leave (&moonshot_server_type_id__volatile, moonshot_server_type_id);
	}
	return moonshot_server_type_id__volatile;
}



