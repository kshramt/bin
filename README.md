# `download_jma_hypo.sh`

Download all HYPO files from <http://www.data.jma.go.jp/svd/eqev/data/bulletin/hypo.html>.

```bash
download_jma_hypo.sh
```

# `latexit.sh`

Alternative to [LaTeXiT](http://www.chachatelier.fr/latexit/).

```bash
latexit.sh <<'EOF' >| eq_1.pdf
\bm{d} = \bm{G}\bm{m} + \bm{e}
EOF
```

The LaTeX input is attached to a generated PDF file.
You can extract the equation by:

```bash
latexit.sh -p eq_1.pdf
```

# `make_p_to_json.py` and `json_to_dot.py`

Visualize `Makefile`'s dependecy graph.

```bash
LANG=C gmake -p |
   python3 make_p_to_json.py |
   python3 json_to_dot.py |
   dot -Tpdf -Grankdir=LR -Nshape=plaintext -Ecolor='#00000088' >| workflow.pdf
```

- `make_p_to_json.py`
    - Parse `Makefile`'s database.
    - Compatible with recursive make.
    - Output JSON structure: `[{"target1": ["dep1", "dep2", ...], ...}, ...]`.
- `json_to_dot.py`
    - Convert output of `make_p_to_json.py` to DOT format.

# License

GPL version 3.
