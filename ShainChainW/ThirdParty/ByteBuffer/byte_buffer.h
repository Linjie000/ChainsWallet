/*
 * Created by Alan Lei
 *
 * C implementation of Java ByteBuffer
 */
#ifndef BYTE_BUFFER_H_
#define BYTE_BUFFER_H_

#include <stdint.h>

typedef enum {
    BYTE_ORDER_BIG_ENDIAN = 0,
    BYTE_ORDER_LITTLE_ENDIAN = 1
} byte_order_t;

typedef struct {
    size_t limit;
    size_t position;
    size_t mark;
    size_t capacity;
    char *buffer;
    int isWrapped;
    size_t wrapped_offset;
    byte_order_t order;
} byte_buffer_t;


// Special functions not in Java ByteBuffer
byte_buffer_t *bb_create(size_t max);
void bb_destroy(byte_buffer_t *bb);

byte_buffer_t *bb_wrap(char *src, size_t offset, size_t length);

char *bb_array(byte_buffer_t *bb);
size_t bb_arrayOffset(byte_buffer_t *bb);
size_t bb_capacity(byte_buffer_t *bb);
byte_order_t bb_order(byte_buffer_t *bb);
void bb_order_set(byte_buffer_t *bb, byte_order_t order);

size_t bb_remaining(byte_buffer_t *bb);
int bb_hasRemaining(byte_buffer_t *bb);
size_t bb_position(byte_buffer_t *bb);
void bb_position_set(byte_buffer_t *bb, size_t pos);
size_t bb_limit(byte_buffer_t *bb);
void bb_limit_set(byte_buffer_t *bb, size_t pos);
void bb_flip(byte_buffer_t *bb);
void bb_clear(byte_buffer_t *bb);
void bb_rewind(byte_buffer_t *bb);
void bb_mark(byte_buffer_t *bb);
void bb_reset(byte_buffer_t *bb);
byte_buffer_t *bb_compact(byte_buffer_t *bb);

int bb_compareTo(byte_buffer_t *bb, byte_buffer_t *that);
int bb_equals(byte_buffer_t *bb, byte_buffer_t *that);

char bb_get(byte_buffer_t *bb);
char bb_get_index(byte_buffer_t *bb, size_t index);
void bb_get_buffer(byte_buffer_t *bb, char *dst, size_t offset, size_t length);

int16_t bb_getShort(byte_buffer_t *bb);
int16_t bb_getShort_index(byte_buffer_t *bb, size_t index);
int32_t bb_getInt(byte_buffer_t *bb);
int32_t bb_getInt_index(byte_buffer_t *bb, size_t index);
int64_t bb_getLong(byte_buffer_t *bb);
int64_t bb_getLong_index(byte_buffer_t *bb, size_t index);

void bb_put(byte_buffer_t *bb, char c);
void bb_put_index(byte_buffer_t *bb, size_t index, char c);
void bb_put_buffer(byte_buffer_t *bb, char *src, size_t offset, size_t length);
void bb_put_bb(byte_buffer_t *bb, byte_buffer_t *src);

void bb_putShort(byte_buffer_t *bb, int16_t value);
void bb_putShort_index(byte_buffer_t *bb,  size_t index, int16_t value);
void bb_putInt(byte_buffer_t *bb, int32_t value);
void bb_putInt_index(byte_buffer_t *bb,  size_t index, int32_t value);
void bb_putLong(byte_buffer_t *bb, int64_t value);
void bb_putLong_index(byte_buffer_t *bb,  size_t index, int64_t value);

#endif /*BYTE_BUFFER_H_*/
