lsjob() {
  local selected jobnum

  selected="$(
    jobs -l | fzf \
      --height=70% \
      --border \
      --prompt='job> ' \
      --preview='
        pid=$(printf "%s\n" {} |
          sed -E "s/^\[[0-9]+\][^0-9]*([0-9]+).*/\1/")

        if ! [[ "$pid" =~ ^[0-9]+$ ]]; then
          echo "Could not determine PID"
          exit
        fi

        ps -p "$pid" \
          -o pid,ppid,pgid,sid,user,stat,%cpu,%mem,etime,lstart,cmd
      ' \
      --preview-window='right:65%:wrap'
  )" || return

  [[ -z "$selected" ]] && return

  jobnum="$(
    printf '%s\n' "$selected" |
      sed -E 's/^\[([0-9]+)\].*/\1/'
  )"

  [[ -z "$jobnum" ]] && return

  fg "%$jobnum"
}
