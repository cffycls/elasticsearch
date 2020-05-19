#!/bin/bash

rm -rf es01/data* es02/data/* es03/data/*
docker restart es01 es02 es03
