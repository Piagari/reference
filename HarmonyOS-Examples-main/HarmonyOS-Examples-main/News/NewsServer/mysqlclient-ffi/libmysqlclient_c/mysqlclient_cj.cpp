/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
#include "include/mysql.h"
#include <string.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct MYSQL_COLUMN_INFO
{
    char *name_string;
    enum enum_field_types type;
    unsigned int flags;
    int64_t display_size_int64;
    int64_t length_int64;
    int64_t scale_int64;
} MYSQL_COLUMN_INFO;

MYSQL *mysql_init_my(MYSQL *mysql)
{
    mysql_init(mysql);
    return mysql;
}

#ifndef _WIN32
extern int memcpy_s(void *dest, uint32_t destsz, const void *src, uint32_t count);
extern int strcpy_s(char *dest, uint32_t destsz, const char *src);
#endif

#define INT8_SIZE 1
#define INT16_SIZE 2
#define INT32_SIZE 4
#define INT64_SIZE 8

/*---------------------- 内部方法 ----------------------*/
bool set_bytes_blob_clob(MYSQL_BIND *bind, int64_t index, char *value, int64_t length)
{
    if (length == 0) {
        bind[index].buffer = NULL;
    } else {
        bind[index].buffer = malloc(length);
        if (bind[index].buffer == NULL) {
            return false;
        }
        int code = memcpy_s(bind[index].buffer, length, value, length);
        if (code != 0) {
            return false;
        }
    }
    bind[index].buffer_length = length;
    return true;
}

bool set_bytes_blob(MYSQL_BIND *bind, int64_t index, char *value, int64_t length)
{
    bind[index].buffer_type = MYSQL_TYPE_LONG_BLOB;
    return set_bytes_blob_clob(bind, index, value, length);
}

bool get_all_time_data(MYSQL_BIND *bind, int64_t index)
{
    MYSQL_TIME *value = (MYSQL_TIME *)calloc(1, sizeof(MYSQL_TIME));
    if (value == NULL) {
        return false;
    }
    bind[index].buffer = value;
    bind[index].buffer_length = sizeof(MYSQL_TIME);
    return true;
}

bool get_all_int8_bool(MYSQL_BIND *bind, int64_t index)
{
    bind[index].buffer_type = MYSQL_TYPE_TINY;
    bool *value = (bool *)calloc(1, sizeof(bool));
    if (value == NULL) {
        return false;
    }
    bind[index].buffer = value;
    bind[index].buffer_length = INT8_SIZE;
    return true;
}

bool get_all_bytes_clob_blob(MYSQL_BIND *bind, int64_t index, int64_t length)
{
    if (length <= 0) {
        return false;
    }
    char *value = (char *)calloc(length, sizeof(char));
    if (value == NULL) {
        return false;
    }
    bind[index].buffer = value;
    bind[index].buffer_length = length;
    return true;
}

bool get_all_bytes_blob(MYSQL_BIND *bind, int64_t index, int64_t length)
{
    bind[index].buffer_type = MYSQL_TYPE_BLOB;
    if (!get_all_bytes_clob_blob(bind, index, length)) {
        return false;
    }
    return true;
}

bool get_all_data(MYSQL_BIND *bind, int64_t index)
{
    bind[index].length = (unsigned long *)malloc(sizeof(unsigned long));
    if (bind[index].length == NULL) {
        return false;
    }
    bool *is_null = (bool *)calloc(1, sizeof(bool));
    if (is_null == NULL) {
        return false;
    }
    bind[index].is_null = is_null;
    bool *error = (bool *)calloc(1, sizeof(bool));
    if (error == NULL) {
        return false;
    }
    bind[index].error = error;
    return true;
}

/*---------------------- 初始化 ----------------------*/
MYSQL_BIND *init_bind(int64_t size)
{
    if (size == 0) {
        return NULL;
    }
    MYSQL_BIND *bind = (MYSQL_BIND *)calloc(size, sizeof(MYSQL_BIND));
    if (bind == NULL) {
        return NULL;
    }
    return bind;
}

/*---------------------- 插入数据进入数据库 ----------------------*/
bool set_string(MYSQL_BIND *bind, int64_t index, char *value)
{
    bind[index].buffer_type = MYSQL_TYPE_STRING;
    int strLength = strlen(value) + 1;
    bind[index].buffer = malloc(strLength);
    if (bind[index].buffer == NULL) {
        return false;
    }
    int code = strcpy_s((char *)bind[index].buffer, strLength, value);
    if (code != 0) {
        return false;
    }
    bind[index].buffer_length = strLength -1;
    return true;
}

bool set_bytes(MYSQL_BIND *bind, int64_t index, char *value, int64_t length)
{
    return set_bytes_blob(bind, index, value, length);
}

bool set_clob(MYSQL_BIND *bind, int64_t index, char *value, int64_t length)
{
    bind[index].buffer_type = MYSQL_TYPE_LONG_BLOB;
    return set_bytes_blob_clob(bind, index, value, length);
}

bool set_blob(MYSQL_BIND *bind, int64_t index, char *value, int64_t length)
{
    return set_bytes_blob(bind, index, value, length);
}

bool set_bool(MYSQL_BIND *bind, int64_t index, int8_t value)
{
    bind[index].buffer_type = MYSQL_TYPE_TINY;
    bind[index].buffer = malloc(INT8_SIZE);
    if (bind[index].buffer == NULL) {
        return false;
    }
    *(int8_t *)bind[index].buffer = value;
    return true;
}

bool set_int8(MYSQL_BIND *bind, int64_t index, int8_t value)
{
    bind[index].buffer_type = MYSQL_TYPE_TINY;
    bind[index].buffer = malloc(INT8_SIZE);
    if (bind[index].buffer == NULL) {
        return false;
    }
    *(int8_t *)bind[index].buffer = value;
    return true;
}

bool set_int16(MYSQL_BIND *bind, int64_t index, short value)
{
    bind[index].buffer_type = MYSQL_TYPE_SHORT;
    bind[index].buffer = malloc(INT16_SIZE);
    if (bind[index].buffer == NULL) {
        return false;
    }
    *(short *)bind[index].buffer = value;
    return true;
}

bool set_int32(MYSQL_BIND *bind, int64_t index, int32_t value)
{
    bind[index].buffer_type = MYSQL_TYPE_LONG;
    bind[index].buffer = malloc(INT32_SIZE);
    if (bind[index].buffer == NULL) {
        return false;
    }
    *(int32_t *)bind[index].buffer = value;
    return true;
}

bool set_int64(MYSQL_BIND *bind, int64_t index, int64_t value)
{
    bind[index].buffer_type = MYSQL_TYPE_LONGLONG;
    bind[index].buffer = malloc(INT64_SIZE);
    if (bind[index].buffer == NULL) {
        return false;
    }
    *(int64_t *)bind[index].buffer = value;
    return true;
}

bool set_float32(MYSQL_BIND *bind, int64_t index, float value)
{
    bind[index].buffer_type = MYSQL_TYPE_FLOAT;
    bind[index].buffer = malloc(INT32_SIZE);
    if (bind[index].buffer == NULL) {
        return false;
    }
    *(float *)bind[index].buffer = value;
    return true;
}

bool set_float64(MYSQL_BIND *bind, int64_t index, double value)
{
    bind[index].buffer_type = MYSQL_TYPE_DOUBLE;
    bind[index].buffer = malloc(INT64_SIZE);
    if (bind[index].buffer == NULL) {
        return false;
    }
    *(double *)bind[index].buffer = value;
    return true;
}

bool set_date(MYSQL_BIND *bind, int64_t index, uint32_t year, uint32_t month_value, uint32_t day_of_month)
{
    bind[index].buffer_type = MYSQL_TYPE_DATE;
    MYSQL_TIME *time = (MYSQL_TIME *)malloc(sizeof(MYSQL_TIME));
    if (time == NULL) {
        return false;
    }
    time->year = year;
    time->month = month_value;
    time->day = day_of_month;
    time->time_type = MYSQL_TIMESTAMP_DATE;
    bind[index].buffer = time;
    return true;
}

bool set_time(MYSQL_BIND *bind, int64_t index, uint32_t hour, uint32_t minute, uint32_t second)
{
    bind[index].buffer_type = MYSQL_TYPE_TIME;
    MYSQL_TIME *time = (MYSQL_TIME *)malloc(sizeof(MYSQL_TIME));
    if (time == NULL) {
        return false;
    }
    time->year = 0;
    time->month = 0;
    time->day = 0;
    time->hour = hour;
    time->minute = minute;
    time->second = second;
    time->second_part = 0;
    time->neg = false;
    time->time_type = MYSQL_TIMESTAMP_TIME;
    bind[index].buffer = time;
    return true;
}

bool set_timestamp(MYSQL_BIND *bind, int64_t index, uint32_t year, uint32_t month_value, uint32_t day_of_month,
                   uint32_t hour, uint32_t minute, uint32_t second)
{
    bind[index].buffer_type = MYSQL_TYPE_TIMESTAMP;
    MYSQL_TIME *time = (MYSQL_TIME *)malloc(sizeof(MYSQL_TIME));
    if (time == NULL) {
        return false;
    }
    time->year = year;
    time->month = month_value;
    time->day = day_of_month;
    time->hour = hour;
    time->minute = minute;
    time->second = second;
    time->second_part = 0;
    time->neg = false;
    time->time_type = MYSQL_TIMESTAMP_DATETIME;
    bind[index].buffer = time;
    return true;
}

bool set_date_time(MYSQL_BIND *bind, int64_t index, uint32_t year, uint32_t monthValue, uint32_t dayOfMonth,
                   uint32_t hour, uint32_t minute, uint32_t second)
{
    bind[index].buffer_type = MYSQL_TYPE_DATETIME;
    MYSQL_TIME *time = (MYSQL_TIME *)malloc(sizeof(MYSQL_TIME));
    if (time == NULL) {
        return false;
    }
    time->year = year;
    time->month = monthValue;
    time->day = dayOfMonth;
    time->hour = hour;
    time->minute = minute;
    time->second = second;
    time->second_part = 0;
    time->neg = false;
    time->time_type = MYSQL_TIMESTAMP_DATETIME;
    bind[index].buffer = time;
    return true;
}

bool set_decimal(MYSQL_BIND *bind, int64_t index, char *value)
{
    bind[index].buffer_type = MYSQL_TYPE_NEWDECIMAL;
    int strLength = strlen(value) + 1;
    bind[index].buffer = malloc(strLength);
    if (bind[index].buffer == NULL) {
        return false;
    }
    int code = strcpy_s((char *)bind[index].buffer, strLength, value);
    if (code != 0) {
        return false;
    }
    bind[index].buffer_length = strLength -1;
    return true;
}

bool set_null(MYSQL_BIND *bind, int64_t index)
{
    bind[index].buffer_type = MYSQL_TYPE_NULL;
    bind[index].is_null = (bool *)malloc(1);
    if (bind[index].is_null == NULL) {
        return false;
    }
    *(bool *)bind[index].is_null = true;
    bind[index].is_null_value = true;
    bind[index].buffer = NULL;
    return true;
}

void free_mysql_cj(MYSQL_BIND *bind, int64_t size)
{
    for (int64_t i = 0; i < size; i++) {
        if (bind[i].buffer != NULL) {
            free(bind[i].buffer);
        }
        if (bind[i].is_null != NULL) {
            free(bind[i].is_null);
        }
        if (bind[i].error != NULL) {
            free(bind[i].error);
        }
        if (bind[i].length != NULL) {
            free(bind[i].length);
        }
    }
    if (bind != NULL) {
        free(bind);
    }
}

/*---------------------- 从数据库获取数据 ----------------------*/
bool get_string(MYSQL_BIND *bind, int64_t index, int64_t length)
{
    bind[index].buffer_type = MYSQL_TYPE_STRING;
    int strLength = length + 1;
    if (strLength <= 0) {
        return false;
    }
    char *value = (char *)calloc(strLength, sizeof(char));
    if (value == NULL) {
        return false;
    }
    bind[index].buffer = value;
    bind[index].buffer_length = strLength - 1;
    return get_all_data(bind, index);
}

bool get_bytes(MYSQL_BIND *bind, int64_t index, int64_t length)
{
    if (!get_all_bytes_blob(bind, index, length)) {
        return false;
    }
    return get_all_data(bind, index);
}

bool get_clob(MYSQL_BIND *bind, int64_t index, int64_t length)
{
    bind[index].buffer_type = MYSQL_TYPE_LONG_BLOB;
    if (!get_all_bytes_clob_blob(bind, index, length)) {
        return false;
    }
    return get_all_data(bind, index);
}

bool get_blob(MYSQL_BIND *bind, int64_t index, int64_t length)
{
    if (!get_all_bytes_blob(bind, index, length)) {
        return false;
    }
    return get_all_data(bind, index);
}

bool get_bool(MYSQL_BIND *bind, int64_t index)
{
    if (!get_all_int8_bool(bind, index)) {
        return false;
    }
    return get_all_data(bind, index);
}

bool get_int8(MYSQL_BIND *bind, int64_t index)
{
    if (!get_all_int8_bool(bind, index)) {
        return false;
    }
    return get_all_data(bind, index);
}

bool get_int16(MYSQL_BIND *bind, int64_t index)
{
    bind[index].buffer_type = MYSQL_TYPE_SHORT;
    short *value = (short *)calloc(1, sizeof(short));
    if (value == NULL) {
        return false;
    }
    bind[index].buffer = value;
    bind[index].buffer_length = INT16_SIZE;
    return get_all_data(bind, index);
}

bool get_int32(MYSQL_BIND *bind, int64_t index)
{
    bind[index].buffer_type = MYSQL_TYPE_LONG;
    int32_t *value = (int32_t *)calloc(1, sizeof(int32_t));
    if (value == NULL) {
        return false;
    }
    bind[index].buffer = value;
    bind[index].buffer_length = INT32_SIZE;
    return get_all_data(bind, index);
}

bool get_int64(MYSQL_BIND *bind, int64_t index)
{
    bind[index].buffer_type = MYSQL_TYPE_LONGLONG;
    int64_t *value = (int64_t *)calloc(1, sizeof(int64_t));
    if (value == NULL) {
        return false;
    }
    bind[index].buffer = value;
    bind[index].buffer_length = INT64_SIZE;
    return get_all_data(bind, index);
}

bool get_float32(MYSQL_BIND *bind, int64_t index)
{
    bind[index].buffer_type = MYSQL_TYPE_FLOAT;
    float *value = (float *)calloc(1, sizeof(float));
    if (value == NULL) {
        return false;
    }
    bind[index].buffer = value;
    bind[index].buffer_length = INT32_SIZE;
    return get_all_data(bind, index);
}

bool get_float64(MYSQL_BIND *bind, int64_t index)
{
    bind[index].buffer_type = MYSQL_TYPE_DOUBLE;
    double *value = (double *)calloc(1, sizeof(double));
    if (value == NULL) {
        return false;
    }
    bind[index].buffer = value;
    bind[index].buffer_length = INT64_SIZE;
    return get_all_data(bind, index);
}

bool get_date(MYSQL_BIND *bind, int64_t index)
{
    bind[index].buffer_type = MYSQL_TYPE_DATE;
    if (!get_all_time_data(bind, index)) {
        return false;
    }
    return get_all_data(bind, index);
}

bool get_time(MYSQL_BIND *bind, int64_t index)
{
    bind[index].buffer_type = MYSQL_TYPE_TIME;
    if (!get_all_time_data(bind, index)) {
        return false;
    }
    return get_all_data(bind, index);
}

bool get_timestamp(MYSQL_BIND *bind, int64_t index)
{
    bind[index].buffer_type = MYSQL_TYPE_TIMESTAMP;
    if (!get_all_time_data(bind, index)) {
        return false;
    }
    return get_all_data(bind, index);
}

bool get_date_time(MYSQL_BIND *bind, int64_t index)
{
    bind[index].buffer_type = MYSQL_TYPE_DATETIME;
    if (!get_all_time_data(bind, index)) {
        return false;
    }
    return get_all_data(bind, index);
}

bool get_decimal(MYSQL_BIND *bind, int64_t index, int64_t length)
{
    bind[index].buffer_type = MYSQL_TYPE_NEWDECIMAL;
    int strLength = length + 1;
    if (strLength <= 0) {
        return false;
    }
    char *value = (char *)calloc(strLength, sizeof(char));
    if (value == NULL) {
        return false;
    }
    bind[index].buffer = value;
    bind[index].buffer_length = strLength - 1;
    return get_all_data(bind, index);
}

/*---------------------- 对获取的数据进行处理 ----------------------*/
/**
 * 获取MYSQL_BIND中的buffer,buffer_type,is_null,length,用作仓颉端处理，转换成SqlDbType
 */
void *get_sql_buffer(MYSQL_BIND *bind, int64_t index, enum enum_field_types *buffer_type, bool *is_null,
                     int64_t *length)
{
    enum enum_field_types buffer_type_value = bind[index].buffer_type;
    *buffer_type = buffer_type_value;
    *is_null = *bind[index].is_null;
    *length = *bind[index].length;
    return bind[index].buffer;
}

/**
 * 处理time
 */
void get_sql_time(MYSQL_TIME *time, unsigned int *year, unsigned int *month, unsigned int *day, unsigned int *hour,
                  unsigned int *minute, unsigned int *second)
{
    *year = time[0].year;
    *month = time[0].month;
    *day = time[0].day;
    *hour = time[0].hour;
    *minute = time[0].minute;
    *second = time[0].second;
}

/*---------------------- 获取列信息 ----------------------*/
/**
 * 获取数据库表单表头信息
 */
bool get_res_data(MYSQL_RES *mysql_res_list, int64_t length, MYSQL_COLUMN_INFO *info)
{
    MYSQL_RES mysql_res = mysql_res_list[0];
    MYSQL_FIELD *mysql_field_list = mysql_res.fields;
    if (mysql_field_list == NULL) {
        return false;
    }
    for (int i = 0; i < length; i++) {
        MYSQL_FIELD mysql_field = mysql_field_list[i];
        MYSQL_COLUMN_INFO mysql_column_info;
        mysql_column_info.name_string = mysql_field.name;
        mysql_column_info.type = mysql_field.type;
        mysql_column_info.flags = mysql_field.flags;
        mysql_column_info.display_size_int64 = mysql_field.max_length;
        mysql_column_info.length_int64 = mysql_field.length;
        mysql_column_info.scale_int64 = mysql_field.decimals;
        info[i] = mysql_column_info;
    }
    return true;
}

#ifdef __cplusplus
    }
#endif
