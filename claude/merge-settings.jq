# Deep-merge the repo baseline into the live Claude Code settings.
# Usage: jq -s -f claude/merge-settings.jq ~/.claude/settings.json claude/settings.json
# Objects merge key by key, arrays keep live entries and append missing baseline ones,
# any other value comes from the baseline. Live-only keys (corporate autoMode, work plugins) survive.
def merge($live; $base):
  reduce ($base | keys_unsorted[]) as $k ($live;
    .[$k] = if ($live[$k] | type) == "object" and ($base[$k] | type) == "object" then merge($live[$k]; $base[$k])
            elif ($live[$k] | type) == "array" and ($base[$k] | type) == "array" then $live[$k] + ($base[$k] - $live[$k])
            else $base[$k] end);
merge(.[0]; .[1])
