/*
 * Created by Alan Lei
 *
 * C implementation of Java ByteBuffer
 */
#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <assert.h>
#include "byte_buffer.h"

byte_buffer_t *bb_create(size_t max) {
    byte_buffer_t *bb = (byte_buffer_t *)malloc(sizeof(byte_buffer_t));
    memset(bb, 0, sizeof(byte_buffer_t));
    bb_clear(bb);
    bb->capacity = max;
    bb->mark = -1;
    bb->position = 0;
    bb->limit = max;
    bb->buffer = (char*)malloc(bb->capacity);
    if (bb->buffer == NULL) {
        printf("allocate problem\n");
    }
    bb->isWrapped = 0;
    bb->order = BYTE_ORDER_BIG_ENDIAN;
    return bb;
}

byte_buffer_t *bb_wrap(char *src, size_t offset, size_t length) {
    byte_buffer_t *bb = (byte_buffer_t *)malloc(sizeof(byte_buffer_t));
    memset(bb, 0, sizeof(byte_buffer_t));
    bb_clear(bb);
    bb->isWrapped = 1;
    bb->buffer = src + offset;
    bb->wrapped_offset = offset;
    bb->limit = bb->capacity = length;
    bb->order = BYTE_ORDER_BIG_ENDIAN;
    return bb;
}

void bb_destroy(byte_buffer_t *bb) {
    if (!bb->isWrapped) {
        free(bb->buffer);
    }
    free(bb);
}


size_t bb_capacity(byte_buffer_t *bb) {
    return bb->capacity;
}

byte_order_t bb_order(byte_buffer_t *bb) {
    return bb->order;
}

void bb_order_set(byte_buffer_t *bb, byte_order_t order) {
    bb->order = order;
}

byte_buffer_t *bb_compact(byte_buffer_t *bb) {
    size_t remain = bb_remaining(bb);
    if (bb->position > 0) {
        memcpy(bb->buffer, bb->buffer + bb->position, remain);
    }
    bb->position = remain;
    bb->limit = bb->capacity;
    bb->mark = -1;
    return bb;
}


void bb_clear(byte_buffer_t *bb) {
    bb->position = 0;
    bb->limit = bb->capacity;
    bb->mark = -1;
}

void bb_rewind(byte_buffer_t *bb) {
    bb->position = 0;
}

void bb_flip(byte_buffer_t *bb) {
    bb->limit = bb->position;
    bb->position = 0;
}

size_t bb_limit(byte_buffer_t *bb) {
    return bb->limit;
}

void bb_limit_set(byte_buffer_t *bb, size_t pos) {
    assert(pos >= 0);
    assert(pos <= bb->capacity);
    bb->limit = pos;
    if (bb->position > pos) bb->position = pos;
    if (bb->mark > pos) bb->mark = -1;
}

size_t bb_position(byte_buffer_t *bb) {
    return bb->position;
}

void bb_position_set(byte_buffer_t *bb, size_t pos) {
    assert(pos >= 0);
    assert(pos <= bb->limit);
    bb->position = pos;
    if (bb->mark > pos) bb->mark = -1;
}

char *bb_array(byte_buffer_t *bb) {
    return bb->buffer;
}

size_t bb_arrayOffset(byte_buffer_t *bb) {
    return bb->wrapped_offset + bb->position;
}

size_t bb_remaining(byte_buffer_t *bb) {
    return bb->limit - bb->position;
}

int bb_hasRemaining(byte_buffer_t *bb) {
    return (bb_remaining(bb) > 0);
}

void bb_mark(byte_buffer_t *bb) {
    bb->mark = bb->position;
}

void bb_reset(byte_buffer_t *bb) {
    assert(bb->mark != -1);
    bb->position = bb->mark;
}

int bb_compareTo(byte_buffer_t *bb, byte_buffer_t *that) {
    size_t bb_pos = bb_position(bb);
    size_t that_pos = bb_position(that);
    
    while ((bb_pos < bb->limit) && (that_pos < that->limit)) {
        if (bb->buffer[bb_pos] > that->buffer[that_pos]) return 1;
        else if (bb->buffer[bb_pos] < that->buffer[that_pos]) return -1;
        bb_pos++;
        that_pos++;
    }
    if (bb_pos < bb->limit) return 1;
    else if (that_pos < that->limit) return -1;
    return 0;
}

int bb_equals(byte_buffer_t *bb, byte_buffer_t *that) {
    return (bb_compareTo(bb, that) == 0);
}


char bb_get(byte_buffer_t *bb) {
    size_t pos = bb->position;
    bb->position++;
    return bb->buffer[pos];
}

char bb_get_index(byte_buffer_t *bb, size_t index) {
    assert(index >= 0);
    assert(index < bb->capacity);
    return bb->buffer[index];
}

void bb_get_buffer(byte_buffer_t *bb, char *dst, size_t offset, size_t length) {
    assert(offset >= 0);
    assert(length >= 0);
    assert(bb_remaining(bb) >= length);
    memcpy(dst + offset, bb->buffer + bb->position, length);
    bb->position += length;
}

int16_t bb_getShort(byte_buffer_t *bb) {
    int16_t value = bb_getShort_index(bb, bb->position);
    bb->position += 2;
    return value;
}

int16_t bb_getShort_index(byte_buffer_t *bb, size_t index) {
    assert(index + 2 <= bb->limit);
    
    int16_t value;
    if (bb->order == BYTE_ORDER_BIG_ENDIAN) {
        value = (bb->buffer[index] & 0xFF) << 8;
        value |= (bb->buffer[index + 1] & 0xFF);
    }
    else {
        value = (bb->buffer[index + 1] & 0xFF) << 8;
        value |= (bb->buffer[index] & 0xFF);
    }
    return value;
}

int32_t bb_getInt(byte_buffer_t *bb) {
    int32_t value = bb_getInt_index(bb, bb->position);
    bb->position += 4;
    return value;
}

int32_t bb_getInt_index(byte_buffer_t *bb, size_t index) {
    assert((index + 4) <= bb->limit);
    
    int32_t value;
    if (bb->order == BYTE_ORDER_BIG_ENDIAN) {
        value = (bb->buffer[index] & 0xFF) << 24;
        value |= (bb->buffer[index + 1] & 0xFF) << 16;
        value |= (bb->buffer[index + 2] & 0xFF) << 8;
        value |= bb->buffer[index + 3] & 0xFF;
    }
    else {
        value = (bb->buffer[index + 3] & 0xFF) << 24;
        value |= (bb->buffer[index + 2] & 0xFF) << 16;
        value |= (bb->buffer[index + 1] & 0xFF) << 8;
        value |= bb->buffer[index] & 0xFF;
    }
    return value;
}

int64_t bb_getLong(byte_buffer_t *bb) {
    int64_t value = bb_getLong_index(bb, bb->position);
    bb->position += 8;
    return value;
}

int64_t bb_getLong_index(byte_buffer_t *bb, size_t index) {
    assert((index + 8) <= bb->limit);
    
    int64_t value;
    if (bb->order == BYTE_ORDER_BIG_ENDIAN) {
        value = ((int64_t)bb->buffer[index] & 0xFF) << 56;
        value |= ((int64_t)bb->buffer[index + 1] & 0xFF) << 48;
        value |= ((int64_t)bb->buffer[index + 2] & 0xFF) << 40;
        value |= ((int64_t)bb->buffer[index + 3] & 0xFF) << 32;
        value |= (bb->buffer[index + 4] & 0xFF) << 24;
        value |= (bb->buffer[index + 5] & 0xFF) << 16;
        value |= (bb->buffer[index + 6] & 0xFF) << 8;
        value |= (bb->buffer[index + 7] & 0xFF);
    }
    else {
        value = ((int64_t)bb->buffer[index + 7] & 0xFF) << 56;
        value |= ((int64_t)bb->buffer[index + 6] & 0xFF) << 48;
        value |= ((int64_t)bb->buffer[index + 5] & 0xFF) << 40;
        value |= ((int64_t)bb->buffer[index + 4] & 0xFF) << 32;
        value |= (bb->buffer[index + 3] & 0xFF) << 24;
        value |= (bb->buffer[index + 2] & 0xFF) << 16;
        value |= (bb->buffer[index + 1] & 0xFF) << 8;
        value |= (bb->buffer[index] & 0xFF);
    }
    return value;
}


void bb_put(byte_buffer_t *bb, char c) {
    assert(bb->position < bb->limit);
    bb->buffer[bb->position] = c;
    bb->position++;
    if (bb->position > bb->limit) bb->limit = bb->position;
}

void bb_put_index(byte_buffer_t *bb, size_t index, char c) {
    assert(index < bb->capacity);
    bb->buffer[index] = c;
}

void bb_put_bb(byte_buffer_t *bb, byte_buffer_t *src) {
    assert(bb_remaining(bb) >= bb_remaining(src));
    while (bb_remaining(src) > 0) {
        bb_put(bb, bb_get(src));
    }
}

void bb_put_buffer(byte_buffer_t *bb, char *src, size_t offset, size_t length) {
    assert((bb->position + length) < bb->limit);
    memcpy(bb->buffer + bb->position, src + offset, length);
    bb->position += length;
    if (bb->position > bb->limit) bb->limit = bb->position;
}

void bb_putShort(byte_buffer_t *bb, int16_t value) {
    bb_putShort_index(bb, bb->position, value);
    bb->position += 2;
}

void bb_putShort_index(byte_buffer_t *bb, size_t index, int16_t value) {
    assert((index + 2) <= bb->limit);
    if (bb->order == BYTE_ORDER_BIG_ENDIAN) {
        bb->buffer[index] = (value >> 8) & 0xFF;
        bb->buffer[index + 1] = value & 0xFF;
    }
    else {
        bb->buffer[index + 1] = (value >> 8) & 0xFF;
        bb->buffer[index] = value & 0xFF;
    }
}

void bb_putInt(byte_buffer_t *bb, int32_t value) {
    bb_putInt_index(bb, bb->position, value);
    bb->position += 4;
}

void bb_putInt_index(byte_buffer_t *bb, size_t index, int32_t value) {
    assert((index + 4) <= bb->limit);
    
    if (bb->order == BYTE_ORDER_BIG_ENDIAN) {
        bb->buffer[index] = (value >> 24) & 0xFF;
        bb->buffer[index + 1] = (value >> 16) & 0xFF;
        bb->buffer[index + 2] = (value >> 8) & 0xFF;
        bb->buffer[index + 3] = value & 0xFF;
    }
    else {
        bb->buffer[index + 3] = (value >> 24) & 0xFF;
        bb->buffer[index + 2] = (value >> 16) & 0xFF;
        bb->buffer[index + 1] = (value >> 8) & 0xFF;
        bb->buffer[index] = value & 0xFF;
    }
}

void bb_putLong(byte_buffer_t *bb, int64_t value) {
    bb_putLong_index(bb, bb->position, value);
    bb->position += 8;
}

void bb_putLong_index(byte_buffer_t *bb, size_t index, int64_t value) {
    assert((index + 8) <= bb->limit);
    
    if (bb->order == BYTE_ORDER_BIG_ENDIAN) {
        bb->buffer[index] = (value >> 56) & 0xFF;
        bb->buffer[index + 1] = (value >> 48) & 0xFF;
        bb->buffer[index + 2] = (value >> 40) & 0xFF;
        bb->buffer[index + 3] = (value >> 32) & 0xFF;
        bb->buffer[index + 4] = (value >> 24) & 0xFF;
        bb->buffer[index + 5] = (value >> 16) & 0xFF;
        bb->buffer[index + 6] = (value >> 8) & 0xFF;
        bb->buffer[index + 7] = value & 0xFF;
    }
    else {
        bb->buffer[index + 7] = (value >> 56) & 0xFF;
        bb->buffer[index + 6] = (value >> 48) & 0xFF;
        bb->buffer[index + 5] = (value >> 40) & 0xFF;
        bb->buffer[index + 4] = (value >> 32) & 0xFF;
        bb->buffer[index + 3] = (value >> 24) & 0xFF;
        bb->buffer[index + 2] = (value >> 16) & 0xFF;
        bb->buffer[index + 1] = (value >> 8) & 0xFF;
        bb->buffer[index] = value & 0xFF;
    }
}
