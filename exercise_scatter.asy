import supervised_common;
setColorScheme(black, white);  // this exercise is printed black-on-white

// --- Exercise dataset: exam outcome
// x1 = hours studied this week, rounded to the nearest hour (0-9)
// x2 = practice exams completed (0-7)
// Both axes use whole numbers, and a background grid is drawn, so every
// point's coordinates -- and the distances between them -- can be read
// directly off the figure without a calculator.
// Fail: open circle labeled "1"   Pass: filled circle labeled "2"
// No decision boundaries are drawn here -- this figure is for the
// k-nearest-neighbours part of the exercise, where students must find
// the nearest neighbours themselves.

pair[] fail = {
    (4,2), (1,1), (1,2), (3,6), (8,2), (7,5)
};

pair[] pass = {
    (2,4), (4,6), (2,0), (6,3), (7,4), (6,6), (8,6)
};

// The candidate to classify (kept local to this exercise rather than the
// shared `query` in supervised_common.asy, since it also sits on the
// whole-number grid here).
pair candidate = (4, 3);

// --- Style constants
real legX = 10.3;  // legend anchor: right of plot area
real legY = 6.5;   // legend anchor: vertical centre

pen gridpen = gray(0.7) + linewidth(0.3pt);

// --- Axes
drawAxes("hours studied ($x_1$)", "practice exams ($x_2$)");

// --- Background grid (lets students read exact coordinates and
// distances by eye, without needing a calculator)
for (int i = 1; i < axisMax; ++i)
    draw((i,0)--(i,yMax), gridpen);
for (int j = 1; j <= yTicks; ++j)
    draw((0,j)--(axisMax,j), gridpen);

// --- Class points
for (pair p : fail) drawClass1Point(p);
for (pair p : pass) drawClass2Point(p);

// --- Query point (the new candidate to classify)
drawQueryPoint(candidate, r * diamondScale);

// --- Legend
drawBaseLegend((legX, legY), "1 = failed", "2 = passed", "candidate to classify");

shipout(bbox(3mm, Fill(bg)));
