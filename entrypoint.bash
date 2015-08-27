#!/usr/bin/env bash

jackd --no-realtime -d dummy -r 44100 &
sleep 1
cvlc -vvv 'jack://channels=2:ports=.*' --sout '#transcode{acodec=mp3,ab=256,channels=2,samplerate=44100}:std{access=http,mux=mp3,dst=:8080}' &
cd /extempore
./extempore
