#!/bin/sh
# -*- coding: utf-8 -*-
# Copyright 2022, Antonio Alvarado Hernández

# See also: https://cnecovid.isciii.es/covid19/#documentación-y-datos

CURL_CMD="curl"
CURL_OPTS="-L --connect-timeout 5 --max-time 480 --retry 5 --retry-delay 5 --retry-max-time 720"
DIR_PREFIX="${HOME}/Data/Covid-19/ISCIII"
DATE_SUFFIX=$(date '+%Y%m%d')
BASE_URL="https://cnecovid.isciii.es/covid19/resources"

$CURL_CMD $CURL_OPTS "$BASE_URL/casos_tecnica_ccaa.csv" |
    gzip > "$DIR_PREFIX/casos_tecnica_ccaa_$DATE_SUFFIX.csv.gz"

$CURL_CMD $CURL_OPTS "$BASE_URL/casos_diag_ccaadecl.csv" |
    gzip > "$DIR_PREFIX/casos_diagnst_ccaa_$DATE_SUFFIX.csv.gz"

$CURL_CMD $CURL_OPTS "$BASE_URL/casos_tecnica_provincia.csv" |
    gzip > "$DIR_PREFIX/casos_tecnica_prov_$DATE_SUFFIX.csv.gz"

$CURL_CMD $CURL_OPTS "$BASE_URL/casos_hosp_uci_def_sexo_edad_provres.csv" |
    gzip > "$DIR_PREFIX/casos_sex_age_prov_$DATE_SUFFIX.csv.gz"

$CURL_CMD $CURL_OPTS "$BASE_URL/casos_hosp_uci_def_sexo_edad_provres_60_mas.csv" |
    gzip > "$DIR_PREFIX/casos_sex_60+_prov_$DATE_SUFFIX.csv.gz"

chmod 0444 "$DIR_PREFIX"/*_$DATE_SUFFIX.csv.gz

# EOF
