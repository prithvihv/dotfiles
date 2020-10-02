
function emacs_reload
    systemctl stop --user emacs
    systemctl --user daemon-reload
    systemctl start --user emacs
end