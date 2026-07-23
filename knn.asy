size(12cm, 12cm);

// --- Color scheme
pen fg = white;
pen bg = black;

// --- Data points
// Class 1: open circles with "1" — mostly left, one crossover right
pair[] class1 = {
    (1.2, 1.5), (2.0, 3.1), (0.8, 4.2), (1.7, 2.3),
    (3.1, 1.1), (0.5, 2.8), (2.5, 4.5), (1.0, 6.0),
    (3.8, 3.5), (6.5, 6.0)
};

// Class 2: filled circles with "2" — mostly right, two crossovers left
pair[] class2 = {
    (5.5, 2.0), (6.8, 3.5), (7.2, 1.5), (5.0, 4.8),
    (6.1, 5.5), (7.5, 4.2), (8.0, 2.8), (5.8, 6.2),
    (2.5, 5.5), (3.5, 2.5)
};

// Query point
pair query = (4.8, 3.2);

// 3 nearest neighbours (sorted by distance to query):
//   class1[8] = (3.8, 3.5)  dist ≈ 1.04
//   class2[0] = (5.5, 2.0)  dist ≈ 1.39
//   class2[9] = (3.5, 2.5)  dist ≈ 1.48
pair[] nn = {class1[8], class2[0], class2[9]};

// --- Style constants
real r            = 0.22;  // point radius
real diamondScale = 1.4;   // diamond half-diagonal relative to r
real ringGap      = 0.13;  // extra radius of highlight ring beyond point border
real encScale     = 1.08;  // enclosing circle radius relative to farthest NN
real axisMax      = 9;
real yMax         = 7.5;
int  xTicks       = 8;     // number of x-axis tick marks
int  yTicks       = 7;     // number of y-axis tick marks
real tickLen      = 0.12;
real legX         = 9.8;   // legend anchor: right of plot area
real legY         = 5.5;   // legend anchor: vertical centre
real legStep      = 0.75;  // vertical spacing between legend entries
real legTextGap   = 0.1;   // gap between legend symbol and text

pen ptborder = fg + linewidth(1pt);
pen nnring   = fg + linewidth(1.8pt);
pen dotpen   = fg + dotted + linewidth(0.6pt);   // NN distance lines
pen dashpen  = fg + linewidth(0.7pt) + linetype("4 3");  // enclosing circle
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

// --- Axes
draw((0,0)--(axisMax,0), fg, Arrow(6));
draw((0,0)--(0,yMax), fg, Arrow(6));
label("$x_1$", (axisMax, 0), E, fg);
label("$x_2$", (0, yMax), N, fg);

for (int i = 1; i <= xTicks; ++i)
    draw((i,-tickLen)--(i,tickLen), fg);
for (int j = 1; j <= yTicks; ++j)
    draw((-tickLen,j)--(tickLen,j), fg);

// --- Dotted lines from query to 3-NN
for (pair p : nn)
    draw(query--p, dotpen);

// --- Enclosing dashed circle around 3-NN
real enc = 0;
for (pair p : nn)
    enc = max(enc, length(query - p));
draw(circle(query, enc * encScale), dashpen);

// --- Class points
for (pair p : class1) drawClass1Point(p);
for (pair p : class2) drawClass2Point(p);

// --- Highlight rings around 3-NN
for (pair p : nn)
    draw(circle(p, r + ringGap), nnring);

// --- Query point
drawQueryPoint(query, r * diamondScale);

// --- Legend
pair leg1pos = (legX, legY);
pair leg2pos = leg1pos + (0, -legStep);
pair leg3pos = leg2pos + (0, -legStep);
real legDiamondHalf = r * diamondScale;

drawClass1Point(leg1pos);
label("class 1", leg1pos + (r + legTextGap, 0), E, fg);

drawClass2Point(leg2pos);
label("class 2", leg2pos + (r + legTextGap, 0), E, fg);

drawQueryPoint(leg3pos, legDiamondHalf);
label("query point", leg3pos + (legDiamondHalf + legTextGap, 0), E, fg);

shipout(bbox(3mm, Fill(bg)));
