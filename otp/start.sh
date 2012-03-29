#!/bin/sh
cd `dirname $0`
erl -pa $PWD/ebin -pa $PWD/*/ebin -sname exeval -s reloader -boot exeval $1