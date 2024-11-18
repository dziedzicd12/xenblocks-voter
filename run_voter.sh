#!/bin/bash

# Sprawdz czy uzytkownik podal liczbe
if [ $# -ne 1 ]; then
    echo "Uzycie: $0 <liczba uruchomien>"
    exit 1
fi

NUM_RUNS=$1

# Utworz nowe sesje tmux
tmux new-session -d -s voter_session

# Uruchom polecenia w kolejnych oknach z opoznieniem
for ((i=1; i<=NUM_RUNS; i++)); do
    if [ $i -eq 1 ]; then
        tmux send-keys "while true; do time ./target/release/voter $i; done" C-m
    else
        tmux new-window
        tmux send-keys "while true; do time ./target/release/voter $i; done" C-m
    fi
    
    # Czekaj 2 sekundy przed uruchomieniem nastepnego
    sleep 2
done

# Attach to the tmux session
tmux attach-session -t voter_session
