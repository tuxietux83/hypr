#!/usr/bin/bash

nf="notify-send"
sleep 1
$nf -u normal normal
sleep 1
$nf -u low low
sleep 1
$nf -u critical critical
