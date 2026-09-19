import importlib.util, os
spec = importlib.util.spec_from_file_location("logo", os.path.expanduser("~/Desktop/dev/safe_router/logo.py"))
logo = importlib.util.module_from_spec(spec); spec.loader.exec_module(logo)

lines = logo.ART.strip("\n").split("\n") + [""] + logo.WORDMARK.split("\n")
CW, CH, PAD = 14, 26, 24                      # terminal-ish cell, w:h ~ 1:1.9
SW = 2.6                                       # line weight for the node art
cols = max(len(l) for l in lines)
W, H = cols * CW + PAD * 2, len(lines) * CH + PAD * 2

body = []
for r, line in enumerate(lines):
    for c, ch in enumerate(line):
        x, y = PAD + c * CW, PAD + r * CH
        cx, cy = x + CW / 2, y + CH / 2
        if ch == "█":
            body.append(f'<rect x="{x}" y="{y}" width="{CW}" height="{CH}"/>')
        elif ch == "●":
            body.append(f'<circle cx="{cx}" cy="{cy}" r="{CW*0.34:.1f}"/>')
        elif ch == "━":
            body.append(f'<line x1="{x}" y1="{cy}" x2="{x+CW}" y2="{cy}"/>')
        elif ch == "┃":
            body.append(f'<line x1="{cx}" y1="{y}" x2="{cx}" y2="{y+CH}"/>')
        elif ch == "╱":
            body.append(f'<line x1="{x}" y1="{y+CH}" x2="{x+CW}" y2="{y}"/>')

svg = f'''<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}" role="img" aria-label="Super Logic AI">
  <defs><linearGradient id="g" gradientUnits="userSpaceOnUse" x1="{PAD}" y1="0" x2="{W-PAD}" y2="0">
    <stop offset="0" stop-color="#00D09B"/><stop offset="1" stop-color="#FF7E1B"/>
  </linearGradient></defs>
  <g fill="url(#g)" stroke="url(#g)" stroke-width="{SW}" stroke-linecap="round">
    {chr(10).join("    " + s for s in body).strip()}
  </g>
</svg>
'''
open(os.path.expanduser("~/Desktop/dev/github-profile/logo.svg"), "w").write(svg)
print(f"{W}x{H}, {len(body)} shapes")
