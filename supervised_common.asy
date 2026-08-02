unitsize(1.3cm);

// --- Color scheme
pen fg = white;
pen bg = black;

// --- Shared style constants
real r            = 0.22;  // point radius
real diamondScale = 1.4;   // diamond half-diagonal relative to r
int  axisMax      = 9;
real yMax         = 7.5;
int  xTicks       = 8;     // number of x-axis tick marks
int  yTicks       = 7;     // number of y-axis tick marks
real tickLen      = 0.12;
real legStep      = 0.75;  // vertical spacing between legend entries
real legTextGap   = 0.1;   // gap between legend symbol and text

pen ptborder = fg + linewidth(1pt);
pen querypen = fg + linewidth(1.2pt);

// Switch the foreground/background colour scheme (e.g. white-on-black vs
// black-on-white). Call this immediately after import and before any
// drawing -- pens derived from fg/bg (ptborder, querypen) are frozen
// values, not live references, so they must be recomputed here rather
// than tracking fg/bg automatically.
void setColorScheme(pen newFg, pen newBg) {
    fg = newFg;
    bg = newBg;
    ptborder = fg + linewidth(1pt);
    querypen = fg + linewidth(1.2pt);
}

// --- Shared data
pair query = (4.8, 3.2);

// --- Helper functions
path diamond(pair center, real half) {
    return (center+(0,half)) -- (center+(half,0))
        -- (center+(0,-half)) -- (center+(-half,0)) -- cycle;
}

void drawClass1Point(pair center, real radius=r, pen border=ptborder) {
    filldraw(circle(center, radius), bg, border);
    label("$1$", center, fg + fontsize(12 * radius/r));
}

void drawClass2Point(pair center, real radius=r, pen border=ptborder) {
    filldraw(circle(center, radius), fg, border);
    label("$2$", center, bg + fontsize(12 * radius/r));
}

void drawQueryPoint(pair center, real half) {
    filldraw(diamond(center, half), bg, querypen);
    label("$?$", center, fg);
}

void drawAxes(string xLabel="$x_1$", string yLabel="$x_2$") {
    draw((0,0)--(axisMax,0), fg, Arrow(6));
    draw((0,0)--(0,yMax), fg, Arrow(6));
    label(xLabel, (axisMax, 0), E, fg);
    label(yLabel, (0, yMax), N, fg);

    for (int i = 1; i <= xTicks; ++i) {
        draw((i,-tickLen)--(i,tickLen), fg);
        label("$" + string(i) + "$", (i, -tickLen), S, fg);
    }
    for (int j = 1; j <= yTicks; ++j) {
        draw((-tickLen,j)--(tickLen,j), fg);
        label("$" + string(j) + "$", (-tickLen, j), W, fg);
    }
}

// Draws class 1, class 2, and query point legend entries starting at `start`.
// Returns the position of the next legend slot below.
pair drawBaseLegend(pair start, string class1Label="class 1",
                     string class2Label="class 2", string queryLabel="query point") {
    real legDiamondHalf = r * diamondScale;
    pair leg2pos = start + (0, -legStep);
    pair leg3pos = leg2pos + (0, -legStep);

    drawClass1Point(start);
    label(class1Label, start + (r + legTextGap, 0), E, fg);

    drawClass2Point(leg2pos);
    label(class2Label, leg2pos + (r + legTextGap, 0), E, fg);

    drawQueryPoint(leg3pos, legDiamondHalf);
    label(queryLabel, leg3pos + (legDiamondHalf + legTextGap, 0), E, fg);

    return leg3pos + (0, -legStep);
}
