
# refactor with mterm!
# goal is to only run 2 tmux session, on
# 1. that's randomly spawned
# 2. that's used for work!
# if you want a free terminal for something use Menud
function bterm --on-process %self
    set -g TMUX1 tmux new-session -d -s bterm
    eval $TMUX1
    tmux attach-session -d -t bterm
    echo "end"
    exit 0
end
