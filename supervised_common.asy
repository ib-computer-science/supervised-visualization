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

// --- Shared data
pair query = (4.8, 3.2);

// --- Helper functions
path diamond(pair center, real half) {
    return (center+(0,half)) -- (center+(half,0))
        -- (center+(0,-half)) -- (center+(-half,0)) -- cycle;
}

void drawClass1Point(pair center) {
    filldraw(circle(center, r), bg, ptborder);
    label("$1$", center, fg);
}

void drawClass2Point(pair center) {
    filldraw(circle(center, r), fg, ptborder);
    label("$2$", center, bg);
}

void drawQueryPoint(pair center, real half) {
    filldraw(diamond(center, half), bg, querypen);
    label("$?$", center, fg);
}

void drawAxes() {
    draw((0,0)--(axisMax,0), fg, Arrow(6));
    draw((0,0)--(0,yMax), fg, Arrow(6));
    label("$x_1$", (axisMax, 0), E, fg);
    label("$x_2$", (0, yMax), N, fg);

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
pair drawBaseLegend(pair start) {
    real legDiamondHalf = r * diamondScale;
    pair leg2pos = start + (0, -legStep);
    pair leg3pos = leg2pos + (0, -legStep);

    drawClass1Point(start);
    label("class 1", start + (r + legTextGap, 0), E, fg);

    drawClass2Point(leg2pos);
    label("class 2", leg2pos + (r + legTextGap, 0), E, fg);

    drawQueryPoint(leg3pos, legDiamondHalf);
    label("query point", leg3pos + (legDiamondHalf + legTextGap, 0), E, fg);

    return leg3pos + (0, -legStep);
}
