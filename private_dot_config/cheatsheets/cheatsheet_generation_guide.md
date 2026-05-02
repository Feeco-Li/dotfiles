# Cheatsheet Generation Guide

## Goal

Generate quick-reference cheatsheets for CLI tools and libraries, focused on the most commonly used commands. Each cheatsheet covers the 80% of daily usage — not exhaustive documentation. Commands are grouped by task, with a concrete example per entry so the reader can copy-paste without consulting the full docs.

## Target viewer: w3m

w3m is a terminal browser. It ignores all CSS. Colors are driven
entirely by HTML element type, not by `<font color>` or stylesheets.

## File format

Plain `.html` file. Open with:

```
w3m filename.html
```

## Table structure

```html
<table width="100%" border="0" cellpadding="2" cellspacing="0">

  <tr><th colspan="3"><input type="text" readonly value="section_name"></th></tr>
  <tr><td><a href="#">api_code</a></td><td>description</td><td>concrete example</td></tr>
  ...

  <tr><th colspan="3"><input type="text" readonly value="next_section"></th></tr>
  <tr><td><a href="#">api_code</a></td><td>description</td><td>concrete example</td></tr>
  ...

</table>
```

- `width="100%"` — stretches to fill tmux pane width
- `border="0"` — hides table borders (note: w3m's `display_borders 1`
  config may override this)
- 3 columns: left = code (yellow), middle = description (white), right = example (white)
- sections stack vertically, separated by header rows

## Color scheme

w3m only colorizes text based on element type:

| Color   | Element                              | Use for         |
|---------|--------------------------------------|-----------------|
| red     | `<input type="text" readonly>`       | section headers |
| yellow  | `<a href="#">`                       | api code        |
| magenta | `<img src="x" alt="text">`           | available        |
| white   | plain text                           | descriptions    |

`<font color="...">` does NOT work in w3m — it is silently ignored
regardless of the color name, including cyan, blue, gray, etc.

## Section header row

```html
<tr><th colspan="3"><input type="text" readonly value="section_name"></th></tr>
```

- `colspan="3"` spans all three columns
- `<input readonly>` renders in red (`form_color` in `~/.w3m/config`)
- use snake_case for section names: `crud_and_queries`, `field_options`

## Code entry row

```html
<tr><td><a href="#">docker run -d --name &lt;n&gt; &lt;img&gt;</a></td><td>run named container detached</td><td>docker run -d --name web nginx</td></tr>
```

- `<a href="#">` renders in yellow (`anchor_color` in `~/.w3m/config`)
- third column is plain text — a concrete example with real values substituted for placeholders
- escape HTML special chars in code: `<` → `&lt;`  `>` → `&gt;`  `&` → `&amp;`

## HTML entities to remember

| Character | Entity   |
|-----------|----------|
| `<`       | `&lt;`   |
| `>`       | `&gt;`   |
| `&`       | `&amp;`  |
| `"`       | `&quot;` (only needed inside attribute values) |

## w3m color config reference (`~/.w3m/config`)

| Config key      | Default  | Triggered by              |
|-----------------|----------|---------------------------|
| `basic_color`   | white    | plain text                |
| `anchor_color`  | yellow   | `<a href>`                |
| `active_color`  | cyan     | link under cursor only    |
| `visited_color` | green    | visited links (unreliable)|
| `form_color`    | red      | `<input>`, `<select>`     |
| `image_color`   | magenta  | `<img alt="...">`         |

## Minimal template

```html
<!DOCTYPE html>
<html>
<head><title>My Cheatsheet</title></head>
<body>

<table width="100%" border="0" cellpadding="2" cellspacing="0">

<tr><th colspan="3"><input type="text" readonly value="section_one"></th></tr>
<tr><td><a href="#">command or api</a></td><td>what it does</td><td>concrete example</td></tr>

<tr><th colspan="3"><input type="text" readonly value="section_two"></th></tr>
<tr><td><a href="#">command or api</a></td><td>what it does</td><td>concrete example</td></tr>

</table>
</body>
</html>
```

## Workflow

1. Read the source `.sh` cheatsheet file to extract sections and entries
2. Map each section to a `<th colspan="3"><input readonly>` header row
3. Map each `cmd / desc` pair to a `<tr><td><a href="#">cmd</a></td><td>desc</td><td>example</td></tr>` row
4. For the example column, substitute real values for placeholders (e.g. `<img>` → `nginx`, `<c>` → `web`)
5. Escape `<`, `>`, `&` in command strings
6. Merge related sections if they share the same conceptual topic
7. Open with `w3m filename.html` to verify layout
