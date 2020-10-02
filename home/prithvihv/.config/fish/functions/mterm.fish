# if not set -q TMUX
#     set -g TMUX tmux new-session -d -s base
#     eval $TMUX
#     tmux attach-session -d -t base
# end
function mterm
    set -g TMUX tmux new-session -d -s mterm
    eval $TMUX
    tmux attach-session -d -t mterm
end
