import supervised_common;

// --- Decision boundary splits
real splitX  = 5.0;  // x1 split (vertical)
real splitYL = 3.5;  // x2 split in left half  (x1 < splitX)
real splitYR = 5.0;  // x2 split in right half (x1 >= splitX)

// Leaf regions and their majority class:
//   R1: x1 < 5,  x2 < 3.5  → class 1
//   R2: x1 < 5,  x2 >= 3.5 → class 2
//   R3: x1 >= 5, x2 < 5.0  → class 2
//   R4: x1 >= 5, x2 >= 5.0 → class 1

// --- Data points
// Class 1: open circles with "1"
pair[] class1 = {
    // R1 (majority): 5 points
    (1.2, 1.5), (2.5, 2.5), (3.8, 1.0), (1.8, 3.0), (4.2, 2.0),
    // R2 (minority): 1 point
    (3.0, 5.0),
    // R3 (minority): 1 point
    (6.5, 2.0),
    // R4 (majority): 3 points
    (6.0, 6.0), (7.5, 5.5), (8.0, 6.5)
};

// Class 2: filled circles with "2"
pair[] class2 = {
    // R1 (minority): 1 point
    (2.0, 2.0),
    // R2 (majority): 3 points
    (1.5, 4.5), (2.8, 4.5), (4.0, 5.5),
    // R3 (majority): 4 points
    (5.5, 1.5), (7.0, 2.5), (6.5, 4.0), (8.0, 4.5),
    // R4 (minority): 2 points
    (5.5, 5.5), (7.5, 6.5)
};

// --- Style constants
real legX            = 10.3;  // legend anchor: right of plot area
real legY            = 6.5;   // legend anchor: vertical centre
real regionLabelPad  = 0.4;   // inset of region class label from plot corner
real regionLabelSize = 18;    // font size for region class labels
real splitLabelSize  = 9;     // font size for split condition labels
real fracLegGap      = 0.4;   // half-width of "$1/2$" label plus spacing

pen regionpen = fg + fontsize(regionLabelSize);

// --- Axes
drawAxes();

// --- Decision boundaries
draw((splitX, 0)--(splitX, yMax), querypen);
draw((0, splitYL)--(splitX, splitYL), querypen);
draw((splitX, splitYR)--(axisMax, splitYR), querypen);

// --- Split condition labels
label("$x_1 = 5$",   (splitX, yMax),  N, fg + fontsize(splitLabelSize));
label("$x_2 = 3.5$", (0, splitYL),    W, fg + fontsize(splitLabelSize));
label(rotate(90)*"$x_2 = 5$", (axisMax, splitYR), E, fg + fontsize(splitLabelSize));

// --- Leaf region labels (predicted class, placed in corners)
label("$1$", (regionLabelPad, regionLabelPad),                   regionpen);  // R1
label("$2$", (regionLabelPad, yMax - regionLabelPad),            regionpen);  // R2
label("$2$", (axisMax - regionLabelPad, regionLabelPad),         regionpen);  // R3
label("$1$", (axisMax - regionLabelPad, yMax - regionLabelPad),  regionpen);  // R4

// --- Class points
for (pair p : class1) drawClass1Point(p);
for (pair p : class2) drawClass2Point(p);

// --- Query point
drawQueryPoint(query, r * diamondScale);

// --- Legend
pair leg4pos = drawBaseLegend((legX, legY));
label("$1/2$", leg4pos, fg);
label("predicted class", leg4pos + (fracLegGap, 0), E, fg);

shipout(bbox(3mm, Fill(bg)));
