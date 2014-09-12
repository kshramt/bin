# Use Cases

## Visualize `Makefile` dependencies

```bash
LANG=C gmake -p | python3 make_p_to_json.py | python3 json_to_dot.py | dot -Tpdf >| workflow.pdf
```

- `make_p_to_json.py`
    - Parse `Makefile`'s database.
    - Compatible with recursive make.
    - Output JSON structure: `[{"target1": ["dep1", "dep2", ...], ...},　...]`.
- `json_to_dot.py`
    - Convert output of `make_p_to_json.py` to DOT format.

# License

GPL version 3.
