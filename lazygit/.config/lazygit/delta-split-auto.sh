#!/usr/bin/env bash
# lazygit diff viewer: delta's split view for edited files, full-width single column for added or deleted files.

theme=--dark
defaults read -g AppleInterfaceStyle >/dev/null 2>&1 || theme=--light
cols=${COLUMNS:-$(stty -f /dev/stdout size 2>/dev/null | cut -d' ' -f2)}
width=()
[ -n "$cols" ] && width=(--width "$cols")

# Delta only wraps long lines in split view, so wrap single-column output here: the rest of the
# line continues after a blank line-number gutter, keeping its colours, with ↵ like split view.
wrap() {
  [ -z "$cols" ] && { cat; return; }
  perl -CSD -Mutf8 -ne '
    BEGIN { $w = '"$cols"' }
    chomp; my $raw = $_;
    (my $plain = $raw) =~ s/\e\[[0-9;]*[A-Za-z]//g;
    if (length($plain) <= $w || $plain !~ /^(\s*\d*\s*│)/) { print "$raw\n"; next }
    my $gutter = length($1);
    my ($blank) = $raw =~ /^(.*?│)/; $blank =~ s/(\e\[[0-9;]*[A-Za-z])|\d/defined $1 ? $1 : " "/ge;
    my $room = $w - $gutter - 1;
    my ($visible, $sgr, $out, $piece) = (0, "", "", 0);
    while ($raw =~ /\G(\e\[[0-9;]*[A-Za-z]|.)/gs) {
      my $t = $1;
      if ($t =~ /^\e/) { $out .= $t; $sgr .= $t if $t =~ /m$/; next }
      if ($visible - $gutter >= $room * ($piece + 1)) {
        $out .= "↵\e[K\e[0m\n$blank$sgr";
        $piece++;
      }
      $out .= $t; $visible++;
    }
    print "$out\n";
  '
}

render() {
  if [ "$1" = full ]; then
    delta "$theme" --paging=never --no-gitconfig --line-numbers --navigate --line-numbers-left-format= "${width[@]}" | wrap
  else
    delta "$theme" --paging=never "${width[@]}"
  fi
}

input=$(cat; printf x)
input=${input%x}

if ! grep -qE '(new|deleted) file mode' <<<"$input"; then
  printf '%s' "$input" | render split
  exit
fi

dir=$(mktemp -d)
trap 'rm -rf "$dir"' EXIT

# Groups consecutive files of the same kind into numbered chunks (001.split, 002.full, …) so delta runs once per group.
printf '%s' "$input" | awk -v dir="$dir" '
  function plain(s) { gsub(/\033\[[0-9;]*m/, "", s); return s }
  function flush(   kind) {
    if (n == 0) return
    kind = isFull ? "full" : "split"
    if (kind != groupKind) { group++; groupKind = kind }
    file = sprintf("%s/%03d.%s", dir, group, kind)
    for (i = 1; i <= n; i++) print buf[i] >> file
    close(file)
    n = 0; isFull = 0; inHeader = 0
  }
  {
    line = plain($0)
    if (line ~ /^diff --(git|cc|combined) /) {
      if (started) flush()
      started = 1; inHeader = 1
    }
    if (inHeader && line ~ /^@@/) inHeader = 0
    if (inHeader && line ~ /^(new|deleted) file mode/) isFull = 1
    buf[++n] = $0
  }
  END { flush() }
'

for chunk in "$dir"/*; do
  render "${chunk##*.}" < "$chunk"
done
