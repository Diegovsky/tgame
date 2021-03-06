#include <gio/gio.h>
#include <stdio.h>
#include <strings.h>
#include "osutils.h"

#ifdef DEBUG
#define log(prefix, fmt, ...) fprintf(stderr, "[" prefix "] File " __FILE__ ":%d (%s): " fmt "\n", __LINE__, __func__, ##__VA_ARGS__) 
#else
#define log(_p, _f, ...);;
#endif
#define log_error(fmt, ...) log("Error", fmt, ##__VA_ARGS__)
#define log_info(fmt, ...) log("Info", fmt, ##__VA_ARGS__)


typedef struct {
    gchar buf[512];
    gboolean found;
} cb_buf;

void response_callback(GDBusConnection* _con,
                       const gchar* _sender,
                       const gchar* _objpath,
                       const gchar* _iface_name,
                       const gchar* _signame,
                       GVariant* args,
                       gpointer data)
{
    cb_buf* buf = data;
    log_info("Sender: %s\nPath: %s\nIface: %s\nSigname: %s\n", _sender, _objpath, _iface_name, _signame);
    if(g_variant_n_children(args) == 0)
    {
        log_error("Got wrong response.");
        return;
    }
    guint response = 0;
    g_variant_get_child(args, 0, "u", &response);
    if(response != 0) {
        log_info("User cancelled the interaction.");
        return;
    }
    GVariant* arg2 = g_variant_get_child_value(args, 1);
    if(arg2 == NULL)
    {
        log_error("Event did not have a second argument.");
        return;
    }
    GVariantDict dict;
    g_variant_dict_init(&dict, arg2);
    GVariant* selected = g_variant_dict_lookup_value(&dict, "uris", G_VARIANT_TYPE("as"));
    if(selected == NULL)
    {
        log_error("Did not find key URIS inside variant.");
        g_variant_dict_clear(&dict);
        return;
    }
    const gchar* tempbuf = NULL;
    g_variant_get_child(selected, 0, "s", &tempbuf);
    if(tempbuf == NULL)
    {
        log_error("Could not extract path string from buffer.");
        g_variant_dict_clear(&dict);
        return;
    }
    GError* err = NULL;
    const gchar* tempbuf_decoded = g_filename_from_uri(tempbuf, NULL, &err);
    if(tempbuf_decoded == NULL)
    {
        log_error("Could not convert URI to usable filename.");
        g_variant_dict_clear(&dict);
        return;
    }
    strncpy(buf->buf, tempbuf_decoded, 511);
    buf->buf[511] = 0;
    buf->found = TRUE;
    g_variant_dict_clear(&dict);
    g_free((gpointer)tempbuf_decoded);
}

static GVariant* _filter_to_vardict(const OSUtilsOpenfileFilter* filter)
{
    static GVariantBuilder builder;
    g_variant_builder_init(&builder, G_VARIANT_TYPE("a(us)"));
    for(int i = 0; filter->exts[i][0] != 0 && i < 4; i++)
    {
        g_variant_builder_add(&builder, "(us)", 0, filter->exts[i]);
    }
    GVariant* result = g_variant_builder_end(&builder);
    return g_variant_new("(s@a(us))", filter->name, result);
}

const char* openfile_dialog(const char* path, const OSUtilsOpenfileFilter* filter)
{
    static cb_buf data = {0};
    static GVariantBuilder builder;
    GDBusConnection* con = g_bus_get_sync(G_BUS_TYPE_SESSION, NULL, NULL);
    GError* err = NULL;
    // Build the outermost vardict argument. The XDG Desktop Portal DBus
    // interface uses vardicts a lot.
    g_variant_builder_init(&builder, G_VARIANT_TYPE("a{sv}"));
    GVariant* vardict_args = _filter_to_vardict(filter);
    g_variant_builder_add(&builder, "{sv}", "current_filter", vardict_args);
    g_variant_builder_add(&builder, "{sv}", "multiple", g_variant_new_boolean(TRUE));
    GVariant* result = g_dbus_connection_call_sync(
            con,
            "org.freedesktop.portal.Desktop",
            "/org/freedesktop/portal/desktop",
            "org.freedesktop.portal.FileChooser",
            "OpenFile",
            g_variant_new("(ss@a{sv})",
                          // Since we don't have a compliant window name, leave
                          // it empty.
                          "", 
                          "Open File",
                          g_variant_builder_end(&builder)),
            G_VARIANT_TYPE("(o)"),
            G_DBUS_CALL_FLAGS_NO_AUTO_START,
            500,
            NULL,
            &err);
    if(result == NULL)
    {
        log_error("Did not get a response");
        log_error("GError: %s", err->message);
        return NULL;
    }
    if(!g_variant_is_container(result))
    {
        log_error("DBus response wasn't a container!");
        g_variant_unref(result);
        g_object_unref(con);
        return NULL;
    }
    GVariant* result2 = g_variant_get_child_value(result, 0);
    gsize strsize = 0;
    const char* response_path = g_variant_get_string(result2, &strsize);
    data.found = FALSE;
    guint sub_id = g_dbus_connection_signal_subscribe(con, NULL, "org.freedesktop.portal.Request", "Response", response_path, NULL, G_DBUS_SIGNAL_FLAGS_NONE,  response_callback, &data, NULL);

    g_dbus_connection_flush_sync(con, NULL, NULL);

    GMainContext* ctx = g_main_context_default();
    while(!g_main_context_iteration(ctx, TRUE));

    g_dbus_connection_signal_unsubscribe(con, sub_id);

    g_variant_unref(result2);
    g_variant_unref(result);
    g_object_unref(con);
    log_info("Buffer: %s", data.buf);
    if(data.found)
    {
        return data.buf;
    }
    else
    {
        return NULL;
    }
}
