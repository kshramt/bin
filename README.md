# Use Cases

## Visualize `Makefile`'s Dependecy Graph

```bash
LANG=C gmake -p | python3 make_p_to_json.py | python3 json_to_dot.py | dot -Tpdf >| workflow.pdf
```

- `make_p_to_json.py`
    - Parse `Makefile`'s database.
    - Compatible with recursive make.
    - Output JSON structure: `[{"target1": ["dep1", "dep2", ...], ...}, ...]`.
- `json_to_dot.py`
    - Convert output of `make_p_to_json.py` to DOT format.

## [LaTeXiT](http://www.chachatelier.fr/latexit/) Alternative

```bash
latexit.sh <<EOF >| eq_1.pdf
\bm{d} = \bm{G}\bm{m} + \bm{e}
EOF
```

- `latexit.sh`
    - Compile a LaTeX equation to a cropped PDF.

The LaTeX input is stored in output PDF file with Base64 encoding.
You can extract the equation by:

```bash
pdftk eq1.pdf dump_data_utf8 | grep -A1 'InfoKey: latexit\.sh' | tail -n1 | sed -e 's/InfoValue: //' | base64 --decode
```

# License

GPL version 3.
