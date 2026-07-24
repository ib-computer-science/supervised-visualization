import common;

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

// 3 nearest neighbours (sorted by distance to query):
//   class1[8] = (3.8, 3.5)  dist ≈ 1.04
//   class2[0] = (5.5, 2.0)  dist ≈ 1.39
//   class2[9] = (3.5, 2.5)  dist ≈ 1.48
pair[] nn = {class1[8], class2[0], class2[9]};

// --- Style constants
real ringGap = 0.13;  // extra radius of highlight ring beyond point border
real legX    = 9.8;   // legend anchor: right of plot area
real legY    = 5.5;   // legend anchor: vertical centre

pen nnring  = fg + linewidth(1.8pt);
pen dotpen  = fg + dotted + linewidth(0.6pt);   // NN distance lines
pen dashpen = fg + linewidth(0.7pt) + linetype("4 3");  // enclosing circle

// --- Axes
drawAxes();

// --- Dotted lines from query to 3-NN
for (pair p : nn)
    draw(query--p, dotpen);

// --- Enclosing dashed circle around 3-NN
real enc = 0;
for (pair p : nn)
    enc = max(enc, length(query - p));
draw(circle(query, enc), dashpen);

// --- Class points
for (pair p : class1) drawClass1Point(p);
for (pair p : class2) drawClass2Point(p);

// --- Highlight rings around 3-NN
for (pair p : nn)
    draw(circle(p, r + ringGap), nnring);

// --- Query point
drawQueryPoint(query, r * diamondScale);

// --- Legend
drawBaseLegend((legX, legY));

shipout(bbox(3mm, Fill(bg)));
