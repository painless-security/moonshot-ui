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

public class TrustAnchor : Object
{
    public enum TrustAnchorType {
        CA_CERT,
        SERVER_CERT
    }
 
    private string _ca_cert = "";
    private string _subject = "";
    private string _subject_alt = "";
    private string _server_cert = "";

    public string ca_cert {
        get {
            return _ca_cert;
        }
        set {
            _ca_cert = (value ?? "");
        }
    }

    public string subject {
        get {
            return _subject;
        }
        set {
            _subject = (value ?? "");
        }
    }

    public string subject_alt  {
        get {
            return _subject_alt;
        }
        set {
            _subject_alt = (value ?? "");
        }
    }


    public string server_cert {
        get {
            return _server_cert;
        }
        set {
            _server_cert = (value ?? "");
        }
    }

    public bool is_empty() {
        return ca_cert == "" && subject == "" && subject_alt == "" && server_cert == "";
    }

    public TrustAnchorType get_anchor_type() {
        return server_cert == "" ? TrustAnchorType.CA_CERT : TrustAnchorType.SERVER_CERT;
    }

    public int Compare(TrustAnchor other)
    {
        if (this.ca_cert != other.ca_cert)
            return 1;
        if (this.subject != other.subject)
            return 1;
        if (this.subject_alt != other.subject_alt)
            return 1;
        if (this.server_cert != other.server_cert)
            return 1;
        return 0;
    }

    public string? get_expiration_date()
    {
        if (this.ca_cert == "") {
            return null;
        }

        //!!TODO read expiration date
        return "";
    }
}

public struct Rule
{
    public string pattern;
    public string always_confirm;
    public int Compare(Rule other) {
        if (this.pattern != other.pattern)
            return 1;
        if (this.always_confirm != other.always_confirm)
            return 1;
        return 0;
    }
}

public class IdCard : Object
{
    static MoonshotLogger logger = get_logger("IdCard");

    public const string NO_IDENTITY = "No Identity";

    private string _nai;
  
    public string display_name { get; set; default = ""; }
  
    public string username { get; set; default = ""; }
#if GNOME_KEYRING
    private unowned string _password;
    public string password {
        get {
            return (_password!=null) ? _password : "";
        }
        set {
            if (_password != null) {
                GnomeKeyring.memory_free((void *)_password);
                _password = null;
            }
            if (value != null)
                _password = GnomeKeyring.memory_strdup(value); 
        }
    }
#else
    public string password { get; set; default = null; }
#endif

    public string issuer { get; set; default = ""; }
  
    private Rule[] _rules = new Rule[0];
    public Rule[] rules {
        get {return _rules;}
        internal set {_rules = value ?? new Rule[0] ;}
    }

    private ArrayList<string> _services = new ArrayList<string>();

    internal ArrayList<string> services {
         get {return  _services;}
    }

    // Returns the list of services as a string, using the given separator.
    internal string get_services_string(string sep) {
        if (_services.is_empty) {
            return "";
        }

        // ArrayList.to_array() seems to be unreliable -- it causes segfaults 
        // semi-randomly. (Possibly because it returns an unowned ref?)
        // return string.joinv(sep, _services.to_array());
        // 
        // This problem may be related to the one noted elsewhere as the
        // "Centos vala array property bug".

        string[] svcs = new string[_services.size];
        for (int i = 0; i < _services.size; i++) {
            svcs[i] = _services[i];
        }

        return string.joinv(sep, svcs);
    }

    internal void update_services(string[] services) {
        _services.clear();

        // Doesn't exist in older versions of libgee:
        // _services.add_all_array(services);

        if (services != null) {
            foreach (string s in services) {
                _services.add(s);
            }
        }
    } 

    internal void update_services_from_list(ArrayList<string> services) {
        if (services == this._services) {
            // Don't try to update from self.
            return;
        }

        _services.clear();

        if (services != null) {
            _services.add_all(services);
        }
    } 


    public bool temporary {get; set; default = false; }

    public TrustAnchor trust_anchor  { get; set; default = new TrustAnchor (); }
  
    public unowned string nai { get {  _nai = username + "@" + issuer; return _nai;}}

    public bool store_password { get; set; default = false; }

    public bool is_no_identity() 
    {
        return (display_name == NO_IDENTITY);
    }

    public enum DiffFlags {
        DISPLAY_NAME,
        USERNAME,
        PASSWORD,
        ISSUER,
        RULES,
        SERVICES,
        TRUST_ANCHOR;
    }

    public int Compare(IdCard other)
    {
        int diff = 0;
        if (this.display_name != other.display_name)
            diff |= 1 << DiffFlags.DISPLAY_NAME;

        if (this.username != other.username)
            diff |= 1 << DiffFlags.USERNAME;

        if (this.password != other.password)
            diff |= 1 << DiffFlags.PASSWORD;

        if (this.issuer != other.issuer)
            diff |= 1 << DiffFlags.ISSUER;

        if (CompareRules(this.rules, other.rules)!=0)
            diff |= 1 << DiffFlags.RULES;

        if (CompareStringArrayList(this._services, other._services)!=0)
            diff |= 1 << DiffFlags.SERVICES;

        if (this.trust_anchor.Compare(other.trust_anchor)!=0)
            diff |= 1 << DiffFlags.TRUST_ANCHOR;

        // stdout.printf("Diff Flags: %x\n", diff);
        return diff;
    }

    public static IdCard NewNoIdentity() 
    { 
        IdCard card = new IdCard();
        card.display_name = NO_IDENTITY;
        return card;
    }

    ~IdCard() {
        password = null;
    }

    internal void add_rule(Rule rule) {
        _rules += rule;
    }
}

public int CompareRules(Rule[] a, Rule[] b)
{
    if (a.length != b.length) {
        return 1;
    }

    for (int i = 0; i < a.length; i++) {
        if (a[i].Compare(b[i]) != 0) {
            return 1;
        }
    }
    return 0;
}

public int CompareStringArrayList(ArrayList<string> a, ArrayList<string> b)
{
    if (a.size != b.size) {
        return 1;
    }

    for (int i = 0; i < a.size; i++) {
        if (a[i] != b[i]) {
            return 1;
        }
    }
    return 0;
}
