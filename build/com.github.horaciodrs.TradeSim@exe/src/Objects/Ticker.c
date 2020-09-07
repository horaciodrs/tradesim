/* Ticker.c generated by valac 0.40.23, the Vala compiler
 * generated from Ticker.vala, do not modify */

/*
 * Copyright (c) 2020-2020 horaciodrs (https://github.com/horaciodrs/TradeSim)
 *
 * This file is part of TradeSim.
 *
 * TradeSim is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * TradeSim is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with Akira. If not, see <https://www.gnu.org/licenses/>.
 *
 * Authored by: Horacio Daniel Ros <horaciodrs@gmail.com>
 */


#include <glib.h>
#include <glib-object.h>
#include <stdlib.h>
#include <string.h>
#include <gobject/gvaluecollector.h>


#define TRADE_SIM_OBJECTS_TYPE_TICKER (trade_sim_objects_ticker_get_type ())
#define TRADE_SIM_OBJECTS_TICKER(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TRADE_SIM_OBJECTS_TYPE_TICKER, TradeSimObjectsTicker))
#define TRADE_SIM_OBJECTS_TICKER_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TRADE_SIM_OBJECTS_TYPE_TICKER, TradeSimObjectsTickerClass))
#define TRADE_SIM_OBJECTS_IS_TICKER(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TRADE_SIM_OBJECTS_TYPE_TICKER))
#define TRADE_SIM_OBJECTS_IS_TICKER_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TRADE_SIM_OBJECTS_TYPE_TICKER))
#define TRADE_SIM_OBJECTS_TICKER_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TRADE_SIM_OBJECTS_TYPE_TICKER, TradeSimObjectsTickerClass))

typedef struct _TradeSimObjectsTicker TradeSimObjectsTicker;
typedef struct _TradeSimObjectsTickerClass TradeSimObjectsTickerClass;
typedef struct _TradeSimObjectsTickerPrivate TradeSimObjectsTickerPrivate;
#define _g_free0(var) (var = (g_free (var), NULL))
typedef struct _TradeSimObjectsParamSpecTicker TradeSimObjectsParamSpecTicker;

struct _TradeSimObjectsTicker {
	GTypeInstance parent_instance;
	volatile int ref_count;
	TradeSimObjectsTickerPrivate * priv;
	gint id;
	gchar* name;
};

struct _TradeSimObjectsTickerClass {
	GTypeClass parent_class;
	void (*finalize) (TradeSimObjectsTicker *self);
};

struct _TradeSimObjectsParamSpecTicker {
	GParamSpec parent_instance;
};


static gpointer trade_sim_objects_ticker_parent_class = NULL;

gpointer trade_sim_objects_ticker_ref (gpointer instance);
void trade_sim_objects_ticker_unref (gpointer instance);
GParamSpec* trade_sim_objects_param_spec_ticker (const gchar* name,
                                                 const gchar* nick,
                                                 const gchar* blurb,
                                                 GType object_type,
                                                 GParamFlags flags);
void trade_sim_objects_value_set_ticker (GValue* value,
                                         gpointer v_object);
void trade_sim_objects_value_take_ticker (GValue* value,
                                          gpointer v_object);
gpointer trade_sim_objects_value_get_ticker (const GValue* value);
GType trade_sim_objects_ticker_get_type (void) G_GNUC_CONST;
TradeSimObjectsTicker* trade_sim_objects_ticker_new (gint _id,
                                                     const gchar* _name);
TradeSimObjectsTicker* trade_sim_objects_ticker_construct (GType object_type,
                                                           gint _id,
                                                           const gchar* _name);
static void trade_sim_objects_ticker_finalize (TradeSimObjectsTicker * obj);


TradeSimObjectsTicker*
trade_sim_objects_ticker_construct (GType object_type,
                                    gint _id,
                                    const gchar* _name)
{
	TradeSimObjectsTicker* self = NULL;
	gchar* _tmp0_;
#line 27 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	g_return_val_if_fail (_name != NULL, NULL);
#line 27 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	self = (TradeSimObjectsTicker*) g_type_create_instance (object_type);
#line 28 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	self->id = _id;
#line 29 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	_tmp0_ = g_strdup (_name);
#line 29 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	_g_free0 (self->name);
#line 29 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	self->name = _tmp0_;
#line 27 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	return self;
#line 109 "Ticker.c"
}


TradeSimObjectsTicker*
trade_sim_objects_ticker_new (gint _id,
                              const gchar* _name)
{
#line 27 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	return trade_sim_objects_ticker_construct (TRADE_SIM_OBJECTS_TYPE_TICKER, _id, _name);
#line 119 "Ticker.c"
}


static void
trade_sim_objects_value_ticker_init (GValue* value)
{
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	value->data[0].v_pointer = NULL;
#line 128 "Ticker.c"
}


static void
trade_sim_objects_value_ticker_free_value (GValue* value)
{
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	if (value->data[0].v_pointer) {
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		trade_sim_objects_ticker_unref (value->data[0].v_pointer);
#line 139 "Ticker.c"
	}
}


static void
trade_sim_objects_value_ticker_copy_value (const GValue* src_value,
                                           GValue* dest_value)
{
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	if (src_value->data[0].v_pointer) {
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		dest_value->data[0].v_pointer = trade_sim_objects_ticker_ref (src_value->data[0].v_pointer);
#line 152 "Ticker.c"
	} else {
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		dest_value->data[0].v_pointer = NULL;
#line 156 "Ticker.c"
	}
}


static gpointer
trade_sim_objects_value_ticker_peek_pointer (const GValue* value)
{
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	return value->data[0].v_pointer;
#line 166 "Ticker.c"
}


static gchar*
trade_sim_objects_value_ticker_collect_value (GValue* value,
                                              guint n_collect_values,
                                              GTypeCValue* collect_values,
                                              guint collect_flags)
{
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	if (collect_values[0].v_pointer) {
#line 178 "Ticker.c"
		TradeSimObjectsTicker * object;
		object = collect_values[0].v_pointer;
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		if (object->parent_instance.g_class == NULL) {
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
			return g_strconcat ("invalid unclassed object pointer for value type `", G_VALUE_TYPE_NAME (value), "'", NULL);
#line 185 "Ticker.c"
		} else if (!g_value_type_compatible (G_TYPE_FROM_INSTANCE (object), G_VALUE_TYPE (value))) {
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
			return g_strconcat ("invalid object type `", g_type_name (G_TYPE_FROM_INSTANCE (object)), "' for value type `", G_VALUE_TYPE_NAME (value), "'", NULL);
#line 189 "Ticker.c"
		}
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		value->data[0].v_pointer = trade_sim_objects_ticker_ref (object);
#line 193 "Ticker.c"
	} else {
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		value->data[0].v_pointer = NULL;
#line 197 "Ticker.c"
	}
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	return NULL;
#line 201 "Ticker.c"
}


static gchar*
trade_sim_objects_value_ticker_lcopy_value (const GValue* value,
                                            guint n_collect_values,
                                            GTypeCValue* collect_values,
                                            guint collect_flags)
{
	TradeSimObjectsTicker ** object_p;
	object_p = collect_values[0].v_pointer;
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	if (!object_p) {
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		return g_strdup_printf ("value location for `%s' passed as NULL", G_VALUE_TYPE_NAME (value));
#line 217 "Ticker.c"
	}
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	if (!value->data[0].v_pointer) {
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		*object_p = NULL;
#line 223 "Ticker.c"
	} else if (collect_flags & G_VALUE_NOCOPY_CONTENTS) {
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		*object_p = value->data[0].v_pointer;
#line 227 "Ticker.c"
	} else {
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		*object_p = trade_sim_objects_ticker_ref (value->data[0].v_pointer);
#line 231 "Ticker.c"
	}
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	return NULL;
#line 235 "Ticker.c"
}


GParamSpec*
trade_sim_objects_param_spec_ticker (const gchar* name,
                                     const gchar* nick,
                                     const gchar* blurb,
                                     GType object_type,
                                     GParamFlags flags)
{
	TradeSimObjectsParamSpecTicker* spec;
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	g_return_val_if_fail (g_type_is_a (object_type, TRADE_SIM_OBJECTS_TYPE_TICKER), NULL);
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	spec = g_param_spec_internal (G_TYPE_PARAM_OBJECT, name, nick, blurb, flags);
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	G_PARAM_SPEC (spec)->value_type = object_type;
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	return G_PARAM_SPEC (spec);
#line 255 "Ticker.c"
}


gpointer
trade_sim_objects_value_get_ticker (const GValue* value)
{
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	g_return_val_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, TRADE_SIM_OBJECTS_TYPE_TICKER), NULL);
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	return value->data[0].v_pointer;
#line 266 "Ticker.c"
}


void
trade_sim_objects_value_set_ticker (GValue* value,
                                    gpointer v_object)
{
	TradeSimObjectsTicker * old;
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	g_return_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, TRADE_SIM_OBJECTS_TYPE_TICKER));
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	old = value->data[0].v_pointer;
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	if (v_object) {
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		g_return_if_fail (G_TYPE_CHECK_INSTANCE_TYPE (v_object, TRADE_SIM_OBJECTS_TYPE_TICKER));
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		g_return_if_fail (g_value_type_compatible (G_TYPE_FROM_INSTANCE (v_object), G_VALUE_TYPE (value)));
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		value->data[0].v_pointer = v_object;
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		trade_sim_objects_ticker_ref (value->data[0].v_pointer);
#line 289 "Ticker.c"
	} else {
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		value->data[0].v_pointer = NULL;
#line 293 "Ticker.c"
	}
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	if (old) {
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		trade_sim_objects_ticker_unref (old);
#line 299 "Ticker.c"
	}
}


void
trade_sim_objects_value_take_ticker (GValue* value,
                                     gpointer v_object)
{
	TradeSimObjectsTicker * old;
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	g_return_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, TRADE_SIM_OBJECTS_TYPE_TICKER));
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	old = value->data[0].v_pointer;
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	if (v_object) {
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		g_return_if_fail (G_TYPE_CHECK_INSTANCE_TYPE (v_object, TRADE_SIM_OBJECTS_TYPE_TICKER));
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		g_return_if_fail (g_value_type_compatible (G_TYPE_FROM_INSTANCE (v_object), G_VALUE_TYPE (value)));
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		value->data[0].v_pointer = v_object;
#line 321 "Ticker.c"
	} else {
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		value->data[0].v_pointer = NULL;
#line 325 "Ticker.c"
	}
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	if (old) {
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		trade_sim_objects_ticker_unref (old);
#line 331 "Ticker.c"
	}
}


static void
trade_sim_objects_ticker_class_init (TradeSimObjectsTickerClass * klass)
{
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	trade_sim_objects_ticker_parent_class = g_type_class_peek_parent (klass);
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	((TradeSimObjectsTickerClass *) klass)->finalize = trade_sim_objects_ticker_finalize;
#line 343 "Ticker.c"
}


static void
trade_sim_objects_ticker_instance_init (TradeSimObjectsTicker * self)
{
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	self->ref_count = 1;
#line 352 "Ticker.c"
}


static void
trade_sim_objects_ticker_finalize (TradeSimObjectsTicker * obj)
{
	TradeSimObjectsTicker * self;
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	self = G_TYPE_CHECK_INSTANCE_CAST (obj, TRADE_SIM_OBJECTS_TYPE_TICKER, TradeSimObjectsTicker);
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	g_signal_handlers_destroy (self);
#line 25 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	_g_free0 (self->name);
#line 366 "Ticker.c"
}


GType
trade_sim_objects_ticker_get_type (void)
{
	static volatile gsize trade_sim_objects_ticker_type_id__volatile = 0;
	if (g_once_init_enter (&trade_sim_objects_ticker_type_id__volatile)) {
		static const GTypeValueTable g_define_type_value_table = { trade_sim_objects_value_ticker_init, trade_sim_objects_value_ticker_free_value, trade_sim_objects_value_ticker_copy_value, trade_sim_objects_value_ticker_peek_pointer, "p", trade_sim_objects_value_ticker_collect_value, "p", trade_sim_objects_value_ticker_lcopy_value };
		static const GTypeInfo g_define_type_info = { sizeof (TradeSimObjectsTickerClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) trade_sim_objects_ticker_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (TradeSimObjectsTicker), 0, (GInstanceInitFunc) trade_sim_objects_ticker_instance_init, &g_define_type_value_table };
		static const GTypeFundamentalInfo g_define_type_fundamental_info = { (G_TYPE_FLAG_CLASSED | G_TYPE_FLAG_INSTANTIATABLE | G_TYPE_FLAG_DERIVABLE | G_TYPE_FLAG_DEEP_DERIVABLE) };
		GType trade_sim_objects_ticker_type_id;
		trade_sim_objects_ticker_type_id = g_type_register_fundamental (g_type_fundamental_next (), "TradeSimObjectsTicker", &g_define_type_info, &g_define_type_fundamental_info, 0);
		g_once_init_leave (&trade_sim_objects_ticker_type_id__volatile, trade_sim_objects_ticker_type_id);
	}
	return trade_sim_objects_ticker_type_id__volatile;
}


gpointer
trade_sim_objects_ticker_ref (gpointer instance)
{
	TradeSimObjectsTicker * self;
	self = instance;
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	g_atomic_int_inc (&self->ref_count);
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	return instance;
#line 395 "Ticker.c"
}


void
trade_sim_objects_ticker_unref (gpointer instance)
{
	TradeSimObjectsTicker * self;
	self = instance;
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
	if (g_atomic_int_dec_and_test (&self->ref_count)) {
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		TRADE_SIM_OBJECTS_TICKER_GET_CLASS (self)->finalize (self);
#line 22 "/home/horacio/Vala/TradeSim/src/Objects/Ticker.vala"
		g_type_free_instance ((GTypeInstance *) self);
#line 410 "Ticker.c"
	}
}



