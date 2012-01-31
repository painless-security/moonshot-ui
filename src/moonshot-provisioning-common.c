/* moonshot-provisioning-common.c generated by valac 0.10.4, the Vala compiler
 * generated from moonshot-provisioning-common.vala, do not modify */


#include <glib.h>
#include <glib-object.h>
#include <stdlib.h>
#include <string.h>
#include <gio/gio.h>
#include <gobject/gvaluecollector.h>


#define TYPE_ID_CARD (id_card_get_type ())
#define ID_CARD(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_ID_CARD, IdCard))
#define ID_CARD_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_ID_CARD, IdCardClass))
#define IS_ID_CARD(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_ID_CARD))
#define IS_ID_CARD_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_ID_CARD))
#define ID_CARD_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_ID_CARD, IdCardClass))

typedef struct _IdCard IdCard;
typedef struct _IdCardClass IdCardClass;
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))

#define TYPE_RULE (rule_get_type ())
typedef struct _Rule Rule;
#define _g_free0(var) (var = (g_free (var), NULL))

#define TYPE_TRUST_ANCHOR (trust_anchor_get_type ())
#define TRUST_ANCHOR(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_TRUST_ANCHOR, TrustAnchor))
#define TRUST_ANCHOR_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_TRUST_ANCHOR, TrustAnchorClass))
#define IS_TRUST_ANCHOR(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_TRUST_ANCHOR))
#define IS_TRUST_ANCHOR_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_TRUST_ANCHOR))
#define TRUST_ANCHOR_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_TRUST_ANCHOR, TrustAnchorClass))

typedef struct _TrustAnchor TrustAnchor;
typedef struct _TrustAnchorClass TrustAnchorClass;

#define WEB_PROVISIONING_TYPE_PARSER (web_provisioning_parser_get_type ())
#define WEB_PROVISIONING_PARSER(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), WEB_PROVISIONING_TYPE_PARSER, WebProvisioningParser))
#define WEB_PROVISIONING_PARSER_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), WEB_PROVISIONING_TYPE_PARSER, WebProvisioningParserClass))
#define WEB_PROVISIONING_IS_PARSER(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), WEB_PROVISIONING_TYPE_PARSER))
#define WEB_PROVISIONING_IS_PARSER_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), WEB_PROVISIONING_TYPE_PARSER))
#define WEB_PROVISIONING_PARSER_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), WEB_PROVISIONING_TYPE_PARSER, WebProvisioningParserClass))

typedef struct _WebProvisioningParser WebProvisioningParser;
typedef struct _WebProvisioningParserClass WebProvisioningParserClass;
typedef struct _WebProvisioningParserPrivate WebProvisioningParserPrivate;
#define _g_error_free0(var) ((var == NULL) ? NULL : (var = (g_error_free (var), NULL)))
#define _g_markup_parse_context_free0(var) ((var == NULL) ? NULL : (var = (g_markup_parse_context_free (var), NULL)))
typedef struct _WebProvisioningParamSpecParser WebProvisioningParamSpecParser;

struct _Rule {
	char* pattern;
	char* always_confirm;
};

struct _WebProvisioningParser {
	GTypeInstance parent_instance;
	volatile int ref_count;
	WebProvisioningParserPrivate * priv;
};

struct _WebProvisioningParserClass {
	GTypeClass parent_class;
	void (*finalize) (WebProvisioningParser *self);
};

struct _WebProvisioningParserPrivate {
	GMarkupParser parser;
	char* text;
	char* path;
};

struct _WebProvisioningParamSpecParser {
	GParamSpec parent_instance;
};


extern IdCard* web_provisioning_card;
IdCard* web_provisioning_card = NULL;
extern IdCard** web_provisioning_cards;
extern gint web_provisioning_cards_length1;
IdCard** web_provisioning_cards = NULL;
gint web_provisioning_cards_length1 = 0;
static gint _web_provisioning_cards_size_ = 0;
static gpointer web_provisioning_parser_parent_class = NULL;

GType id_card_get_type (void) G_GNUC_CONST;
gboolean web_provisioning_check_stack (GSList* stack, char** reference, int reference_length1);
gboolean web_provisioning_always_confirm_handler (GSList* stack);
gboolean web_provisioning_pattern_handler (GSList* stack);
gboolean web_provisioning_server_cert_handler (GSList* stack);
gboolean web_provisioning_subject_alt_handler (GSList* stack);
gboolean web_provisioning_subject_handler (GSList* stack);
gboolean web_provisioning_ca_cert_handler (GSList* stack);
gboolean web_provisioning_realm_handler (GSList* stack);
gboolean web_provisioning_password_handler (GSList* stack);
gboolean web_provisioning_user_handler (GSList* stack);
gboolean web_provisioning_display_name_handler (GSList* stack);
void web_provisioning_start_element_func (GMarkupParseContext* context, const char* element_name, char** attribute_names, int attribute_names_length1, char** attribute_values, int attribute_values_length1, GError** error);
static IdCard** _vala_array_dup4 (IdCard** self, int length);
IdCard* id_card_new (void);
IdCard* id_card_construct (GType object_type);
GType rule_get_type (void) G_GNUC_CONST;
Rule* rule_dup (const Rule* self);
void rule_free (Rule* self);
void rule_copy (const Rule* self, Rule* dest);
void rule_destroy (Rule* self);
Rule* id_card_get_rules (IdCard* self, int* result_length1);
static Rule* _vala_array_dup5 (Rule* self, int length);
void id_card_set_rules (IdCard* self, Rule* value, int value_length1);
static void _vala_Rule_array_free (Rule* array, gint array_length);
void web_provisioning_text_element_func (GMarkupParseContext* context, const char* text, gsize text_len, GError** error);
void id_card_set_display_name (IdCard* self, const char* value);
void id_card_set_username (IdCard* self, const char* value);
void id_card_set_password (IdCard* self, const char* value);
void id_card_set_issuer (IdCard* self, const char* value);
char** id_card_get_services (IdCard* self, int* result_length1);
static char** _vala_array_dup6 (char** self, int length);
void id_card_set_services (IdCard* self, char** value, int value_length1);
GType trust_anchor_get_type (void) G_GNUC_CONST;
TrustAnchor* id_card_get_trust_anchor (IdCard* self);
void trust_anchor_set_ca_cert (TrustAnchor* self, const char* value);
void trust_anchor_set_subject (TrustAnchor* self, const char* value);
void trust_anchor_set_subject_alt (TrustAnchor* self, const char* value);
void trust_anchor_set_server_cert (TrustAnchor* self, const char* value);
gpointer web_provisioning_parser_ref (gpointer instance);
void web_provisioning_parser_unref (gpointer instance);
GParamSpec* web_provisioning_param_spec_parser (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void web_provisioning_value_set_parser (GValue* value, gpointer v_object);
void web_provisioning_value_take_parser (GValue* value, gpointer v_object);
gpointer web_provisioning_value_get_parser (const GValue* value);
GType web_provisioning_parser_get_type (void) G_GNUC_CONST;
#define WEB_PROVISIONING_PARSER_GET_PRIVATE(o) (G_TYPE_INSTANCE_GET_PRIVATE ((o), WEB_PROVISIONING_TYPE_PARSER, WebProvisioningParserPrivate))
enum  {
	WEB_PROVISIONING_PARSER_DUMMY_PROPERTY
};
WebProvisioningParser* web_provisioning_parser_new (const char* path);
WebProvisioningParser* web_provisioning_parser_construct (GType object_type, const char* path);
static void _web_provisioning_start_element_func_gmarkup_parser_start_element_func (GMarkupParseContext* context, const char* element_name, char** attribute_names, char** attribute_values, gpointer self, GError** error);
static void _web_provisioning_text_element_func_gmarkup_parser_text_func (GMarkupParseContext* context, const char* text, gsize text_len, gpointer self, GError** error);
void web_provisioning_parser_parse (WebProvisioningParser* self);
static void web_provisioning_parser_finalize (WebProvisioningParser* obj);
static void _vala_array_destroy (gpointer array, gint array_length, GDestroyNotify destroy_func);
static void _vala_array_free (gpointer array, gint array_length, GDestroyNotify destroy_func);
static gint _vala_array_length (gpointer array);
static int _vala_strcmp0 (const char * str1, const char * str2);



gboolean web_provisioning_check_stack (GSList* stack, char** reference, int reference_length1) {
	gboolean result = FALSE;
	if (g_slist_length (stack) < reference_length1) {
		result = FALSE;
		return result;
	}
	{
		gint i;
		i = 0;
		{
			gboolean _tmp0_;
			_tmp0_ = TRUE;
			while (TRUE) {
				if (!_tmp0_) {
					i++;
				}
				_tmp0_ = FALSE;
				if (!(i < reference_length1)) {
					break;
				}
				if (_vala_strcmp0 ((const char*) g_slist_nth_data (stack, (guint) i), reference[i]) != 0) {
					result = FALSE;
					return result;
				}
			}
		}
	}
	result = TRUE;
	return result;
}


gboolean web_provisioning_always_confirm_handler (GSList* stack) {
	gboolean result = FALSE;
	gint always_confirm_path_length1;
	gint _always_confirm_path_size_;
	char** _tmp1_;
	char** _tmp0_ = NULL;
	char** always_confirm_path;
	always_confirm_path = (_tmp1_ = (_tmp0_ = g_new0 (char*, 5 + 1), _tmp0_[0] = g_strdup ("always-confirm"), _tmp0_[1] = g_strdup ("rule"), _tmp0_[2] = g_strdup ("selection-rules"), _tmp0_[3] = g_strdup ("identity"), _tmp0_[4] = g_strdup ("identities"), _tmp0_), always_confirm_path_length1 = 5, _always_confirm_path_size_ = always_confirm_path_length1, _tmp1_);
	result = web_provisioning_check_stack (stack, always_confirm_path, always_confirm_path_length1);
	always_confirm_path = (_vala_array_free (always_confirm_path, always_confirm_path_length1, (GDestroyNotify) g_free), NULL);
	return result;
}


gboolean web_provisioning_pattern_handler (GSList* stack) {
	gboolean result = FALSE;
	gint pattern_path_length1;
	gint _pattern_path_size_;
	char** _tmp1_;
	char** _tmp0_ = NULL;
	char** pattern_path;
	pattern_path = (_tmp1_ = (_tmp0_ = g_new0 (char*, 5 + 1), _tmp0_[0] = g_strdup ("pattern"), _tmp0_[1] = g_strdup ("rule"), _tmp0_[2] = g_strdup ("selection-rules"), _tmp0_[3] = g_strdup ("identity"), _tmp0_[4] = g_strdup ("identities"), _tmp0_), pattern_path_length1 = 5, _pattern_path_size_ = pattern_path_length1, _tmp1_);
	result = web_provisioning_check_stack (stack, pattern_path, pattern_path_length1);
	pattern_path = (_vala_array_free (pattern_path, pattern_path_length1, (GDestroyNotify) g_free), NULL);
	return result;
}


gboolean web_provisioning_server_cert_handler (GSList* stack) {
	gboolean result = FALSE;
	gint server_cert_path_length1;
	gint _server_cert_path_size_;
	char** _tmp1_;
	char** _tmp0_ = NULL;
	char** server_cert_path;
	server_cert_path = (_tmp1_ = (_tmp0_ = g_new0 (char*, 4 + 1), _tmp0_[0] = g_strdup ("server-cert"), _tmp0_[1] = g_strdup ("trust-anchor"), _tmp0_[2] = g_strdup ("identity"), _tmp0_[3] = g_strdup ("identities"), _tmp0_), server_cert_path_length1 = 4, _server_cert_path_size_ = server_cert_path_length1, _tmp1_);
	result = web_provisioning_check_stack (stack, server_cert_path, server_cert_path_length1);
	server_cert_path = (_vala_array_free (server_cert_path, server_cert_path_length1, (GDestroyNotify) g_free), NULL);
	return result;
}


gboolean web_provisioning_subject_alt_handler (GSList* stack) {
	gboolean result = FALSE;
	gint subject_alt_path_length1;
	gint _subject_alt_path_size_;
	char** _tmp1_;
	char** _tmp0_ = NULL;
	char** subject_alt_path;
	subject_alt_path = (_tmp1_ = (_tmp0_ = g_new0 (char*, 4 + 1), _tmp0_[0] = g_strdup ("subject-alt"), _tmp0_[1] = g_strdup ("trust-anchor"), _tmp0_[2] = g_strdup ("identity"), _tmp0_[3] = g_strdup ("identities"), _tmp0_), subject_alt_path_length1 = 4, _subject_alt_path_size_ = subject_alt_path_length1, _tmp1_);
	result = web_provisioning_check_stack (stack, subject_alt_path, subject_alt_path_length1);
	subject_alt_path = (_vala_array_free (subject_alt_path, subject_alt_path_length1, (GDestroyNotify) g_free), NULL);
	return result;
}


gboolean web_provisioning_subject_handler (GSList* stack) {
	gboolean result = FALSE;
	gint subject_path_length1;
	gint _subject_path_size_;
	char** _tmp1_;
	char** _tmp0_ = NULL;
	char** subject_path;
	subject_path = (_tmp1_ = (_tmp0_ = g_new0 (char*, 4 + 1), _tmp0_[0] = g_strdup ("subject"), _tmp0_[1] = g_strdup ("trust-anchor"), _tmp0_[2] = g_strdup ("identity"), _tmp0_[3] = g_strdup ("identities"), _tmp0_), subject_path_length1 = 4, _subject_path_size_ = subject_path_length1, _tmp1_);
	result = web_provisioning_check_stack (stack, subject_path, subject_path_length1);
	subject_path = (_vala_array_free (subject_path, subject_path_length1, (GDestroyNotify) g_free), NULL);
	return result;
}


gboolean web_provisioning_ca_cert_handler (GSList* stack) {
	gboolean result = FALSE;
	gint ca_path_length1;
	gint _ca_path_size_;
	char** _tmp1_;
	char** _tmp0_ = NULL;
	char** ca_path;
	ca_path = (_tmp1_ = (_tmp0_ = g_new0 (char*, 4 + 1), _tmp0_[0] = g_strdup ("ca-cert"), _tmp0_[1] = g_strdup ("trust-anchor"), _tmp0_[2] = g_strdup ("identity"), _tmp0_[3] = g_strdup ("identities"), _tmp0_), ca_path_length1 = 4, _ca_path_size_ = ca_path_length1, _tmp1_);
	result = web_provisioning_check_stack (stack, ca_path, ca_path_length1);
	ca_path = (_vala_array_free (ca_path, ca_path_length1, (GDestroyNotify) g_free), NULL);
	return result;
}


gboolean web_provisioning_realm_handler (GSList* stack) {
	gboolean result = FALSE;
	gint realm_path_length1;
	gint _realm_path_size_;
	char** _tmp1_;
	char** _tmp0_ = NULL;
	char** realm_path;
	realm_path = (_tmp1_ = (_tmp0_ = g_new0 (char*, 3 + 1), _tmp0_[0] = g_strdup ("realm"), _tmp0_[1] = g_strdup ("identity"), _tmp0_[2] = g_strdup ("identities"), _tmp0_), realm_path_length1 = 3, _realm_path_size_ = realm_path_length1, _tmp1_);
	result = web_provisioning_check_stack (stack, realm_path, realm_path_length1);
	realm_path = (_vala_array_free (realm_path, realm_path_length1, (GDestroyNotify) g_free), NULL);
	return result;
}


gboolean web_provisioning_password_handler (GSList* stack) {
	gboolean result = FALSE;
	gint password_path_length1;
	gint _password_path_size_;
	char** _tmp1_;
	char** _tmp0_ = NULL;
	char** password_path;
	password_path = (_tmp1_ = (_tmp0_ = g_new0 (char*, 3 + 1), _tmp0_[0] = g_strdup ("password"), _tmp0_[1] = g_strdup ("identity"), _tmp0_[2] = g_strdup ("identities"), _tmp0_), password_path_length1 = 3, _password_path_size_ = password_path_length1, _tmp1_);
	result = web_provisioning_check_stack (stack, password_path, password_path_length1);
	password_path = (_vala_array_free (password_path, password_path_length1, (GDestroyNotify) g_free), NULL);
	return result;
}


gboolean web_provisioning_user_handler (GSList* stack) {
	gboolean result = FALSE;
	gint user_path_length1;
	gint _user_path_size_;
	char** _tmp1_;
	char** _tmp0_ = NULL;
	char** user_path;
	user_path = (_tmp1_ = (_tmp0_ = g_new0 (char*, 3 + 1), _tmp0_[0] = g_strdup ("user"), _tmp0_[1] = g_strdup ("identity"), _tmp0_[2] = g_strdup ("identities"), _tmp0_), user_path_length1 = 3, _user_path_size_ = user_path_length1, _tmp1_);
	result = web_provisioning_check_stack (stack, user_path, user_path_length1);
	user_path = (_vala_array_free (user_path, user_path_length1, (GDestroyNotify) g_free), NULL);
	return result;
}


gboolean web_provisioning_display_name_handler (GSList* stack) {
	gboolean result = FALSE;
	gint display_name_path_length1;
	gint _display_name_path_size_;
	char** _tmp1_;
	char** _tmp0_ = NULL;
	char** display_name_path;
	display_name_path = (_tmp1_ = (_tmp0_ = g_new0 (char*, 3 + 1), _tmp0_[0] = g_strdup ("display-name"), _tmp0_[1] = g_strdup ("identity"), _tmp0_[2] = g_strdup ("identities"), _tmp0_), display_name_path_length1 = 3, _display_name_path_size_ = display_name_path_length1, _tmp1_);
	result = web_provisioning_check_stack (stack, display_name_path, display_name_path_length1);
	display_name_path = (_vala_array_free (display_name_path, display_name_path_length1, (GDestroyNotify) g_free), NULL);
	return result;
}


static gpointer _g_object_ref0 (gpointer self) {
	return self ? g_object_ref (self) : NULL;
}


static IdCard** _vala_array_dup4 (IdCard** self, int length) {
	IdCard** result;
	int i;
	result = g_new0 (IdCard*, length + 1);
	for (i = 0; i < length; i++) {
		result[i] = _g_object_ref0 (self[i]);
	}
	return result;
}


static Rule* _vala_array_dup5 (Rule* self, int length) {
	Rule* result;
	int i;
	Rule _tmp0_ = {0};
	result = g_new0 (Rule, length);
	for (i = 0; i < length; i++) {
		result[i] = (rule_copy (&self[i], &_tmp0_), _tmp0_);
	}
	return result;
}


static void _vala_Rule_array_free (Rule* array, gint array_length) {
	if (array != NULL) {
		int i;
		for (i = 0; i < array_length; i = i + 1) {
			rule_destroy (&array[i]);
		}
	}
	g_free (array);
}


void web_provisioning_start_element_func (GMarkupParseContext* context, const char* element_name, char** attribute_names, int attribute_names_length1, char** attribute_values, int attribute_values_length1, GError** error) {
	g_return_if_fail (context != NULL);
	g_return_if_fail (element_name != NULL);
	if (_vala_strcmp0 (element_name, "identity") == 0) {
		gint tmp_cards_length1;
		gint _tmp_cards_size_;
		IdCard** _tmp1_;
		IdCard** _tmp0_;
		IdCard** tmp_cards;
		IdCard** _tmp2_;
		IdCard* _tmp5_;
		IdCard* _tmp6_;
		tmp_cards = (_tmp1_ = (_tmp0_ = web_provisioning_cards, (_tmp0_ == NULL) ? ((gpointer) _tmp0_) : _vala_array_dup4 (_tmp0_, web_provisioning_cards_length1)), tmp_cards_length1 = web_provisioning_cards_length1, _tmp_cards_size_ = tmp_cards_length1, _tmp1_);
		web_provisioning_cards = (_tmp2_ = g_new0 (IdCard*, (tmp_cards_length1 + 1) + 1), web_provisioning_cards = (_vala_array_free (web_provisioning_cards, web_provisioning_cards_length1, (GDestroyNotify) g_object_unref), NULL), web_provisioning_cards_length1 = tmp_cards_length1 + 1, _web_provisioning_cards_size_ = web_provisioning_cards_length1, _tmp2_);
		{
			gint i;
			i = 0;
			{
				gboolean _tmp3_;
				_tmp3_ = TRUE;
				while (TRUE) {
					IdCard* _tmp4_;
					if (!_tmp3_) {
						i++;
					}
					_tmp3_ = FALSE;
					if (!(i < tmp_cards_length1)) {
						break;
					}
					web_provisioning_cards[i] = (_tmp4_ = _g_object_ref0 (tmp_cards[i]), _g_object_unref0 (web_provisioning_cards[i]), _tmp4_);
				}
			}
		}
		web_provisioning_card = (_tmp5_ = id_card_new (), _g_object_unref0 (web_provisioning_card), _tmp5_);
		web_provisioning_cards[tmp_cards_length1] = (_tmp6_ = _g_object_ref0 (web_provisioning_card), _g_object_unref0 (web_provisioning_cards[tmp_cards_length1]), _tmp6_);
		tmp_cards = (_vala_array_free (tmp_cards, tmp_cards_length1, (GDestroyNotify) g_object_unref), NULL);
	} else {
		if (_vala_strcmp0 (element_name, "rule") == 0) {
			gint tmp_rules_length1;
			gint _tmp_rules_size_;
			Rule* _tmp9_;
			gint _tmp7_;
			Rule* _tmp8_;
			Rule* tmp_rules;
			Rule* _tmp10_;
			gint _tmp10__length1;
			Rule* _tmp11_;
			gint _tmp18_;
			Rule _tmp19_ = {0};
			gint _tmp20_;
			Rule *_tmp21_;
			Rule _tmp22_;
			tmp_rules = (_tmp9_ = (_tmp8_ = id_card_get_rules (web_provisioning_card, &_tmp7_), (_tmp8_ == NULL) ? ((gpointer) _tmp8_) : _vala_array_dup5 (_tmp8_, _tmp7_)), tmp_rules_length1 = _tmp7_, _tmp_rules_size_ = tmp_rules_length1, _tmp9_);
			_tmp11_ = (_tmp10_ = g_new0 (Rule, tmp_rules_length1 + 1), _tmp10__length1 = tmp_rules_length1 + 1, _tmp10_);
			id_card_set_rules (web_provisioning_card, _tmp11_, tmp_rules_length1 + 1);
			_tmp10_ = (_vala_Rule_array_free (_tmp10_, _tmp10__length1), NULL);
			{
				gint i;
				i = 0;
				{
					gboolean _tmp12_;
					_tmp12_ = TRUE;
					while (TRUE) {
						gint _tmp13_;
						Rule _tmp14_ = {0};
						gint _tmp15_;
						Rule *_tmp16_;
						Rule _tmp17_;
						if (!_tmp12_) {
							i++;
						}
						_tmp12_ = FALSE;
						if (!(i < tmp_rules_length1)) {
							break;
						}
						_tmp16_ = &id_card_get_rules (web_provisioning_card, &_tmp15_)[i];
						(*_tmp16_) = (_tmp17_ = (rule_copy (&tmp_rules[i], &_tmp14_), _tmp14_), rule_destroy (&(*_tmp16_)), _tmp17_);
					}
				}
			}
			_tmp21_ = &id_card_get_rules (web_provisioning_card, &_tmp20_)[tmp_rules_length1];
			(*_tmp21_) = (_tmp22_ = (memset (&_tmp19_, 0, sizeof (Rule)), _tmp19_), rule_destroy (&(*_tmp21_)), _tmp22_);
			tmp_rules = (_vala_Rule_array_free (tmp_rules, tmp_rules_length1), NULL);
		}
	}
}


static char** _vala_array_dup6 (char** self, int length) {
	char** result;
	int i;
	result = g_new0 (char*, length + 1);
	for (i = 0; i < length; i++) {
		result[i] = g_strdup (self[i]);
	}
	return result;
}


void web_provisioning_text_element_func (GMarkupParseContext* context, const char* text, gsize text_len, GError** error) {
	GSList* stack;
	gboolean _tmp0_ = FALSE;
	g_return_if_fail (context != NULL);
	g_return_if_fail (text != NULL);
	stack = g_markup_parse_context_get_element_stack (context);
	if (text_len < 1) {
		return;
	}
	if (_vala_strcmp0 ((const char*) g_slist_nth_data (stack, (guint) 0), "display-name") == 0) {
		_tmp0_ = web_provisioning_display_name_handler (stack);
	} else {
		_tmp0_ = FALSE;
	}
	if (_tmp0_) {
		id_card_set_display_name (web_provisioning_card, text);
	} else {
		gboolean _tmp1_ = FALSE;
		if (_vala_strcmp0 ((const char*) g_slist_nth_data (stack, (guint) 0), "user") == 0) {
			_tmp1_ = web_provisioning_user_handler (stack);
		} else {
			_tmp1_ = FALSE;
		}
		if (_tmp1_) {
			id_card_set_username (web_provisioning_card, text);
		} else {
			gboolean _tmp2_ = FALSE;
			if (_vala_strcmp0 ((const char*) g_slist_nth_data (stack, (guint) 0), "password") == 0) {
				_tmp2_ = web_provisioning_password_handler (stack);
			} else {
				_tmp2_ = FALSE;
			}
			if (_tmp2_) {
				id_card_set_password (web_provisioning_card, text);
			} else {
				gboolean _tmp3_ = FALSE;
				if (_vala_strcmp0 ((const char*) g_slist_nth_data (stack, (guint) 0), "realm") == 0) {
					_tmp3_ = web_provisioning_realm_handler (stack);
				} else {
					_tmp3_ = FALSE;
				}
				if (_tmp3_) {
					id_card_set_issuer (web_provisioning_card, text);
				} else {
					if (_vala_strcmp0 ((const char*) g_slist_nth_data (stack, (guint) 0), "service") == 0) {
						gint services_length1;
						gint _services_size_;
						char** _tmp6_;
						gint _tmp4_;
						char** _tmp5_;
						char** services;
						char** _tmp7_;
						gint _tmp7__length1;
						char** _tmp8_;
						gint _tmp14_;
						gint _tmp15_;
						char* *_tmp16_;
						char* _tmp17_;
						services = (_tmp6_ = (_tmp5_ = id_card_get_services (web_provisioning_card, &_tmp4_), (_tmp5_ == NULL) ? ((gpointer) _tmp5_) : _vala_array_dup6 (_tmp5_, _tmp4_)), services_length1 = _tmp4_, _services_size_ = services_length1, _tmp6_);
						_tmp8_ = (_tmp7_ = g_new0 (char*, (services_length1 + 1) + 1), _tmp7__length1 = services_length1 + 1, _tmp7_);
						id_card_set_services (web_provisioning_card, _tmp8_, services_length1 + 1);
						_tmp7_ = (_vala_array_free (_tmp7_, _tmp7__length1, (GDestroyNotify) g_free), NULL);
						{
							gint i;
							i = 0;
							{
								gboolean _tmp9_;
								_tmp9_ = TRUE;
								while (TRUE) {
									gint _tmp10_;
									gint _tmp11_;
									char* *_tmp12_;
									char* _tmp13_;
									if (!_tmp9_) {
										i++;
									}
									_tmp9_ = FALSE;
									if (!(i < services_length1)) {
										break;
									}
									_tmp12_ = &id_card_get_services (web_provisioning_card, &_tmp11_)[i];
									(*_tmp12_) = (_tmp13_ = g_strdup (services[i]), _g_free0 ((*_tmp12_)), _tmp13_);
								}
							}
						}
						_tmp16_ = &id_card_get_services (web_provisioning_card, &_tmp15_)[services_length1];
						(*_tmp16_) = (_tmp17_ = g_strdup (text), _g_free0 ((*_tmp16_)), _tmp17_);
						services = (_vala_array_free (services, services_length1, (GDestroyNotify) g_free), NULL);
					} else {
						gboolean _tmp18_ = FALSE;
						if (_vala_strcmp0 ((const char*) g_slist_nth_data (stack, (guint) 0), "pattern") == 0) {
							_tmp18_ = web_provisioning_pattern_handler (stack);
						} else {
							_tmp18_ = FALSE;
						}
						if (_tmp18_) {
							gint _tmp19_;
							gint _tmp20_;
							char* *_tmp21_;
							char* _tmp22_;
							_tmp21_ = &id_card_get_rules (web_provisioning_card, &_tmp19_)[_tmp20_ - 1].pattern;
							(*_tmp21_) = (_tmp22_ = g_strdup (text), _g_free0 ((*_tmp21_)), _tmp22_);
						} else {
							gboolean _tmp23_ = FALSE;
							if (_vala_strcmp0 ((const char*) g_slist_nth_data (stack, (guint) 0), "always-confirm") == 0) {
								_tmp23_ = web_provisioning_always_confirm_handler (stack);
							} else {
								_tmp23_ = FALSE;
							}
							if (_tmp23_) {
								gboolean _tmp24_ = FALSE;
								if (_vala_strcmp0 (text, "true") == 0) {
									_tmp24_ = TRUE;
								} else {
									_tmp24_ = _vala_strcmp0 (text, "false") == 0;
								}
								if (_tmp24_) {
									gint _tmp25_;
									gint _tmp26_;
									char* *_tmp27_;
									char* _tmp28_;
									_tmp27_ = &id_card_get_rules (web_provisioning_card, &_tmp25_)[_tmp26_ - 1].always_confirm;
									(*_tmp27_) = (_tmp28_ = g_strdup (text), _g_free0 ((*_tmp27_)), _tmp28_);
								}
							} else {
								gboolean _tmp29_ = FALSE;
								if (_vala_strcmp0 ((const char*) g_slist_nth_data (stack, (guint) 0), "ca-cert") == 0) {
									_tmp29_ = web_provisioning_ca_cert_handler (stack);
								} else {
									_tmp29_ = FALSE;
								}
								if (_tmp29_) {
									trust_anchor_set_ca_cert (id_card_get_trust_anchor (web_provisioning_card), text);
								} else {
									gboolean _tmp30_ = FALSE;
									if (_vala_strcmp0 ((const char*) g_slist_nth_data (stack, (guint) 0), "subject") == 0) {
										_tmp30_ = web_provisioning_subject_handler (stack);
									} else {
										_tmp30_ = FALSE;
									}
									if (_tmp30_) {
										trust_anchor_set_subject (id_card_get_trust_anchor (web_provisioning_card), text);
									} else {
										gboolean _tmp31_ = FALSE;
										if (_vala_strcmp0 ((const char*) g_slist_nth_data (stack, (guint) 0), "subject-alt") == 0) {
											_tmp31_ = web_provisioning_subject_alt_handler (stack);
										} else {
											_tmp31_ = FALSE;
										}
										if (_tmp31_) {
											trust_anchor_set_subject_alt (id_card_get_trust_anchor (web_provisioning_card), text);
										} else {
											gboolean _tmp32_ = FALSE;
											if (_vala_strcmp0 ((const char*) g_slist_nth_data (stack, (guint) 0), "server-cert") == 0) {
												_tmp32_ = web_provisioning_server_cert_handler (stack);
											} else {
												_tmp32_ = FALSE;
											}
											if (_tmp32_) {
												trust_anchor_set_server_cert (id_card_get_trust_anchor (web_provisioning_card), text);
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}


static void _web_provisioning_start_element_func_gmarkup_parser_start_element_func (GMarkupParseContext* context, const char* element_name, char** attribute_names, char** attribute_values, gpointer self, GError** error) {
	web_provisioning_start_element_func (context, element_name, attribute_names, _vala_array_length (attribute_names), attribute_values, _vala_array_length (attribute_values), error);
}


static void _web_provisioning_text_element_func_gmarkup_parser_text_func (GMarkupParseContext* context, const char* text, gsize text_len, gpointer self, GError** error) {
	web_provisioning_text_element_func (context, text, text_len, error);
}


WebProvisioningParser* web_provisioning_parser_construct (GType object_type, const char* path) {
	WebProvisioningParser* self = (WebProvisioningParser*) g_type_create_instance (object_type);
	char* _tmp0_;
	char* _tmp1_;
	GFile* file;
	GMarkupParser _tmp8_ = {0};
	GError * _inner_error_ = NULL;
	g_return_val_if_fail (path != NULL, NULL);
	self->priv->text = (_tmp0_ = g_strdup (""), _g_free0 (self->priv->text), _tmp0_);
	self->priv->path = (_tmp1_ = g_strdup (path), _g_free0 (self->priv->path), _tmp1_);
	file = g_file_new_for_path (path);
	{
		GFileInputStream* _tmp2_;
		GFileInputStream* _tmp3_;
		GDataInputStream* _tmp4_;
		GDataInputStream* dis;
		char* line;
		_tmp2_ = g_file_read (file, NULL, &_inner_error_);
		if (_inner_error_ != NULL) {
			goto __catch5_g_error;
		}
		dis = (_tmp4_ = g_data_input_stream_new ((GInputStream*) (_tmp3_ = _tmp2_)), _g_object_unref0 (_tmp3_), _tmp4_);
		line = NULL;
		while (TRUE) {
			char* _tmp5_;
			char* _tmp6_;
			char* _tmp7_;
			_tmp5_ = g_data_input_stream_read_line (dis, NULL, NULL, &_inner_error_);
			if (_inner_error_ != NULL) {
				_g_free0 (line);
				_g_object_unref0 (dis);
				goto __catch5_g_error;
			}
			if (!((line = (_tmp6_ = _tmp5_, _g_free0 (line), _tmp6_)) != NULL)) {
				break;
			}
			self->priv->text = (_tmp7_ = g_strconcat (self->priv->text, line, NULL), _g_free0 (self->priv->text), _tmp7_);
		}
		_g_free0 (line);
		_g_object_unref0 (dis);
	}
	goto __finally5;
	__catch5_g_error:
	{
		GError * e;
		e = _inner_error_;
		_inner_error_ = NULL;
		{
			g_error ("moonshot-provisioning-common.vala:218: Could not retreive file size");
			_g_error_free0 (e);
		}
	}
	__finally5:
	if (_inner_error_ != NULL) {
		_g_object_unref0 (file);
		g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
		g_clear_error (&_inner_error_);
		return NULL;
	}
	self->priv->parser = (_tmp8_.start_element = _web_provisioning_start_element_func_gmarkup_parser_start_element_func, _tmp8_.end_element = NULL, _tmp8_.text = _web_provisioning_text_element_func_gmarkup_parser_text_func, _tmp8_.passthrough = NULL, _tmp8_.error = NULL, _tmp8_);
	_g_object_unref0 (file);
	return self;
}


WebProvisioningParser* web_provisioning_parser_new (const char* path) {
	return web_provisioning_parser_construct (WEB_PROVISIONING_TYPE_PARSER, path);
}


static glong string_get_length (const char* self) {
	glong result;
	g_return_val_if_fail (self != NULL, 0L);
	result = g_utf8_strlen (self, (gssize) (-1));
	return result;
}


void web_provisioning_parser_parse (WebProvisioningParser* self) {
	GMarkupParseContext* ctx;
	GError * _inner_error_ = NULL;
	g_return_if_fail (self != NULL);
	ctx = g_markup_parse_context_new (&self->priv->parser, 0, NULL, NULL);
	{
		g_markup_parse_context_parse (ctx, self->priv->text, (gssize) string_get_length (self->priv->text), &_inner_error_);
		if (_inner_error_ != NULL) {
			goto __catch6_g_error;
		}
	}
	goto __finally6;
	__catch6_g_error:
	{
		GError * e;
		e = _inner_error_;
		_inner_error_ = NULL;
		{
			g_error ("moonshot-provisioning-common.vala:235: Could not parse %s, invalid con" \
"tent", self->priv->path);
			_g_error_free0 (e);
		}
	}
	__finally6:
	if (_inner_error_ != NULL) {
		_g_markup_parse_context_free0 (ctx);
		g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
		g_clear_error (&_inner_error_);
		return;
	}
	_g_markup_parse_context_free0 (ctx);
}


static void web_provisioning_value_parser_init (GValue* value) {
	value->data[0].v_pointer = NULL;
}


static void web_provisioning_value_parser_free_value (GValue* value) {
	if (value->data[0].v_pointer) {
		web_provisioning_parser_unref (value->data[0].v_pointer);
	}
}


static void web_provisioning_value_parser_copy_value (const GValue* src_value, GValue* dest_value) {
	if (src_value->data[0].v_pointer) {
		dest_value->data[0].v_pointer = web_provisioning_parser_ref (src_value->data[0].v_pointer);
	} else {
		dest_value->data[0].v_pointer = NULL;
	}
}


static gpointer web_provisioning_value_parser_peek_pointer (const GValue* value) {
	return value->data[0].v_pointer;
}


static gchar* web_provisioning_value_parser_collect_value (GValue* value, guint n_collect_values, GTypeCValue* collect_values, guint collect_flags) {
	if (collect_values[0].v_pointer) {
		WebProvisioningParser* object;
		object = collect_values[0].v_pointer;
		if (object->parent_instance.g_class == NULL) {
			return g_strconcat ("invalid unclassed object pointer for value type `", G_VALUE_TYPE_NAME (value), "'", NULL);
		} else if (!g_value_type_compatible (G_TYPE_FROM_INSTANCE (object), G_VALUE_TYPE (value))) {
			return g_strconcat ("invalid object type `", g_type_name (G_TYPE_FROM_INSTANCE (object)), "' for value type `", G_VALUE_TYPE_NAME (value), "'", NULL);
		}
		value->data[0].v_pointer = web_provisioning_parser_ref (object);
	} else {
		value->data[0].v_pointer = NULL;
	}
	return NULL;
}


static gchar* web_provisioning_value_parser_lcopy_value (const GValue* value, guint n_collect_values, GTypeCValue* collect_values, guint collect_flags) {
	WebProvisioningParser** object_p;
	object_p = collect_values[0].v_pointer;
	if (!object_p) {
		return g_strdup_printf ("value location for `%s' passed as NULL", G_VALUE_TYPE_NAME (value));
	}
	if (!value->data[0].v_pointer) {
		*object_p = NULL;
	} else if (collect_flags & G_VALUE_NOCOPY_CONTENTS) {
		*object_p = value->data[0].v_pointer;
	} else {
		*object_p = web_provisioning_parser_ref (value->data[0].v_pointer);
	}
	return NULL;
}


GParamSpec* web_provisioning_param_spec_parser (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags) {
	WebProvisioningParamSpecParser* spec;
	g_return_val_if_fail (g_type_is_a (object_type, WEB_PROVISIONING_TYPE_PARSER), NULL);
	spec = g_param_spec_internal (G_TYPE_PARAM_OBJECT, name, nick, blurb, flags);
	G_PARAM_SPEC (spec)->value_type = object_type;
	return G_PARAM_SPEC (spec);
}


gpointer web_provisioning_value_get_parser (const GValue* value) {
	g_return_val_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, WEB_PROVISIONING_TYPE_PARSER), NULL);
	return value->data[0].v_pointer;
}


void web_provisioning_value_set_parser (GValue* value, gpointer v_object) {
	WebProvisioningParser* old;
	g_return_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, WEB_PROVISIONING_TYPE_PARSER));
	old = value->data[0].v_pointer;
	if (v_object) {
		g_return_if_fail (G_TYPE_CHECK_INSTANCE_TYPE (v_object, WEB_PROVISIONING_TYPE_PARSER));
		g_return_if_fail (g_value_type_compatible (G_TYPE_FROM_INSTANCE (v_object), G_VALUE_TYPE (value)));
		value->data[0].v_pointer = v_object;
		web_provisioning_parser_ref (value->data[0].v_pointer);
	} else {
		value->data[0].v_pointer = NULL;
	}
	if (old) {
		web_provisioning_parser_unref (old);
	}
}


void web_provisioning_value_take_parser (GValue* value, gpointer v_object) {
	WebProvisioningParser* old;
	g_return_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, WEB_PROVISIONING_TYPE_PARSER));
	old = value->data[0].v_pointer;
	if (v_object) {
		g_return_if_fail (G_TYPE_CHECK_INSTANCE_TYPE (v_object, WEB_PROVISIONING_TYPE_PARSER));
		g_return_if_fail (g_value_type_compatible (G_TYPE_FROM_INSTANCE (v_object), G_VALUE_TYPE (value)));
		value->data[0].v_pointer = v_object;
	} else {
		value->data[0].v_pointer = NULL;
	}
	if (old) {
		web_provisioning_parser_unref (old);
	}
}


static void web_provisioning_parser_class_init (WebProvisioningParserClass * klass) {
	web_provisioning_parser_parent_class = g_type_class_peek_parent (klass);
	WEB_PROVISIONING_PARSER_CLASS (klass)->finalize = web_provisioning_parser_finalize;
	g_type_class_add_private (klass, sizeof (WebProvisioningParserPrivate));
}


static void web_provisioning_parser_instance_init (WebProvisioningParser * self) {
	self->priv = WEB_PROVISIONING_PARSER_GET_PRIVATE (self);
	self->ref_count = 1;
}


static void web_provisioning_parser_finalize (WebProvisioningParser* obj) {
	WebProvisioningParser * self;
	self = WEB_PROVISIONING_PARSER (obj);
	_g_free0 (self->priv->text);
	_g_free0 (self->priv->path);
}


GType web_provisioning_parser_get_type (void) {
	static volatile gsize web_provisioning_parser_type_id__volatile = 0;
	if (g_once_init_enter (&web_provisioning_parser_type_id__volatile)) {
		static const GTypeValueTable g_define_type_value_table = { web_provisioning_value_parser_init, web_provisioning_value_parser_free_value, web_provisioning_value_parser_copy_value, web_provisioning_value_parser_peek_pointer, "p", web_provisioning_value_parser_collect_value, "p", web_provisioning_value_parser_lcopy_value };
		static const GTypeInfo g_define_type_info = { sizeof (WebProvisioningParserClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) web_provisioning_parser_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (WebProvisioningParser), 0, (GInstanceInitFunc) web_provisioning_parser_instance_init, &g_define_type_value_table };
		static const GTypeFundamentalInfo g_define_type_fundamental_info = { (G_TYPE_FLAG_CLASSED | G_TYPE_FLAG_INSTANTIATABLE | G_TYPE_FLAG_DERIVABLE | G_TYPE_FLAG_DEEP_DERIVABLE) };
		GType web_provisioning_parser_type_id;
		web_provisioning_parser_type_id = g_type_register_fundamental (g_type_fundamental_next (), "WebProvisioningParser", &g_define_type_info, &g_define_type_fundamental_info, 0);
		g_once_init_leave (&web_provisioning_parser_type_id__volatile, web_provisioning_parser_type_id);
	}
	return web_provisioning_parser_type_id__volatile;
}


gpointer web_provisioning_parser_ref (gpointer instance) {
	WebProvisioningParser* self;
	self = instance;
	g_atomic_int_inc (&self->ref_count);
	return instance;
}


void web_provisioning_parser_unref (gpointer instance) {
	WebProvisioningParser* self;
	self = instance;
	if (g_atomic_int_dec_and_test (&self->ref_count)) {
		WEB_PROVISIONING_PARSER_GET_CLASS (self)->finalize (self);
		g_type_free_instance ((GTypeInstance *) self);
	}
}


static void _vala_array_destroy (gpointer array, gint array_length, GDestroyNotify destroy_func) {
	if ((array != NULL) && (destroy_func != NULL)) {
		int i;
		for (i = 0; i < array_length; i = i + 1) {
			if (((gpointer*) array)[i] != NULL) {
				destroy_func (((gpointer*) array)[i]);
			}
		}
	}
}


static void _vala_array_free (gpointer array, gint array_length, GDestroyNotify destroy_func) {
	_vala_array_destroy (array, array_length, destroy_func);
	g_free (array);
}


static gint _vala_array_length (gpointer array) {
	int length;
	length = 0;
	if (array) {
		while (((gpointer*) array)[length]) {
			length++;
		}
	}
	return length;
}


static int _vala_strcmp0 (const char * str1, const char * str2) {
	if (str1 == NULL) {
		return -(str1 != str2);
	}
	if (str2 == NULL) {
		return str1 != str2;
	}
	return strcmp (str1, str2);
}




