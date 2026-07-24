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
