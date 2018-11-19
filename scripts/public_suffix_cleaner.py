"""
Script to sanitize Mozilla's public list of internet suffixes
(i.e. effective TLDs): https://publicsuffix.org/list/

Data last generated: 9/15/18
"""

import io

with io.open("public_suffix.dat", mode="r", encoding="utf-8") as f:
    with io.open("public_suffic_clean.dat", mode="w", encoding="utf-8") as w:
        for line in f:
            if line.startswith("//"):
                continue
            if line.startswith("*."):
                line = line[2:]

            if len(line.strip()) == 0:
                continue

            w.write("." + line)
