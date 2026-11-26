# `source_data()` / `sourcoise()` reference

`ofce::source_data()` is a strict alias of `sourcoise::sourcoise()` — a drop-in
replacement for `base::source()` that caches the script's result on disk (qs2
format). Documentation: https://xtimbeau.github.io/sourcoise/reference/sourcoise.html

## Signature

```r
source_data(path,
            args = list(),
            track = list(),
            lapse = NULL,
            force_exec = getOption("sourcoise.force_exec"),
            prevent_exec = getOption("sourcoise.prevent_exec"),
            metadata = getOption("sourcoise.metadata"),
            wd = getOption("sourcoise.wd"),
            quiet = getOption("sourcoise.quiet"))
```

| Argument | Meaning |
|----|----|
| `path` | Script path. Incomplete paths are resolved by a search heuristic: document (`.qmd`) dir first, then working directory, then a project-wide search for the nearest match. |
| `args` | List of parameters, available inside the script as `args$xxx`. Changing a value invalidates the cache. |
| `track` | Files whose modification invalidates the cache (hash-based). Paths relative to the script. Tracked files accumulate across calls. Note: xlsx hashes are not cross-platform; text files are. |
| `lapse` | Cache lifetime: `NULL` (no change), `"never"` (default), or `"x hours/days/weeks/months/quarters/years"`. A `"day"` lapse re-executes once a day. |
| `force_exec` | Run regardless of cache validity (avoid; prefer `source_data_refresh()`). |
| `prevent_exec` | Never execute; serve the cache even if invalid (`NULL` if no cache). Global-safe via `options(sourcoise.prevent_exec = TRUE)` — useful for a no-network site render. |
| `metadata` | `TRUE` → returns a list with `$data` and `$date` (download date) instead of the data alone — handy for dating a chart caption. |
| `wd` | Working directory during execution: `"file"` (default, the script's dir), `"project"`, or `"qmd"`. Restored afterwards, even on failure. |
| `quiet` | Suppress script messages/warnings. |

## Cache behavior

- Cache invalidation triggers: no cache, script modified, tracked file modified,
  `lapse` expired, `force_exec`.
- On execution **error**, the call does not fail: it returns the last cache,
  even an invalid one. Error only if no cache exists at all.
- Results are serialized with `qs2`; cached reads are typically < 10 ms.
- If a new result is identical to the cache, nothing is rewritten — `$data_date`
  (metadata) is a better indicator of when the data last changed than the
  execution date.
- Cache location: `data/.sourcoise/` next to the script (default `src_in =
  "file"`), as `<script>-<hash>.qs2` plus a `.json` descriptor. **Committed
  with the post** — per-user info in the descriptor avoids merge conflicts.

## Management functions

| Function | Purpose |
|----|----|
| `source_data_status()` | List caches, validity, parameters. Can return the selection to refresh. |
| `source_data_refresh()` | Refresh all caches, or those selected from `source_data_status()`. |
| `clear_source_cache()` | Delete the whole cache (will re-execute). |
| `prune_source_cache()` | Same, keeping the latest versions. |

## Global options

- `sourcoise.force_exec`, `sourcoise.prevent_exec`, `sourcoise.metadata`,
  `sourcoise.wd`, `sourcoise.quiet` — defaults for the matching arguments.
- `sourcoise.root` — force the project root (useful outside a project).
- `sourcoise.nocache` — disable caching (testing).
- `sourcoise.grow_cache` — max cached files kept (default 5).
- `sourcoise.limit_mb` — max size of one cached object (default 50 MB; bigger
  results are not cached).
