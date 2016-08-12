#include <string.h>
#include <openssl/bio.h>
#include <openssl/pem.h>


char* get_cert_valid_before(const char* cert_string, int cert_string_len, char* datebuf, int len)
{
    datebuf[0]='\0';    

    BIO* cert_bio = BIO_new_mem_buf(cert_string, cert_string_len);

    if (cert_bio == NULL) {
        return "Error calling PEM_new_mem_buf!";
    }

    X509 *x = PEM_read_bio_X509(cert_bio, NULL, 0, NULL);
    if (x == NULL) {
        return "Error calling PEM_read_bio_X509!";
    }

    BIO* out_bio = BIO_new(BIO_s_mem());
    ASN1_TIME* time = X509_get_notAfter(x);

    if (ASN1_TIME_print(out_bio, time)) {
        int write = BIO_read(out_bio, datebuf, len - 1);
        datebuf[write]='\0';
    }

    datebuf[len - 1] = '\0';
    BIO_free(out_bio);
    BIO_free(cert_bio);
    X509_free(x);
    return "";
}
